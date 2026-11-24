# Codex

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent codex
```

Archivos instalados: `.codex/agents/*.toml`, `.agents/skills/` y un bloque administrado en `AGENTS.md`.

## Cómo empezar

Abre el proyecto en Codex y crea un chat nuevo. Escribe «Actúa como Dirección de la oficina y coordina una revisión en modo lectura». El chat principal ejerce la Dirección y puede invocar los 30 subagentes.

Verifica que el proyecto esté habilitado para cargar configuración y que tu sesión permita subagentes. Los perfiles omiten el modelo y el instalador no modifica `config.toml`.

[Subagentes de Codex](https://learn.chatgpt.com/docs/agent-configuration/subagents).
