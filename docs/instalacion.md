# Instalación de la oficina

## npm y npx

Cada guía incluye un **mensaje listo para pegar en el chat del agente**. El mensaje le pide que compruebe los requisitos, haga una vista previa e instale la oficina en el proyecto abierto si el destino es correcto y la vista previa termina sin conflictos. Si el cliente pide aprobar el uso de terminal, confirma el comando desde su interfaz.

Instala **Node.js 22+ y Git**. Abre la terminal en la raíz del proyecto que quieres configurar y ejecuta el comando de tu cliente:

| Cliente | Guía específica |
|---|---|
| Cursor | [Agentes, skills y chat principal](instalacion/cursor.md) |
| Codex | [Subagentes y AGENTS.md](instalacion/codex.md) |
| OpenCode | [Agente principal y configuración](instalacion/opencode.md) |
| Claude Code | [Perfiles y comando de inicio](instalacion/claude.md) |
| GitHub Copilot | [VS Code y Copilot CLI](instalacion/copilot.md) |
| Gemini CLI | [Perfiles y delegación desde el chat principal](instalacion/gemini.md) |
| Google Antigravity | [App y CLI](instalacion/antigravity.md) |
| Windsurf | [Workflow manual y skills](instalacion/windsurf.md) |

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes list
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor --dry-run
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent cursor
```

Usa `--agent all` para instalar los ocho adaptadores o `--target "RUTA_DEL_PROYECTO"` para usar una carpeta existente distinta. El comando funciona desde GitHub, sin publicación en el registro de npm. Para tener el comando disponible localmente:

```shell
npm install --global "git+https://github.com/spa173/oficina-agentes.git"
oficina-agentes install --agent cursor
```

La instalación global de **npm** pone el comando en tu PATH. Los perfiles se instalan en el proyecto indicado. El instalador de npm genera un respaldo bajo `~/.office-backups/` cuando hay cambios. Si un perfil existente tiene contenido distinto, revisa el archivo antes de usar `--force`. Consulta [recuperación](recuperacion.md).

Si prefieres clonar el repositorio, ejecuta `node npm/cli.mjs install --agent cursor --target "RUTA_DEL_PROYECTO"` desde la copia. No hay dependencias npm para instalar.

## Instalador alternativo PowerShell

Esta alternativa instala Codex, OpenCode y Claude Code, en un proyecto o en las rutas personales del cliente. Requiere PowerShell 7.4+. Para ejecutar el auditor web, instala Python 3.11+ y verifica `python --version`.

```shell
git clone https://github.com/spa173/oficina-agentes.git
cd oficina-agentes
```

### Instalar en un proyecto

Desde el repositorio de la oficina, sustituye `RUTA_DEL_PROYECTO` por la ruta de una carpeta que ya exista. Puedes usar `.` para explorar la oficina en este mismo repositorio.

```shell
pwsh -NoProfile -File scripts/Install-Office.ps1 -Platform All -Scope Project -Target "RUTA_DEL_PROYECTO" -DryRun
pwsh -NoProfile -File scripts/Install-Office.ps1 -Platform All -Scope Project -Target "RUTA_DEL_PROYECTO"
```

| Selección | Dónde quedan los perfiles | Cómo encargar trabajo |
|---|---|---|
| `-Platform Codex` | `.codex/agents/`, `AGENTS.md` y `.agents/skills/` | Abre un chat nuevo con el proyecto y escribe el encargo en el chat principal. |
| `-Platform OpenCode` | `.opencode/agents/`, configuración del proyecto de OpenCode y `.agents/skills/` | Abre OpenCode 2.3+ en el proyecto y elige `directora`. Usa `opencode debug agents` para inspeccionar el inventario. |
| `-Platform Claude` | `.claude/agents/` y `.claude/skills/` | Desde el proyecto, ejecuta `claude --agent directora`. Usa `claude plugin validate .claude/agents` para comprobar los archivos. |
| `-Platform All` | Las tres instalaciones anteriores. | Sigue el paso de inicio de tu cliente. |

[Subagentes de Codex](https://learn.chatgpt.com/docs/agent-configuration/subagents) · [Agentes de OpenCode](https://opencode.ai/docs/agents/) · [Subagentes de Claude Code](https://code.claude.com/docs/en/sub-agents).

### Instalar perfiles para todos tus proyectos

Desde el repositorio de la oficina, elige la plataforma o usa `All`. El instalador global usa las rutas por defecto de tu perfil de usuario: `~/.codex`, `~/.config/opencode`, `~/.claude` y `~/.agents/skills`. Si tu cliente usa un directorio de configuración personalizado, instala por proyecto o consulta cómo configurar la ubicación en ese cliente.

```shell
pwsh -NoProfile -File scripts/Install-Office.ps1 -Platform All -Scope Global -DryRun
pwsh -NoProfile -File scripts/Install-Office.ps1 -Platform All -Scope Global
```

El instalador informa qué archivos cambian y la ubicación del respaldo. Si encuentra un archivo distinto con el mismo nombre, detiene la operación. Revisa ese archivo antes de aplicar `-Force`, que también genera un respaldo. Consulta [recuperación](recuperacion.md) para deshacer la instalación.

## Modelo, permisos y conectores

Elige el modelo en el cliente. Claude Code declara `model: inherit` en los perfiles. Codex y OpenCode conservan el modelo de la configuración de sesión. Los tipos de herramientas, permisos, aprobaciones y posibilidad de delegación anidada varían por cliente y cuenta. Si un coordinador no puede invocar al especialista, devuelve la solicitud de delegación a Dirección y registra el límite.

Conecta GitHub, navegador, bases de datos u otros servicios desde el cliente que los usará. Los perfiles declaran capacidades y funcionan con los accesos que tú autorices. [Guía de conexiones](connections.md).

## Otros agentes

Si tu cliente admite instrucciones de proyecto, adapta las responsabilidades de `office/roles/directora.md` y usa `office/roles/` como fuente para crear sus perfiles nativos. Si admite Agent Skills, copia las carpetas completas de `skills/` a su ubicación documentada.
