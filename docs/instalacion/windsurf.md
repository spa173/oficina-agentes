# Windsurf / Cascade

En la raíz del proyecto, con Node.js 22 o posterior:

```shell
npx --yes --package="git+https://github.com/spa173/oficina-agentes.git" -- oficina-agentes install --agent windsurf
```

Archivos instalados: `.windsurf/workflows/oficina-agentes.md`, `.windsurf/skills/` y los 31 perfiles de consulta en `.oficina-agentes/roles/`.

## Cómo empezar

Abre Cascade en el proyecto y ejecuta `/oficina-agentes`. Escribe el encargo en ese chat. Si tu cliente ya no presenta workflows de Cascade, pide que lea `.windsurf/workflows/oficina-agentes.md` como guía del encargo.

Este adaptador organiza el trabajo con un workflow manual y una biblioteca de perfiles. La instalación no registra 31 subagentes nativos en Cascade.

[Catálogo oficial de personalizaciones de Cascade](https://github.com/Windsurf-Samples/cascade-customizations-catalog) · [Compatibilidad de skills en Devin Local](https://docs.devin.ai/desktop/devin-local/customizations).
