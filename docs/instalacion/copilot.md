# GitHub Copilot

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent copilot
```

Archivos instalados: `.github/agents/*.agent.md` y `.github/skills/`.

## Cómo empezar

En VS Code, abre el chat de GitHub Copilot con el proyecto y elige `directora` en el selector de agentes. En Copilot CLI, ejecuta `copilot`, escribe `/agent` y elige `directora`.

Si un perfil no aparece en VS Code, abre `Chat: Open Customizations` y revisa la sección Agents. La delegación, las herramientas y los permisos dependen del cliente. Este paquete está orientado al chat de VS Code y Copilot CLI.

[Agentes en VS Code](https://code.visualstudio.com/docs/agent-customization/custom-agents) · [Agentes en Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/create-custom-agents-for-cli).
