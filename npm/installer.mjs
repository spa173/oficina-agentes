import { createHash, randomUUID } from 'node:crypto';
import { lstatSync, mkdirSync, readFileSync, realpathSync, renameSync, unlinkSync, writeFileSync } from 'node:fs';
import { homedir } from 'node:os';
import { dirname, join, resolve } from 'node:path';
import { end, packageFiles, start } from './profiles.mjs';

const configPaths = ['opencode.jsonc', 'opencode.json', '.opencode/opencode.jsonc', '.opencode/opencode.json'];
const utf8 = new TextDecoder('utf-8', { fatal: true, ignoreBOM: true });

function info(path) {
  return lstatSync(path, { throwIfNoEntry: false });
}

function targetFile(root, relative) {
  const parts = relative.split('/');
  if (parts.some((part) => !/^[a-z0-9._-]+$/i.test(part) || part === '.' || part === '..')) {
    throw new Error('Ruta fuera de la oficina: ' + relative);
  }
  let path = root;
  for (const [index, part] of parts.entries()) {
    path = join(path, part);
    const entry = info(path);
    if (!entry) continue;
    if (entry.isSymbolicLink()) throw new Error('Ruta con enlace simbólico o junction: ' + relative);
    if (index < parts.length - 1 && !entry.isDirectory()) throw new Error('Se esperaba un directorio: ' + relative);
  }
  return path;
}

function snapshot(path) {
  const entry = info(path);
  if (!entry) return null;
  if (!entry.isFile()) throw new Error('Se esperaba un archivo: ' + path);
  return { data: readFileSync(path), mode: entry.mode & 0o777 };
}

function digest(data) {
  return createHash('sha256').update(data).digest('hex');
}

function mergeBlock(original, block, path) {
  const existing = original ? utf8.decode(original) : '';
  const begin = existing.indexOf(start);
  const finish = existing.indexOf(end);
  if ((begin < 0) !== (finish < 0) ||
      (begin >= 0 && (finish < begin || existing.indexOf(start, begin + start.length) >= 0 ||
        existing.indexOf(end, finish + end.length) >= 0))) {
    throw new Error('Revisa los marcadores de la oficina en ' + path);
  }
  const eol = existing.includes('\r\n') ? '\r\n' : '\n';
  const content = utf8.decode(block).replace(/\r?\n/g, eol);
  if (begin >= 0) return Buffer.from(existing.slice(0, begin) + content + existing.slice(finish + end.length));
  const separator = existing && !existing.endsWith(eol + eol) ? (existing.endsWith(eol) ? eol : eol + eol) : '';
  return Buffer.from(existing + separator + content + eol);
}

function apply(root, changes) {
  for (const { relative, expected, data, mode } of changes) {
    const path = targetFile(root, relative);
    const current = snapshot(path);
    if ((current ? digest(current.data) : null) !== expected) {
      throw new Error('El archivo cambió durante la operación: ' + relative);
    }
    if (data === null) {
      unlinkSync(path);
    } else {
      mkdirSync(dirname(path), { recursive: true });
      targetFile(root, relative);
      const temp = join(dirname(path), '.oficina-' + randomUUID() + '.tmp');
      writeFileSync(temp, data, { mode, flag: 'wx' });
      try { renameSync(temp, path); }
      finally { if (info(temp)) unlinkSync(temp); }
    }
  }
}

export function install(root, { agent, force, dryRun, backupDir }) {
  const entries = packageFiles(agent);
  const changes = [];
  const messages = [];
  for (const [relative, entry] of entries) {
    if (entry.openCodeConfig && configPaths.some((name) => snapshot(targetFile(root, name)))) {
      messages.push('Se conservó la configuración de OpenCode. Si hace falta, selecciona directora y revisa experimental.subagent_depth en tu configuración.');
      continue;
    }
    const before = snapshot(targetFile(root, relative));
    const data = entry.merge ? mergeBlock(before?.data, entry.data, relative) : entry.data;
    if (before?.data.equals(data)) continue;
    if (before && !entry.merge && !force) throw new Error('Conflicto en ' + relative + '. Revisa el archivo antes de usar --force.');
    changes.push({ relative, before, data, expected: before ? digest(before.data) : null, mode: before?.mode ?? 0o644 });
  }
  const files = changes.map(({ relative }) => relative);
  if (dryRun || !changes.length) return { agent, dryRun, files, backup: null, messages };

  const parent = resolve(backupDir ?? join(homedir(), '.office-backups'));
  mkdirSync(parent, { recursive: true, mode: 0o700 });
  const backup = join(parent, 'npm-' + randomUUID());
  mkdirSync(backup, { mode: 0o700 });
  const items = changes.map(({ relative, before, data, expected }, index) => {
    if (before) writeFileSync(join(backup, index + '.bak'), before.data, { mode: 0o600, flag: 'wx' });
    return { relative, before: expected, after: digest(data), mode: before?.mode ?? null };
  });
  writeFileSync(join(backup, 'manifest.json'), JSON.stringify({ version: 1, project: root, agent, items }, null, 2), {
    mode: 0o600, flag: 'wx',
  });
  try {
    apply(root, changes);
  } catch (error) {
    try { restore(root, { backup, dryRun: false }); }
    catch { throw new Error(error.message + ' Revisa el respaldo antes de continuar: ' + backup); }
    throw new Error(error.message + ' Se restauraron los archivos anteriores. Respaldo: ' + backup);
  }
  return { agent, dryRun: false, files, backup, messages };
}

function isHash(value) {
  return typeof value === 'string' && /^[0-9a-f]{64}$/.test(value);
}

export function restore(root, { backup, dryRun }) {
  const folder = realpathSync(backup);
  const manifest = JSON.parse(readFileSync(targetFile(folder, 'manifest.json'), 'utf8'));
  if (manifest.version !== 1 || manifest.project !== root || !Array.isArray(manifest.items)) {
    throw new Error('El respaldo no corresponde al proyecto indicado.');
  }
  const allowed = packageFiles(manifest.agent);
  const seen = new Set();
  const changes = [];
  for (const [index, item] of manifest.items.entries()) {
    const { relative, before, after, mode } = item;
    if (!allowed.has(relative) || seen.has(relative) || !isHash(after) ||
        (before !== null && (!isHash(before) || !Number.isInteger(mode) || mode < 0 || mode > 0o777))) {
      throw new Error('Entrada de respaldo inválida.');
    }
    seen.add(relative);
    const data = before === null ? null : readFileSync(targetFile(folder, index + '.bak'));
    if (data && digest(data) !== before) throw new Error('El respaldo cambió: ' + relative);
    const current = snapshot(targetFile(root, relative));
    const expected = current ? digest(current.data) : null;
    if (expected === before) continue;
    if (expected !== after) throw new Error('El archivo se editó después de instalar: ' + relative);
    changes.push({ relative, expected, data, mode });
  }
  if (!dryRun) apply(root, changes);
  return { dryRun, files: changes.map(({ relative }) => relative) };
}
