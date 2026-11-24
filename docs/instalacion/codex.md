# Codex

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes para Codex en la raíz del proyecto abierto.
Identifica esa carpeta y ejecuta los comandos desde allí. Si hay varias raíces posibles, pregúntame cuál usar.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex --dry-run

Si la vista previa termina correctamente y el destino es el proyecto abierto, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force o una instalación global.
Verifica que existan .codex/agents/diseno-web.toml y el bloque administrado en AGENTS.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre un chat nuevo en este proyecto y dale el encargo a Dirección en el chat principal.
```

## Instalar desde la terminal

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex
```

Archivos instalados: `.codex/agents/*.toml`, `.agents/skills/` y un bloque administrado en `AGENTS.md`.

## Cómo empezar

Abre el proyecto en Codex y crea un chat nuevo. Escribe «Actúa como Dirección de la oficina y coordina una revisión en modo lectura». El chat principal ejerce la Dirección y puede invocar los 30 subagentes.

Verifica que el proyecto esté habilitado para cargar configuración y que tu sesión permita subagentes. Los perfiles omiten el modelo y el instalador no modifica `config.toml`.

[Subagentes de Codex](https://learn.chatgpt.com/docs/agent-configuration/subagents).
