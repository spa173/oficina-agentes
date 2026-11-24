# Cursor

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes globalmente para mi usuario de Cursor en este equipo.
Usa el identificador cursor y el ámbito global del usuario local.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor --scope global --dry-run

Si la vista previa termina correctamente e indica agent=cursor, scope=global y mi carpeta personal como target, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor --scope global

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force.
Verifica que existan ~/.cursor/agents/diseno-web.md y ~/.cursor/skills/oficina-agentes/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre un chat en modo Agent y usa /oficina-agentes o pide que cargue esa skill.
```

## Instalación global desde la terminal

Con Node.js 22+ y Git, ejecuta:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor --scope global
```

## Instalación sólo en un proyecto

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor --scope project
```

Archivos instalados: `.cursor/agents/*.md`, `.cursor/skills/` y la regla manual `.cursor/rules/oficina-agentes.mdc`.

## Cómo empezar

Abre la carpeta del proyecto en Cursor y crea un chat en modo Agent. Para una instalación global usa la skill `/oficina-agentes`. Para una instalación por proyecto adjunta la regla `@oficina-agentes`. Luego escribe el encargo en ese chat.

Para comprobar que Cursor detecta un perfil, escribe `/coord-producto-experiencia` en modo Agent y revisa si aparece entre los subagentes. Los perfiles declaran `model: inherit` y los perfiles de revisión usan `readonly: true`.

[Subagentes](https://cursor.com/docs/subagents) · [Reglas de Cursor](https://cursor.com/docs/rules) · [Skills](https://cursor.com/docs/skills).
