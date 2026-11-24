# Google Antigravity

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes globalmente para mi usuario de Google Antigravity en este equipo.
Usa el identificador antigravity y el ámbito global del usuario local.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity --scope global --dry-run

Si la vista previa termina correctamente e indica agent=antigravity, scope=global y mi carpeta personal como target, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity --scope global

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force.
Verifica que existan ~/.gemini/config/agents/directora.md y ~/.gemini/config/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Selecciona directora en el proyecto o desde /agents en la CLI.
```

## Instalación global desde la terminal

Con Node.js 22+ y Git, ejecuta:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity --scope global
```

## Instalación sólo en un proyecto

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity --scope project
```

Archivos instalados: `.agents/agents/*.md` y `.agents/skills/`. `directora` es seleccionable como agente principal y los demás se definen como subagentes.

## Cómo empezar

Abre el proyecto en Antigravity App y elige `directora` en el selector de agentes del chat. En Antigravity CLI, abre el panel `/agents` y selecciónala como agente principal.

Usa una versión que admita perfiles Markdown personalizados. Los perfiles declaran `model: inherit`. En sesiones sin navegador, registra qué observaciones de diseño quedaron sin verificar.

[Subagentes personalizados](https://antigravity.google/docs/subagents) · [Panel de agentes de la CLI](https://antigravity.google/docs/cli/commands/agents).
