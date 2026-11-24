# Google Antigravity

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes para Google Antigravity en la raíz del proyecto abierto.
Identifica esa carpeta y ejecuta los comandos desde allí. Si hay varias raíces posibles, pregúntame cuál usar.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity --dry-run

Si la vista previa termina correctamente y el destino es el proyecto abierto, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force o una instalación global.
Verifica que existan .agents/agents/directora.md y .agents/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Selecciona directora en el proyecto o desde /agents en la CLI.
```

## Instalar desde la terminal

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity
```

Archivos instalados: `.agents/agents/*.md` y `.agents/skills/`. `directora` es seleccionable como agente principal y los demás se definen como subagentes.

## Cómo empezar

Abre el proyecto en Antigravity App y elige `directora` en el selector de agentes del chat. En Antigravity CLI, abre el panel `/agents` y selecciónala como agente principal.

Usa una versión que admita perfiles Markdown personalizados. Los perfiles declaran `model: inherit`. En sesiones sin navegador, registra qué observaciones de diseño quedaron sin verificar.

[Subagentes personalizados](https://antigravity.google/docs/subagents) · [Panel de agentes de la CLI](https://antigravity.google/docs/cli/commands/agents).
