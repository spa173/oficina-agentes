# Google Antigravity

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent antigravity
```

Archivos instalados: `.agents/agents/*.md` y `.agents/skills/`. `directora` es seleccionable como agente principal y los demás se definen como subagentes.

## Cómo empezar

Abre el proyecto en Antigravity App y elige `directora` en el selector de agentes del chat. En Antigravity CLI, abre el panel `/agents` y selecciónala como agente principal.

Usa una versión que admita perfiles Markdown personalizados. Los perfiles declaran `model: inherit`. En sesiones sin navegador, registra qué observaciones de diseño quedaron sin verificar.

[Subagentes personalizados](https://antigravity.google/docs/subagents) · [Panel de agentes de la CLI](https://antigravity.google/docs/cli/commands/agents).
