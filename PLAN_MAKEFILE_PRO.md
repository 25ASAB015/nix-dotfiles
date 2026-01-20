# Plan de acción (opción B “pro”)

Objetivo: modularizar el `Makefile`, mantener el orden original, alinear docs
con el nuevo layout y asegurar consistencia visual + verificabilidad.

## Estado del plan

- [ ] Paso 1 — Inventariar targets y variables actuales
- [ ] Paso 2 — Definir estructura de módulos `make/*.mk`
- [ ] Paso 3 — Crear carpeta `make/` y archivos vacíos
- [ ] Paso 4 — Mover secciones del Makefile a módulos
- [ ] Paso 5 — Ajustar `Makefile` root (includes + orden)
- [ ] Paso 6 — Verificar `make help` y `make help-examples`
- [ ] Paso 7 — Actualizar documentación (estructura + sincronía)
- [ ] Paso 8 — Añadir guía de tests y ejemplos de salida coherente
- [ ] Paso 9 — Checklist final y criterios de aceptación

## Sistema de checks (control de avance)

Reglas:
- Cada vez que completes un paso, marca el checkbox en "Estado del plan".
- Registra la finalización en el "Registro de progreso" con fecha y nota breve.
- **Después de cada paso completamente finalizado, crear commit y push usando GitHub CLI:**
  ```bash
  git add .
  git commit -m "refactor(makefile): completar paso X - [descripción del paso]"
  gh auth status  # Verificar autenticación
  gh repo sync   # O git push (autorizado a través de gh)
  ```
  **Nota:** GitHub CLI está autorizado con permisos necesarios. Siempre usar `gh` cuando sea necesario para operaciones de GitHub.
- No avances al siguiente paso si el anterior no está marcado como completado y commiteado.

## Registro de progreso

- [ ] Paso 1 — Fecha: ____ | Nota:
- [ ] Paso 2 — Fecha: ____ | Nota:
- [ ] Paso 3 — Fecha: ____ | Nota:
- [ ] Paso 4 — Fecha: ____ | Nota:
- [ ] Paso 5 — Fecha: ____ | Nota:
- [ ] Paso 6 — Fecha: ____ | Nota:
- [ ] Paso 7 — Fecha: ____ | Nota:
- [ ] Paso 8 — Fecha: ____ | Nota:
- [ ] Paso 9 — Fecha: ____ | Nota:

## Pasos atómicos

1) Inventario de targets y variables
   - Extraer lista de targets y variables (Makefile actual).
   - Confirmar orden actual por secciones (el de `help`).
   - Marcar comandos con parámetros obligatorios (PKG, INPUT, SVC, GEN).
   - Salida esperada: tabla “target → sección → parámetros → notas”.

2) Definir módulos y mapeo
   - Mantener el mismo orden que el Makefile original.
   - Mapear secciones a archivos:
     - `make/docs.mk` (Ayuda y Documentación)
     - `make/system.mk` (Gestión del Sistema)
     - `make/cleanup.mk` (Limpieza y Optimización)
     - `make/updates.mk` (Actualizaciones y Flakes)
     - `make/generations.mk` (Generaciones y Rollback)
     - `make/git.mk` (Git y Respaldo)
     - `make/logs.mk` (Diagnóstico y Logs)
     - `make/dev.mk` (Análisis y Desarrollo)
     - `make/format.mk` (Formato, Linting y Estructura)
     - `make/reports.mk` (Reportes y Exportación)
     - `make/templates.mk` (Plantillas y Otros)
   - Salida esperada: mapa “sección → archivo”.

3) Crear estructura `make/`
   - Crear directorio `make/`.
   - Crear archivos `.mk` vacíos con cabecera.
   - Salida esperada: árbol `make/` con todos los módulos.

4) Mover secciones a módulos
   - Trasladar cada bloque de targets a su archivo correspondiente.
   - Mantener comentarios `# === ... ===` dentro del módulo.
   - No cambiar comportamiento ni orden interno.
   - Salida esperada: cada módulo contiene sus targets.

5) Ajustar `Makefile` root
   - Dejar variables globales, colores, `.PHONY`, `.DEFAULT_GOAL` y `help`.
   - Incluir los módulos en el orden original con `include make/*.mk`.
   - Salida esperada: `Makefile` root limpio y estable.

6) Verificación rápida funcional
   - Ejecutar `make help` y `make help-examples`.
   - Comparar salida con la previa (visual + orden).
   - Salida esperada: output idéntico o superior.

7) Actualizar documentación
   - Mantener la estructura de categorías **idéntica** al `Makefile`.
   - Reducir duplicaciones innecesarias.
   - Añadir sección de “Mapa de módulos del Makefile”.
   - Salida esperada: doc consistente con Makefile modular.

8) Guía de pruebas y ejemplos
   - Definir comandos mínimos para validar: `help`, `help-examples`,
     `switch` (solo sintaxis), `search`, `update-input`.
   - Añadir ejemplos de salida con el mismo estilo visual actual.
   - Salida esperada: sección “Pruebas y ejemplos”.

9) Checklist final
   - Ningún target perdido.
   - Orden de categorías intacto.
   - Docs sincronizadas.
   - Sin errores de sintaxis.

## Criterios de aceptación

- `make help` muestra las mismas categorías y orden que antes.
- Todos los targets existen y funcionan igual.
- Los módulos `.mk` respetan el orden original.
- Documentación coherente y alineada con el nuevo layout.

