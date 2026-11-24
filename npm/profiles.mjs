import { readFileSync, readdirSync } from 'node:fs';

const root = new URL('../', import.meta.url);
const asset = (path) => readFileSync(new URL(path, root));
const roles = JSON.parse(asset('office/registry.json')).profiles;
const skillIds = [...new Set(roles.flatMap((role) => role.skills))].sort();
export const platforms = Object.freeze({
  codex: '.agents/skills',
  opencode: '.agents/skills',
  claude: '.claude/skills',
  cursor: '.cursor/skills',
  copilot: '.github/skills',
  gemini: '.gemini/skills',
  antigravity: '.agents/skills',
  windsurf: '.windsurf/skills',
});
export const start = '<!-- oficina-unificada:inicio -->';
export const end = '<!-- oficina-unificada:fin -->';

function prompt(role) {
  const text = asset(role.prompt).toString('utf8').trimEnd().replace(/\r\n/g, '\n');
  if (!role.skills.length) return text;
  return text + '\n\nSkills del rol. Carga sólo las pertinentes al encargo: ' + role.skills.join(', ') + '.';
}

function markdown(role, fields, body = prompt(role)) {
  const header = Object.entries({ name: role.id, description: role.description, ...fields })
    .map(([key, value]) => `${key}: ${JSON.stringify(value)}`).join('\n');
  return `---\n${header}\n---\n\n${body}\n`;
}

function* assets(directory) {
  for (const entry of readdirSync(new URL(directory + '/', root), { withFileTypes: true })) {
    if (!/^[a-z0-9][a-z0-9._-]*$/i.test(entry.name)) continue;
    const path = directory + '/' + entry.name;
    if (entry.isDirectory()) yield* assets(path);
    else if (entry.isFile()) yield path;
  }
}

export function packageFiles(selection) {
  if (selection !== 'all' && !Object.hasOwn(platforms, selection)) throw new Error('Agente desconocido: ' + selection);
  const clients = selection === 'all' ? Object.keys(platforms) : [selection];
  const files = new Map();
  const add = (path, data, options = {}) => files.set(path, { data: Buffer.from(data), ...options });
  const director = roles.find((role) => role.kind === 'director');
  const directorPrompt = prompt(director);
  const geminiLimit = 'Gemini CLI no permite delegación anidada. En este cliente, Dirección puede invocar directamente al especialista autorizado tras recibir del coordinador un brief con su nombre, alcance y entregable. Los coordinadores preparan ese brief y devuelven el resultado al chat principal.';

  for (const client of clients) {
    for (const role of roles) {
      const { id, kind, permission_set, capabilities } = role;
      const primary = kind === 'director';
      const readonly = permission_set === 'readonly';
      const canDelegate = primary || kind === 'coordinator';
      const research = capabilities.includes('web_research');
      if (client === 'codex' && !primary) {
        add(`.codex/agents/${id}.toml`, asset(`.codex/agents/${id}.toml`));
      } else if (client === 'opencode' || client === 'claude') {
        const path = `.${client}/agents/${id}.md`;
        add(path, asset(path));
      } else if (client === 'cursor' && !primary) {
        // Cursor's documented inherit sentinel keeps the parent model.
        add(`.cursor/agents/${id}.md`, markdown(role, { model: 'inherit', readonly }));
      } else if (client === 'copilot') {
        const tools = ['read', 'search'];
        if (canDelegate) tools.push('agent');
        if (!readonly) tools.push('edit', 'execute');
        if (id === 'qa') tools.push('execute');
        if (research) tools.push('web');
        add(`.github/agents/${id}.agent.md`, markdown(role, { tools }));
      } else if (client === 'gemini' && !primary) {
        const tools = ['read_file', 'list_directory', 'glob', 'grep_search', 'activate_skill'];
        if (!readonly) tools.push('write_file', 'replace', 'run_shell_command');
        if (id === 'qa') tools.push('run_shell_command');
        if (research) tools.push('google_web_search', 'web_fetch');
        const body = kind === 'coordinator' ? prompt(role) + '\n\n' + geminiLimit : prompt(role);
        add(`.gemini/agents/${id}.md`, markdown(role, { kind: 'local', tools }, body));
      } else if (client === 'antigravity') {
        const tools = ['view_file', 'grep_search', 'find_by_name'];
        if (canDelegate) tools.push('invoke_subagent', 'send_message');
        if (!readonly) tools.push('replace_file_content', 'write_to_file', 'run_command');
        if (id === 'qa') tools.push('run_command');
        if (research) tools.push('search_web', 'read_url_content');
        add(`.agents/agents/${id}.md`, markdown(role, {
          mainAgent: primary, subagent: !primary, model: 'inherit', tools,
          skills: role.skills.map((skill) => `skills/${skill}`),
        }));
      } else if (client === 'windsurf') {
        add(`.oficina-agentes/roles/${id}.md`, prompt(role) + '\n');
      }
    }
    if (client === 'codex') {
      const instructions = asset('AGENTS.md').toString('utf8');
      const block = instructions.slice(instructions.indexOf(start), instructions.indexOf(end) + end.length);
      add('AGENTS.md', block, { merge: true });
    }
    if (client === 'opencode') add('opencode.jsonc', asset('opencode.jsonc'), { openCodeConfig: true });
    if (client === 'cursor') {
      add('.cursor/rules/oficina-agentes.mdc', `---\nalwaysApply: false\n---\n\n${directorPrompt}\n`);
    }
    if (client === 'gemini') {
      add('GEMINI.md', `${start}\n\n${directorPrompt}\n\n## Delegación en Gemini CLI\n${geminiLimit}\n\n${end}`, { merge: true });
    }
    if (client === 'windsurf') {
      add('.windsurf/workflows/oficina-agentes.md', [
        '---',
        'description: Organiza un encargo con los perfiles de la Oficina de Agentes.',
        '---',
        '',
        '# Oficina de Agentes',
        '',
        'Lee `.oficina-agentes/roles/directora.md` para organizar el encargo de la persona usuaria.',
        'Consulta sólo los perfiles de `.oficina-agentes/roles/` y las skills de `.windsurf/skills/` pertinentes al encargo.',
        'En Cascade, aplica los perfiles como guías de trabajo. Si la sesión carece de agentes configurados, coordina en el chat principal y declara ese límite. Respeta las autorizaciones descritas en los perfiles.',
        '',
      ].join('\n'));
    }
    for (const skill of skillIds) {
      for (const source of assets('skills/' + skill)) {
        add(platforms[client] + '/' + source.slice('skills/'.length), asset(source));
      }
    }
  }
  return files;
}
