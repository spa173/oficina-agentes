# OpenCode

## Pega este mensaje en el chat

Usa un chat con acceso a la terminal del proyecto.

```text
Instala Oficina de Agentes globalmente para mi usuario de OpenCode en este equipo.
Usa el identificador opencode y el ámbito global del usuario local.
Comprueba node --version, npx --version y git --version. Si falta Git, npx o Node.js 22+, dime qué requisito falta y detente.

Primero ejecuta esta vista previa:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent opencode --scope global --dry-run

Si la vista previa termina correctamente e indica agent=opencode, scope=global y mi carpeta personal como target, ejecuta:
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent opencode --scope global

Si la terminal solicita aprobación, muéstramela. Si hay un conflicto, detente y dime qué archivo lo causa. Conserva la configuración existente y evita --force.
Verifica que existan ~/.config/opencode/agents/directora.md y ~/.agents/skills/taste-skill/SKILL.md. Resume el resultado e indica la ruta del respaldo si hubo cambios.
Para empezar a usar la oficina, recuérdame este paso: Abre una sesión de OpenCode en el proyecto y selecciona directora.
```

## Instalación global desde la terminal

Con Node.js 22+ y Git, ejecuta:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent opencode --scope global
```

## Instalación sólo en un proyecto

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent opencode --scope project
```

Archivos instalados: `.opencode/agents/*.md`, `.agents/skills/` y `opencode.jsonc` si el proyecto carece de configuración propia.

## Cómo empezar

Ejecuta `opencode` desde el proyecto y selecciona `directora`. Comprueba el inventario con `opencode debug agents`. Usa OpenCode 2.3 o posterior para las reglas de permisos incluidas.

Cuando ya existe configuración, el instalador npm la conserva byte por byte. Para establecer la Dirección por defecto y permitir dos niveles de delegación, integra `"default_agent": "directora"` y `"experimental": { "subagent_depth": 2 }` en el archivo activo, respetando sus demás campos. Puedes continuar seleccionando `directora` manualmente.

[Agentes](https://opencode.ai/docs/agents/) · [Configuración](https://opencode.ai/docs/config/).
