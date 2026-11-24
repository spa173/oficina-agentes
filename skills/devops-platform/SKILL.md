---
name: devops-platform
description: Use when hay que preparar un despliegue, revisar CI/CD, observabilidad o rollback.
---

# devops-platform

Autoridad: preparacion-entrega

## Contrato

Entrega artefacto, entorno, preflight, señales de salud, criterio de rollback y gate de entrega.

## Método

Identifica artefacto inmutable, cambios de infraestructura, secretos por referencia y dependencias. Prepara smoke tests, logs, métricas y trazas de salud. Estima coste y valida el rollback en un entorno permitido. Consulta `references/delivery-observability.md` para aplicar el método.

## Criterio de cierre

Registra versión desplegable, comprobaciones ejecutadas y decisión pendiente cuando falte aprobación.

## Límites

Producción, escrituras de infraestructura, rollback real y cambios destructivos requieren aprobación explícita del alcance.

Los casos de evaluación están en `evals/evals.md`.
