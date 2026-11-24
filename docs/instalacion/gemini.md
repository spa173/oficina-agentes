# Gemini CLI

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes globalmente para mi usuario de Gemini CLI en este equipo.
Usa el identificador gemini y el ámbito global del usuario local.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini --scope global --dry-run

Si la vista previa termina correctamente e indica agent=gemini, scope=global y mi carpeta personal como target, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini --scope global

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force.
Verifica que existan ~/.gemini/agents/diseno-web.md y el bloque en ~/.gemini/GEMINI.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre Gemini CLI desde el proyecto. Usa /agents list y da el encargo al chat principal.
```

## Instalación global desde la terminal

Con Node.js 22+ y Git, ejecuta:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini --scope global
```

## Instalación sólo en un proyecto

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini --scope project
```

Archivos instalados: `.gemini/agents/*.md`, `.gemini/skills/` y un bloque administrado en `GEMINI.md`.

## Cómo empezar

Ejecuta `gemini` en el proyecto y revisa `/agents list`. Usa `/agents reload` y `/memory reload` si ya tenías la sesión abierta. Dale el encargo al chat principal, que lee `GEMINI.md` y actúa como Dirección.

Gemini CLI impide que un subagente invoque a otro. El coordinador devuelve un encargo para el especialista y Dirección lo invoca desde el chat principal. Si los perfiles no aparecen, verifica la confianza de la carpeta y que tu configuración no desactive los subagentes.

[Subagentes](https://geminicli.com/docs/core/subagents/) · [Skills](https://geminicli.com/docs/cli/skills/) · [Contexto del proyecto](https://geminicli.com/docs/cli/gemini-md/).
