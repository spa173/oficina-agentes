# Claude Code

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes para Claude Code en la raíz del proyecto abierto.
Identifica esa carpeta y ejecuta los comandos desde allí. Si hay varias raíces posibles, pregúntame cuál usar.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent claude --dry-run

Si la vista previa termina correctamente y el destino es el proyecto abierto, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent claude

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force o una instalación global.
Verifica que existan .claude/agents/directora.md y .claude/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Inicia una sesión nueva con claude --agent directora.
```

## Instalar desde la terminal

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent claude
```

Archivos instalados: `.claude/agents/*.md` y `.claude/skills/`.

## Cómo empezar

Desde el proyecto inicia `claude --agent directora`. Comprueba el formato con `claude plugin validate .claude/agents`. En una sesión abierta, revisa los perfiles con `/agents`.

Los perfiles declaran `model: inherit`. Las herramientas y la delegación se rigen por las capacidades y permisos efectivos de Claude Code.

[Subagentes de Claude Code](https://code.claude.com/docs/en/sub-agents) · [Skills](https://code.claude.com/docs/en/skills).
