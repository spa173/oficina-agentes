import assert from 'node:assert/strict';
import { spawnSync } from 'node:child_process';
import { existsSync, mkdirSync, mkdtempSync, readFileSync, readdirSync, rmSync, symlinkSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const cli = fileURLToPath(new URL('../npm/cli.mjs', import.meta.url));
function run(project, ...args) {
  return spawnSync(process.execPath, [cli, ...args, '--target', project], { encoding: 'utf8' });
}
function ok(result) {
  assert.equal(result.status, 0, result.stderr);
  return JSON.parse(result.stdout);
}
function sandbox(t) {
  const root = mkdtempSync(join(tmpdir(), 'oficina-npm-'));
  const project = join(root, 'project');
  const backup = join(root, 'backup');
  mkdirSync(project);
  t.after(() => rmSync(root, { recursive: true, force: true }));
  return { root, project, backup };
}

test('all installs every profile format and ten skills without changing the selected model', (t) => {
  const { project, backup } = sandbox(t);
  const original = '# Local project rules\r\n';
  writeFileSync(join(project, 'AGENTS.md'), original);
  writeFileSync(join(project, 'opencode.jsonc'), '{ "model": "existing/choice" }\n');
  const commands = ['install', '--agent', 'all', '--backup-dir', backup];
  const preview = ok(run(project, ...commands, '--dry-run'));
  assert.ok(preview.files.length > 200);
  assert.equal(existsSync(backup), false);
  assert.deepEqual(readdirSync(project).sort(), ['AGENTS.md', 'opencode.jsonc']);
  const result = ok(run(project, ...commands));
  for (const [path, count] of [
    ['.codex/agents', 30], ['.opencode/agents', 31], ['.claude/agents', 31],
    ['.cursor/agents', 30], ['.github/agents', 31], ['.gemini/agents', 30],
    ['.agents/agents', 31], ['.oficina-agentes/roles', 31],
    ['.agents/skills', 10], ['.claude/skills', 10], ['.cursor/skills', 10],
    ['.gemini/skills', 10], ['.github/skills', 10], ['.windsurf/skills', 10],
  ]) assert.equal(readdirSync(join(project, path)).length, count, path);
  assert.match(readFileSync(join(project, '.cursor/agents/diseno-web.md'), 'utf8'), /^readonly: true$/m);
  assert.match(readFileSync(join(project, '.agents/agents/directora.md'), 'utf8'), /^mainAgent: true$/m);
  assert.match(readFileSync(join(project, '.github/agents/directora.agent.md'), 'utf8'), /^name: "directora"$/m);
  assert.match(readFileSync(join(project, 'GEMINI.md'), 'utf8'), /Gemini CLI no permite delegación anidada/);
  assert.ok(existsSync(join(project, '.windsurf/workflows/oficina-agentes.md')));
  assert.equal(readFileSync(join(project, 'opencode.jsonc'), 'utf8'), '{ "model": "existing/choice" }\n');
  assert.ok(readFileSync(join(project, 'AGENTS.md'), 'utf8').startsWith(original));
  assert.deepEqual(ok(run(project, ...commands)).files, []);
  ok(run(project, 'restore', '--backup', result.backup));
  assert.equal(readFileSync(join(project, 'AGENTS.md'), 'utf8'), original);
  assert.equal(existsSync(join(project, '.cursor/agents/diseno-web.md')), false);
});

test('single-target installation detects conflicts before writing and restores explicit replacements', (t) => {
  const { project, backup } = sandbox(t);
  mkdirSync(join(project, '.cursor/agents'), { recursive: true });
  const local = join(project, '.cursor/agents/backend.md');
  writeFileSync(local, 'personal backend\n');
  const args = ['install', '--agent', 'cursor', '--backup-dir', backup];
  const rejected = run(project, ...args);
  assert.notEqual(rejected.status, 0);
  assert.match(rejected.stderr, /Conflicto.*backend\.md/);
  assert.equal(existsSync(backup), false);
  assert.equal(existsSync(join(project, '.cursor/skills')), false);
  const result = ok(run(project, ...args, '--force'));
  assert.equal(existsSync(join(project, '.claude')), false);
  const installed = readFileSync(local);
  writeFileSync(local, 'modified after install');
  assert.notEqual(run(project, 'restore', '--backup', result.backup).status, 0);
  writeFileSync(local, installed);
  ok(run(project, 'restore', '--backup', result.backup));
  assert.equal(readFileSync(local, 'utf8'), 'personal backend\n');
});

test('installation rejects a linked destination and preserves ambiguous instruction blocks', (t) => {
  const { root, project, backup } = sandbox(t);
  const outside = join(root, 'outside');
  mkdirSync(outside);
  symlinkSync(outside, join(project, '.cursor'), 'junction');
  const linked = run(project, 'install', '--agent', 'cursor', '--backup-dir', backup);
  assert.match(linked.stderr, /enlace/i);
  assert.deepEqual(readdirSync(outside), []);
  writeFileSync(join(project, 'GEMINI.md'), '<!-- oficina-unificada:inicio -->\n');
  const malformed = run(project, 'install', '--agent', 'gemini', '--backup-dir', backup);
  assert.match(malformed.stderr, /marcadores/i);
  assert.equal(existsSync(join(project, '.gemini')), false);
});
