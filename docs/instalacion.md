# Instalación de la oficina

Necesitas Git, PowerShell 7.4 o posterior y al menos uno de los clientes compatibles. Para las pruebas de skills y el auditor web, instala Python 3.11 o posterior y comprueba que `python --version` funciona. Los mismos comandos de PowerShell se usan en Windows, macOS y Linux.

```shell
git clone https://github.com/spa173/oficina-agentes.git
cd oficina-agentes
```

## Instalar en un proyecto

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

## Instalar para todos tus proyectos

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

Si tu cliente admite instrucciones de proyecto, adapta las responsabilidades de `office/roles/directora.md` y usa `office/roles/` como fuente para crear sus perfiles nativos. Si admite Agent Skills, copia las carpetas completas de `skills/` a su ubicación documentada. La detección y delegación automáticas se incluyen para Codex, OpenCode y Claude Code.
