# Prompt operativo para agente (Makefile modular + docs)

## Contexto

Este repositorio está migrando el `Makefile` a un enfoque modular.
El plan oficial está en `/home/ludus/Dotfiles/PLAN_MAKEFILE_PRO.md`. Debes seguir ese plan
estrictamente y actualizar el estado de los pasos en ese mismo archivo.

## Objetivo

Modularizar el `Makefile` en `make/*.mk` sin alterar comportamiento,
preservando el orden original de las secciones y manteniendo coherencia
visual en la terminal. Luego, sincronizar documentación.

## Reglas de trabajo

- Sigue el plan en `PLAN_MAKEFILE_PRO.md` y marca cada paso al completarlo.
- No inventes comandos ni secciones nuevas sin registrarlas en el plan.
- Mantén el orden exacto de categorías del `Makefile` original.
- No cambies la salida visual (separadores, colores, emojis).
- No “mejores” la redacción en targets salvo que sea necesario para coherencia.
- Cualquier ajuste de UX debe registrarse en el plan.

## Estado del trabajo

1) Revisa el plan en `/home/ludus/Dotfiles/PLAN_MAKEFILE_PRO.md` y detecta qué pasos están completos.
2) Ejecuta **solo** el siguiente paso pendiente.
3) Después de completar un paso completamente:
   - Marca ese ítem como completado en el plan (`PLAN_MAKEFILE_PRO.md`)
   - Actualiza el registro de progreso con fecha y nota breve
   - **Crea un commit y push usando GitHub CLI** (ver sección "Commits y versionado" abajo)

## Cómo probar

Pruebas mínimas (no destructivas):

1. `make help`
   - Verifica orden y categorías iguales al original.
2. `make help-examples`
   - Verifica que los ejemplos se imprimen correctamente.
3. `make list-hosts`
   - Verifica formato y salidas (no altera el sistema).
4. `make search PKG=hello`
   - Verifica que exige `PKG` y ejecuta el comando.

Pruebas opcionales (si el usuario lo permite):

- `make dry-run`
- `make validate`

No ejecutar comandos destructivos:

- `make switch`, `make test`, `make clean`, `make deep-clean`, `make fix-store`

## Coherencia visual (terminal)

Siempre mantener:

- Separadores `════════════════════════════════════════════════════`
- Uso consistente de colores con `$(RED)`, `$(GREEN)`, `$(YELLOW)`, `$(BLUE)`, `$(PURPLE)`, `$(CYAN)`, `$(NC)`
- Emojis tal como están en el Makefile actual

Ejemplo de salida esperada:

```
════════════════════════════════════════════════════
          📦 Actualizar Inputs del Flake
════════════════════════════════════════════════════

Actualizando todos los inputs del flake...
✅ Inputs del flake actualizados
```

## Commits y versionado

Después de **cada paso completamente finalizado** (no sub-pasos), debes:

1. **Verificar cambios:**
   ```bash
   git status
   ```

2. **Verificar autenticación con GitHub CLI:**
   ```bash
   gh auth status
   ```

3. **Crear commit con mensaje descriptivo:**
   ```bash
   git add .
   git commit -m "refactor(makefile): completar paso X - [descripción breve del paso]"
   ```

4. **Push al repositorio usando GitHub CLI:**
   ```bash
   # GitHub CLI está autorizado con permisos necesarios
   gh repo sync
   # O si necesitas push directo:
   git push
   ```

**Nota sobre GitHub CLI:**
- GitHub CLI (`gh`) está autorizado con los permisos necesarios
- **Siempre usa GitHub CLI cuando sea necesario** para operaciones relacionadas con GitHub
- Para push, puedes usar `gh repo sync` para sincronizar o `git push` (que está autorizado a través de gh)
- Verifica autenticación con `gh auth status` antes de operaciones críticas

**Formato de mensaje de commit:**
- Prefijo: `refactor(makefile):` para cambios estructurales
- Descripción: `completar paso X - [nombre del paso del plan]`
- Ejemplo: `refactor(makefile): completar paso 1 - inventariar targets y variables`

**Importante:**
- Solo hacer commit después de que un paso esté **100% completo** y verificado
- Incluir en el commit todos los archivos modificados relacionados con ese paso
- No hacer commits parciales de sub-pasos
- **Usar GitHub CLI para todas las operaciones relacionadas con GitHub cuando sea posible**

## Resultado final esperado

- `Makefile` modular en `make/*.mk`
- Orden de secciones intacto
- Docs alineadas
- Plan marcado como completo
- Commits incrementales después de cada paso completado

