# Cursor

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes para Cursor en la raíz del proyecto abierto.
Identifica esa carpeta y ejecuta los comandos desde allí. Si hay varias raíces posibles, pregúntame cuál usar.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor --dry-run

Si la vista previa termina correctamente y el destino es el proyecto abierto, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force o una instalación global.
Verifica que existan .cursor/agents/diseno-web.md y .cursor/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre un chat en modo Agent y adjunta @oficina-agentes.
```

## Instalar desde la terminal

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor
```

Archivos instalados: `.cursor/agents/*.md`, `.cursor/skills/` y la regla manual `.cursor/rules/oficina-agentes.mdc`.

## Cómo empezar

Abre la carpeta del proyecto en Cursor y crea un chat en modo Agent. Adjunta `@oficina-agentes` y escribe el encargo. El chat principal actúa como Dirección con esa regla. En un chat nuevo, vuelve a adjuntarla.

Para comprobar que Cursor detecta un perfil, escribe `/coord-producto-experiencia` en modo Agent y revisa si aparece entre los subagentes. Los perfiles declaran `model: inherit` y los perfiles de revisión usan `readonly: true`.

[Subagentes](https://cursor.com/docs/subagents) · [Reglas de Cursor](https://cursor.com/docs/rules) · [Skills](https://cursor.com/docs/skills).
