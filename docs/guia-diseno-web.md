# Diseño Web

Dirección encarga a `coord-producto-experiencia` una propuesta de `diseno-web`. Para sitios nuevos, landing pages y rediseños relevantes, `referencias-diseno-web` aporta el método de investigación y `taste-skill` define el sistema visual. Ambas skills se incluyen en el paquete.

1. Describe público, objetivo, identidad disponible y restricciones. Indica si esperas una propuesta, una implementación o ambas.
2. `diseno-web` consulta de tres a seis fuentes y entrega `reference-study.md` con URLs, fecha, observaciones, decisiones propias y límites de acceso. Consulta el [ejemplo de estudio](reference-research.md).
3. Revisa el contrato visual de Taste y acuerda la dirección antes de implementar. `ux-accesibilidad` revisa recorridos y accesibilidad. `frontend` implementa el contrato con las convenciones del proyecto.
4. Desde el repositorio de la oficina, ejecuta el auditor contra la ruta del código web. Ajusta el perfil al tipo de interfaz.

```powershell
pwsh -NoProfile -File scripts/Invoke-TasteAudit.ps1 -Path '/ruta/al/proyecto' -Profile 3
```

El código `0` indica que el auditor no encontró errores, `1` señala hallazgos y `2` indica una entrada no auditable. Registra también las comprobaciones de teclado, móvil y movimiento reducido que hayas podido ejecutar en navegador.
