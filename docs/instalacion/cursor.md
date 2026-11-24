# Cursor

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor
```

Archivos instalados: `.cursor/agents/*.md`, `.cursor/skills/` y la regla manual `.cursor/rules/oficina-agentes.mdc`.

## Cómo empezar

Abre la carpeta del proyecto en Cursor y crea un chat en modo Agent. Adjunta `@oficina-agentes` y escribe el encargo. El chat principal actúa como Dirección con esa regla. En un chat nuevo, vuelve a adjuntarla.

Para comprobar que Cursor detecta un perfil, escribe `/coord-producto-experiencia` en modo Agent y revisa si aparece entre los subagentes. Los perfiles declaran `model: inherit` y los perfiles de revisión usan `readonly: true`.

[Subagentes](https://cursor.com/docs/subagents) · [Reglas de Cursor](https://cursor.com/docs/rules) · [Skills](https://cursor.com/docs/skills).
