# Claude Code

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent claude
```

Archivos instalados: `.claude/agents/*.md` y `.claude/skills/`.

## Cómo empezar

Desde el proyecto inicia `claude --agent directora`. Comprueba el formato con `claude plugin validate .claude/agents`. En una sesión abierta, revisa los perfiles con `/agents`.

Los perfiles declaran `model: inherit`. Las herramientas y la delegación se rigen por las capacidades y permisos efectivos de Claude Code.

[Subagentes de Claude Code](https://code.claude.com/docs/en/sub-agents) · [Skills](https://code.claude.com/docs/en/skills).
