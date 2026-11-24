# Codex

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes globalmente para mi usuario de Codex en este equipo.
Usa el identificador codex y el ámbito global del usuario local.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex --scope global --dry-run

Si la vista previa termina correctamente e indica agent=codex, scope=global y mi carpeta personal como target, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex --scope global

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force.
Verifica que existan ~/.codex/agents/diseno-web.toml y el bloque en ~/.codex/AGENTS.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre un chat nuevo en Codex y dale el encargo a Dirección en el chat principal.
```

## Instalación global desde la terminal

Con Node.js 22+ y Git, ejecuta:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex --scope global
```

## Instalación sólo en un proyecto

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex --scope project
```

Archivos instalados: `.codex/agents/*.toml`, `.agents/skills/` y un bloque administrado en `AGENTS.md`.

## Cómo empezar

Abre un chat nuevo en Codex. El chat principal ejerce la Dirección y muestra sus subagentes cuando los invoca. Escribe «Actúa como Dirección de la Oficina de Agentes. Pide a `coord-producto-experiencia` un resumen del alcance del proyecto en modo lectura, sin convocar otros especialistas». En Codex CLI, `/subagents` muestra los subagentes activos.

La instalación global usa `~/.codex/agents/` y `~/.codex/AGENTS.md`. Si existe un `AGENTS.override.md` con instrucciones, Codex le da prioridad. Si la vista previa devuelve rutas `.cursor/`, revisa que el comando use `--agent codex --scope global`.

Verifica que el proyecto esté habilitado para cargar configuración y que tu sesión permita subagentes. Los perfiles omiten el modelo y el instalador no modifica `config.toml`.

[Subagentes de Codex](https://learn.chatgpt.com/docs/agent-configuration/subagents).
