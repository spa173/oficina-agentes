# Oficina de Agentes

Una oficina de **31 perfiles** y **10 skills** para Codex, OpenCode y Claude Code. Dale el trabajo a Dirección y deja que convoque a los departamentos necesarios. Incluye investigación de referencias para diseño web, revisiones de calidad y seguridad, y contratos para entregar trabajo entre agentes.

[Instalación](docs/instalacion.md) · [Departamentos](docs/guia-departamentos-y-delegacion.md) · [Diseño Web](docs/guia-diseno-web.md) · [Conexiones MCP](docs/connections.md)

La fuente canónica es [`office/registry.json`](office/registry.json): fija identificadores, jerarquía, departamentos, prompts, permisos, skills y capacidades. Los prompts viven en `office/roles/`, los contratos en `office/contracts/` y las políticas en `office/permission-sets/` y `office/capabilities.json`.

`scripts/Build-Office.ps1` genera los perfiles para las tres plataformas:

| Plataforma | Dirección | Perfiles subordinados |
|---|---|---|
| Codex | El chat principal recibe el bloque administrado de `AGENTS.md`. | 30 subagentes TOML en `.codex/agents/`: cinco coordinadores y veinticinco especialistas. |
| OpenCode | `directora` es el agente primario. | 30 subagentes Markdown en `.opencode/agents/`; 31 archivos contando `directora`. |
| Claude Code | Inicia con `claude --agent directora`. | 30 perfiles subordinados Markdown en `.claude/agents/`, además de `directora`. |

Los archivos generados llevan una cabecera con su origen. Edita `office/` y regenera; las verificaciones detectan cambios manuales en las salidas. La plantilla del bloque de Dirección es `templates/AGENTS-oficina.md`; el generador conserva las instrucciones de `AGENTS.md` fuera de sus marcadores.

## Inicio rápido

Clona el repositorio. Con PowerShell 7.4 o posterior, instala en el proyecto donde quieres trabajar. Cambia `All` por `Codex`, `OpenCode` o `Claude` para elegir un entorno.

```shell
git clone https://github.com/spa173/oficina-agentes.git
cd oficina-agentes
pwsh -NoProfile -File scripts/Install-Office.ps1 -Platform All -Scope Project -Target . -DryRun
pwsh -NoProfile -File scripts/Install-Office.ps1 -Platform All -Scope Project -Target .
```

Si ya tienes un proyecto, indica su ruta con `-Target` y abre una sesión nueva allí. Entrega el encargo en el chat principal de Codex, a `directora` en OpenCode o a la sesión iniciada con `claude --agent directora`.

La ruta de trabajo es **Dirección → coordinador → especialista**. OpenCode configura `experimental.subagent_depth = 2`. Ningún perfil fija un modelo o proveedor; hereda la selección de la sesión. En Codex, los subagentes también heredan los permisos efectivos del entorno: sus instrucciones no crean un sandbox separado.

La [guía de departamentos y delegación](docs/guia-departamentos-y-delegacion.md) detalla las rutas, entregables y ejemplos de encargo.

## Generar y verificar

Desde la raíz del kit, con PowerShell 7.4+ y Python 3.11+:

```powershell
pwsh -NoProfile -File scripts/Build-Office.ps1 -Platform All
pwsh -NoProfile -File scripts/Build-Office.ps1 -Platform All -Check
pwsh -NoProfile -File scripts/Test-Office.Core.ps1
pwsh -NoProfile -File scripts/Test-Office.Skills.ps1
pwsh -NoProfile -File scripts/Test-Office.Install.ps1
pwsh -NoProfile -File scripts/Invoke-TasteAudit.ps1 -Path skills/taste-skill/assets -Profile 3
```

`-Check` detecta cambios en los perfiles generados sin escribir archivos. `Both` conserva su significado anterior de Codex y OpenCode. `All` incluye Claude Code.

`Invoke-TasteAudit.ps1` es la vía soportada por este proyecto para ejecutar el auditor importado: rechaza rutas ausentes y directorios sin HTML/CSS auditable, fuerza salida UTF-8 en Windows y conserva el código de salida del auditor. Usa código `0` para una auditoría limpia, `1` cuando hay errores de Taste y `2` cuando falla el preflight. No invoques `audit_taste.py` directamente en las verificaciones del kit.

Se conservan dos entrypoints con aviso de deprecación:

| Comando heredado | Equivalente canónico |
|---|---|
| `scripts/Test-Equipo.ps1` | `scripts/Test-Office.Core.ps1`; admite `-Section` y ejecuta todo por defecto. |
| `scripts/Build-Codex-Agents.ps1` | `scripts/Build-Office.ps1 -Platform Codex`; admite `-Check`. |

El generador heredado conserva su invocación sin argumentos y su alcance Codex. Ahora produce los treinta subagentes y el bloque de Dirección desde `office/`; ya no consume `codex/roles/`.

## Departamentos

| Coordinador | Especialistas |
|---|---|
| `coord-producto-experiencia` | `producto`, `diseno-web`, `ux-accesibilidad`, `seo-growth`, `data-analytics` |
| `coord-ingenieria-datos` | `arquitectura`, `frontend`, `backend`, `mobile`, `datos-ia`, `integraciones` |
| `coord-calidad-seguridad` | `qa`, `seguridad`, `auditoria`, `rendimiento` |
| `coord-operaciones-entrega` | `devops`, `sre-observabilidad`, `forensics`, `release`, `documentacion` |
| `coord-negocio-gobernanza` | `marketing`, `social-contenido`, `finanzas`, `legal`, `experiencia-cliente` |

`diseno-web` concentra dirección de arte, movimiento e imágenes y utiliza `taste-skill` como autoridad visual. `frontend` usa `frontend-developer` para arquitectura de cliente. El registro declara las skills requeridas; la generación Core no las instala ni confirma conexiones externas. Si falta una capacidad o skill necesaria, el agente debe declararlo y proponer una alternativa verificable.

## Encargos para empezar

- “Directora, analiza este proyecto sin cambiar archivos. Pide a Ingeniería y Datos una revisión de arquitectura y a Calidad y Seguridad los riesgos principales. Reúne evidencia y límites.”
- “Directora, agrega validación al formulario. Revisa las convenciones, encarga la implementación a Ingeniería y Datos y la revisión a Calidad y Seguridad. No publiques.”
- “Directora, prepara primero un plan para la pantalla y su endpoint. Acordemos el contrato y los criterios de aceptación antes de implementar.”

Cada entrega debe distinguir cambios, verificaciones reales, riesgos y pendientes. Publicar, desplegar, usar credenciales o cambiar servicios externos requiere autorización explícita para esa acción.

Si la oficina te sirve, dale una estrella al repositorio. Si encuentras un problema, abre un issue con el entorno, la versión y el comando que ejecutaste, omitiendo credenciales.
