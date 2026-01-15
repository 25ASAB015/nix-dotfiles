# 🚀 Quick Start: Testing del Makefile

## Opción 1: Testing Automático (Recomendado para empezar)

Ejecuta todos los comandos seguros de una vez:

```bash
./test-makefile.sh
```

**Esto probará ~46 comandos automáticamente** en 2-3 minutos.

---

## Opción 2: Testing Manual por Niveles

Sigue el plan completo en `MAKEFILE_TESTING_PLAN.md` y ejecuta nivel por nivel.

### Empezar con lo más básico:

```bash
# NIVEL 0: Sistema de Ayuda (3 comandos)
make help
make help-examples
make help-advanced

# NIVEL 1: Información (15 comandos)
make info
make status
make version
make current-generation
make list-generations
make generation-sizes
make list-hosts
make hosts-info
make packages | head -50
make changelog
make changelog-detailed
make show
make check-syntax
make docs-local
make tree
```

---

## Opción 3: Testing Interactivo (La más completa)

### Paso 1: Comandos Seguros (30-40 min)

```bash
# Copiar y pegar cada sección del MAKEFILE_TESTING_PLAN.md
# Niveles 0-13 son seguros y rápidos
```

### Paso 2: Comandos que Requieren Cuidado (probar según necesidad)

```bash
# ⚠️ Estos comandos modifican el sistema

# Testing (seguro, temporal)
make test

# Switch (aplica cambios)
make safe-switch  # Más seguro (valida primero)
make switch       # Directo

# Updates
make update       # Solo actualiza flake.lock
make upgrade      # Update + switch

# Limpieza
make clean              # Elimina >30 días
make clean-conservative # Elimina >90 días
make optimize           # Optimiza store
```

---

## 📊 Comandos Organizados por Seguridad

### 🟢 100% Seguros (≈50 comandos)
- Sistema de ayuda, información, búsqueda, diff, logs, validación
- **Puedes ejecutarlos todos con:** `./test-makefile.sh`

### 🟡 Moderadamente Seguros (≈15 comandos)
- `make test` - Activa temporalmente (revierte al reiniciar)
- `make safe-switch` - Valida antes de aplicar
- `make format` - Formatea archivos .nix
- `make lint` - Solo revisa, no modifica

### 🟠 Requieren Cuidado (≈15 comandos)
- `make switch` - Aplica cambios permanentemente
- `make update`, `make upgrade` - Actualiza sistema
- `make clean`, `make optimize` - Limpieza de generaciones

### 🔴 Peligrosos (≈3 comandos)
- `make deep-clean` - Borra TODAS las generaciones (irreversible)
- `make emergency` - Rebuild sin validaciones
- `make quick` - Build sin safety checks

---

## 🎯 Recomendación Personal

### Para Testing Inicial (HOY):

```bash
# 1. Ejecutar script automático (2-3 min)
./test-makefile.sh

# 2. Revisar output, ver qué pasó y qué se skipped

# 3. Probar algunos interactivos manualmente
make repl        # Ctrl+D para salir
make git-status
make validate
```

### Para Testing Completo (DESPUÉS):

```bash
# 4. Probar comandos de build (cuando tengas tiempo)
make test        # Activa temporalmente
make dry-run     # Simula sin aplicar

# 5. Si todo está bien, hacer switch real
make safe-switch  # Valida + aplica

# 6. Probar limpieza (opcional)
make clean-conservative  # Limpia generaciones viejas
```

---

## 📝 Checklist Rápido

Marca según vayas probando:

- [ ] **Fase 1:** Ejecutar `./test-makefile.sh` ✅
- [ ] **Fase 2:** Revisar output del script
- [ ] **Fase 3:** Probar 2-3 comandos interactivos manualmente
- [ ] **Fase 4:** (Opcional) Probar `make test`
- [ ] **Fase 5:** (Opcional) Probar `make safe-switch`

---

## 🆘 Si Algo Falla

1. **Comando no encontrado:** Verifica que la herramienta esté instalada
   ```bash
   make lint  # Si falla, instala statix
   nix-shell -p statix
   ```

2. **Error de sintaxis:** Ejecuta validación
   ```bash
   make validate
   make check-syntax
   ```

3. **Sistema no arranca después de switch:**
   ```bash
   # En grub, selecciona generación anterior
   # O desde línea de comandos:
   make rollback
   ```

---

## 📚 Archivos de Referencia

- **MAKEFILE_TESTING_PLAN.md** - Plan detallado con todos los comandos
- **MAKEFILE_TUTORIAL.md** - Tutorial completo del Makefile
- **test-makefile.sh** - Script de testing automático
- **Makefile** - El archivo que estamos testeando

---

## 🎉 Próximos Pasos Después del Testing

Una vez que hayas probado todo:

1. Familiarízate con los comandos que más usarás:
   - `make help` - Ver comandos
   - `make status` - Ver estado del sistema
   - `make validate` - Antes de switch
   - `make safe-switch` - Aplicar cambios

2. Crea aliases si quieres (opcional):
   ```bash
   alias ns="make switch"
   alias nv="make validate"
   alias ni="make info"
   ```

3. Usa el tutorial como referencia cuando necesites algo específico

---

**¿Listo para empezar?**

```bash
./test-makefile.sh
```

¡Disfruta tu nuevo sistema de comandos! 🚀

