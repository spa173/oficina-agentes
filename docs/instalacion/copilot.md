# GitHub Copilot

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes para GitHub Copilot en la raíz del proyecto abierto.
Identifica esa carpeta y ejecuta los comandos desde allí. Si hay varias raíces posibles, pregúntame cuál usar.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot --dry-run

Si la vista previa termina correctamente y el destino es el proyecto abierto, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force o una instalación global.
Verifica que existan .github/agents/directora.agent.md y .github/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Selecciona directora en el chat de VS Code o mediante /agent en Copilot CLI.
```

## Instalar desde la terminal

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot
```

Archivos instalados: `.github/agents/*.agent.md` y `.github/skills/`.

## Cómo empezar

En VS Code, abre el chat de GitHub Copilot con el proyecto y elige `directora` en el selector de agentes. En Copilot CLI, ejecuta `copilot`, escribe `/agent` y elige `directora`.

Si un perfil no aparece en VS Code, abre `Chat: Open Customizations` y revisa la sección Agents. La delegación, las herramientas y los permisos dependen del cliente. Este paquete está orientado al chat de VS Code y Copilot CLI.

[Agentes en VS Code](https://code.visualstudio.com/docs/agent-customization/custom-agents) · [Agentes en Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli).
