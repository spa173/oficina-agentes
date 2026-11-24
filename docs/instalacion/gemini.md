# Gemini CLI

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes para Gemini CLI en la raíz del proyecto abierto.
Identifica esa carpeta y ejecuta los comandos desde allí. Si hay varias raíces posibles, pregúntame cuál usar.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini --dry-run

Si la vista previa termina correctamente y el destino es el proyecto abierto, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force o una instalación global.
Verifica que existan .gemini/agents/diseno-web.md y el bloque administrado en GEMINI.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre Gemini CLI desde el proyecto. Usa /agents list y da el encargo al chat principal.
```

## Instalar desde la terminal

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent gemini
```

Archivos instalados: `.gemini/agents/*.md`, `.gemini/skills/` y un bloque administrado en `GEMINI.md`.

## Cómo empezar

Ejecuta `gemini` en el proyecto y revisa `/agents list`. Usa `/agents reload` y `/memory reload` si ya tenías la sesión abierta. Dale el encargo al chat principal, que lee `GEMINI.md` y actúa como Dirección.

Gemini CLI impide que un subagente invoque a otro. El coordinador devuelve un encargo para el especialista y Dirección lo invoca desde el chat principal. Si los perfiles no aparecen, verifica la confianza de la carpeta y que tu configuración no desactive los subagentes.

[Subagentes](https://geminicli.com/docs/core/subagents/) · [Skills](https://geminicli.com/docs/cli/skills/) · [Contexto del proyecto](https://geminicli.com/docs/cli/gemini-md/).
