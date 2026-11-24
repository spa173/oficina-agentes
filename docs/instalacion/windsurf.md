# Windsurf / Cascade

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes para Windsurf / Cascade en la raíz del proyecto abierto.
Identifica esa carpeta y ejecuta los comandos desde allí. Si hay varias raíces posibles, pregúntame cuál usar.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent windsurf --dry-run

Si la vista previa termina correctamente y el destino es el proyecto abierto, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent windsurf

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force o una instalación global.
Verifica que existan .windsurf/workflows/oficina-agentes.md y .windsurf/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre Cascade y ejecuta /oficina-agentes.
```

## Instalar desde la terminal

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent windsurf
```

Archivos instalados: `.windsurf/workflows/oficina-agentes.md`, `.windsurf/skills/` y los 31 perfiles de consulta en `.oficina-agentes/roles/`.

## Cómo empezar

Abre Cascade en el proyecto y ejecuta `/oficina-agentes`. Escribe el encargo en ese chat. Si tu cliente ya no presenta workflows de Cascade, pide que lea `.windsurf/workflows/oficina-agentes.md` como guía del encargo.

Este adaptador organiza el trabajo con un workflow manual y una biblioteca de perfiles. La instalación no registra 31 subagentes nativos en Cascade.

[Catálogo oficial de personalizaciones de Cascade](https://github.com/Windsurf-Samples/cascade-customizations-catalog) · [Compatibilidad de skills en Devin Local](https://docs.devin.ai/desktop/devin-local/customizations).
