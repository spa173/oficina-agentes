#!/usr/bin/env node
import { realpathSync, statSync } from 'node:fs';
import { homedir } from 'node:os';
import { resolve } from 'node:path';
import { parseArgs } from 'node:util';
import { install, restore } from './installer.mjs';
import { platforms } from './profiles.mjs';

const help = `Oficina de Agentes

  oficina-agentes list
  oficina-agentes install --agent <cliente|all> [--scope project|global] [--target <proyecto>] [--dry-run] [--force]
  oficina-agentes restore --backup <directorio> [--scope project|global] [--target <proyecto>] [--dry-run]

Clientes: ${Object.keys(platforms).join(', ')}.
El destino por defecto es la carpeta actual. Con --scope global se usan las rutas personales del cliente.
Los respaldos quedan en ~/.office-backups. Usa --backup-dir para elegir otro directorio.
`;

function checkCustomLocations(profile, agent) {
  const locations = [
    ['codex', 'CODEX_HOME', '.codex'],
    ['claude', 'CLAUDE_CONFIG_DIR', '.claude'],
    ['opencode', 'XDG_CONFIG_HOME', '.config'],
  ];
  const normalize = (path) => process.platform === 'win32' ? resolve(path).toLowerCase() : resolve(path);
  for (const [client, variable, standard] of locations) {
    const actual = process.env[variable];
    if ((agent === client || agent === 'all') && actual &&
        normalize(actual) !== normalize(resolve(profile, standard))) {
      throw new Error(variable + ' indica una ruta personalizada. Usa --scope project o instala los perfiles en la ruta que usa tu cliente.');
    }
  }
}

try {
  const { positionals: [command, ...rest], values } = parseArgs({
    allowPositionals: true,
    options: {
      agent: { type: 'string' }, target: { type: 'string' }, scope: { type: 'string', default: 'project' },
      backup: { type: 'string' }, 'backup-dir': { type: 'string' },
      'dry-run': { type: 'boolean', default: false }, force: { type: 'boolean', default: false },
      help: { type: 'boolean', short: 'h' },
    },
  });
  if (!command || values.help) {
    console.log(help);
  } else if (command === 'list' && !rest.length) {
    console.log(Object.keys(platforms).join('\n'));
  } else {
    if (rest.length || !['install', 'restore'].includes(command)) throw new Error('Comando inválido. Usa --help.');
    if (command === 'install' && !values.agent) throw new Error('Elige un cliente con --agent. Usa list para ver las opciones.');
    if (command === 'restore' && !values.backup) throw new Error('Indica el respaldo con --backup.');
    if (!['project', 'global'].includes(values.scope)) throw new Error('--scope acepta project o global.');
    if (values.scope === 'global' && values.target !== undefined) {
      throw new Error('--target sólo se admite con --scope project.');
    }
    const root = realpathSync(values.scope === 'global' ? homedir() : values.target ?? process.cwd());
    if (!statSync(root).isDirectory()) throw new Error('El destino debe ser una carpeta existente.');
    if (command === 'install' && values.scope === 'global') checkCustomLocations(root, values.agent);
    const options = { ...values, dryRun: values['dry-run'], backupDir: values['backup-dir'] };
    const result = command === 'install' ? install(root, options) : restore(root, options);
    console.log(JSON.stringify(result, null, 2));
  }
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
