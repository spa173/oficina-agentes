# Gemini CLI

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini
```

Archivos instalados: `.gemini/agents/*.md`, `.gemini/skills/` y un bloque administrado en `GEMINI.md`.

## Cómo empezar

Ejecuta `gemini` en el proyecto y revisa `/agents list`. Usa `/agents reload` y `/memory reload` si ya tenías la sesión abierta. Dale el encargo al chat principal, que lee `GEMINI.md` y actúa como Dirección.

Gemini CLI impide que un subagente invoque a otro. El coordinador devuelve un encargo para el especialista y Dirección lo invoca desde el chat principal. Si los perfiles no aparecen, verifica la confianza de la carpeta y que tu configuración no desactive los subagentes.

[Subagentes](https://geminicli.com/docs/core/subagents/) · [Skills](https://geminicli.com/docs/cli/skills/) · [Contexto del proyecto](https://geminicli.com/docs/cli/gemini-md/).
