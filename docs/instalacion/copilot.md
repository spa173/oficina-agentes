# GitHub Copilot

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes globalmente para mi usuario de GitHub Copilot en este equipo.
Usa el identificador copilot y el ámbito global del usuario local.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot --scope global --dry-run

Si la vista previa termina correctamente e indica agent=copilot, scope=global y mi carpeta personal como target, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot --scope global

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force.
Verifica que existan ~/.copilot/agents/directora.agent.md y ~/.copilot/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: En Copilot CLI, escribe /agent y elige directora. En VS Code, comprueba la lista de agentes de usuario.
```

## Instalación global desde la terminal

Con Node.js 22+ y Git, ejecuta:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot --scope global
```

## Instalación sólo en un proyecto

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot --scope project
```

Archivos instalados: `.github/agents/*.agent.md` y `.github/skills/`.

## Cómo empezar

En VS Code, abre el chat de GitHub Copilot con el proyecto y elige `directora` en el selector de agentes. En Copilot CLI, ejecuta `copilot`, escribe `/agent` y elige `directora`.

Si un perfil no aparece en VS Code, abre `Chat: Open Customizations` y revisa la sección Agents. La delegación, las herramientas y los permisos dependen del cliente. Este paquete está orientado al chat de VS Code y Copilot CLI.

[Agentes en VS Code](https://code.visualstudio.com/docs/agent-customization/custom-agents) · [Agentes en Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli).
