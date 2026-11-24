#!/usr/bin/env node
import { realpathSync, statSync } from 'node:fs';
import { parseArgs } from 'node:util';
import { install, restore } from './installer.mjs';
import { platforms } from './profiles.mjs';

const help = `Oficina de Agentes

  oficina-agentes list
  oficina-agentes install --agent <cliente|all> [--target <proyecto>] [--dry-run] [--force]
  oficina-agentes restore --backup <directorio> [--target <proyecto>] [--dry-run]

Clientes: ${Object.keys(platforms).join(', ')}.
El destino por defecto es la carpeta actual. La instalación escribe perfiles y skills de proyecto.
Los respaldos quedan en ~/.office-backups. Usa --backup-dir para elegir otro directorio.
`;

try {
  const { positionals: [command, ...rest], values } = parseArgs({
    allowPositionals: true,
    options: {
      agent: { type: 'string' }, target: { type: 'string', default: process.cwd() },
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
    const root = realpathSync(values.target);
    if (!statSync(root).isDirectory()) throw new Error('El destino debe ser una carpeta existente.');
    const options = { ...values, dryRun: values['dry-run'], backupDir: values['backup-dir'] };
    const result = command === 'install' ? install(root, options) : restore(root, options);
    console.log(JSON.stringify(result, null, 2));
  }
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
