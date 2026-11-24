# Conexiones de la oficina

El registro vincula capacidades a roles. Diseño Web recibe búsqueda web, Ingeniería recibe las capacidades de repositorio y datos que corresponden al encargo y los equipos coordinan tareas y conocimiento con las conexiones disponibles. La disponibilidad real depende de la sesión y de la autorización de la cuenta.

```powershell
./scripts/Test-OfficeConnections.ps1 -Platform Both
./scripts/Connect-OfficeTools.ps1 -Platform OpenCode -Capability database -DryRun
```

`connected` indica confirmación del cliente. `needs_auth` indica que el cliente solicita autenticación. `unverified` indica que falta evidencia de conectividad, incluido el caso de un servidor registrado que el CLI no enumera. `missing` indica que el CLI no encontró una conexión disponible. En Codex Desktop, comprueba las apps desde la sesión que va a usarlas.

| Necesidad | Dónde comprobar |
|---|---|
| GitHub, Linear, Notion en Codex Desktop | Abre Plugins y revisa la conexión de la cuenta en uso. |
| MCP en OpenCode | Revisa `/mcps` o `opencode mcp list`. Para un remoto que pida autorización, abre la sesión OAuth desde el cliente. [Documentación oficial](https://opencode.ai/docs/mcp-servers/). |
| MCP externo en Codex CLI | Consulta `codex mcp add --help` y el endpoint oficial del proveedor. [Documentación oficial](https://learn.chatgpt.com/docs/mcp). |
| MCP en Claude Code | Inspecciona los servidores con `claude mcp list` y autoriza cada servicio desde el cliente. Los perfiles de Claude de este paquete tienen una lista de herramientas integrada. Para habilitar herramientas de un servidor MCP en un perfil, revisa el campo `mcpServers` y las reglas de tu organización. [Documentación oficial](https://code.claude.com/docs/en/mcp). |
| Referencias web | Usa búsqueda y lectura de páginas públicas de la plataforma. Si falta acceso, registra el alcance real del estudio. |
| Analítica de producto | Elige Mixpanel o Amplitude con `-AnalyticsProvider` cuando se defina la herramienta del proyecto. |

La detección y la guía funcionan sin imprimir credenciales. Comprueba los permisos efectivos del rol antes de acceder a servicios externos.
