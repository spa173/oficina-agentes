# OpenCode

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent opencode
```

Archivos instalados: `.opencode/agents/*.md`, `.agents/skills/` y `opencode.jsonc` si el proyecto carece de configuración propia.

## Cómo empezar

Ejecuta `opencode` desde el proyecto y selecciona `directora`. Comprueba el inventario con `opencode debug agents`. Usa OpenCode 2.3 o posterior para las reglas de permisos incluidas.

Cuando ya existe configuración, el instalador npm la conserva byte por byte. Para establecer la Dirección por defecto y permitir dos niveles de delegación, integra `"default_agent": "directora"` y `"experimental": { "subagent_depth": 2 }` en el archivo activo, respetando sus demás campos. Puedes continuar seleccionando `directora` manualmente.

[Agentes](https://opencode.ai/docs/agents/) · [Configuración](https://opencode.ai/docs/config/).
