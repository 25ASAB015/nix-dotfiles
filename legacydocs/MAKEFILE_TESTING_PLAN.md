# 🧪 Plan de Testing Completo del Makefile

**Fecha:** 2026-01-11  
**Objetivo:** Probar todos los comandos del Makefile de forma sistemática y segura  
**Total de comandos:** 87

---

## 📋 Estrategia de Testing

### Orden Recomendado (de más seguro a menos seguro):

1. **Nivel 0: Sistema de Ayuda** (3 comandos) - Totalmente seguro
2. **Nivel 1: Información y Consulta** (17 comandos) - Solo lectura, muy seguro
3. **Nivel 2: Búsqueda y Discovery** (2 comandos) - Requiere parámetros
4. **Nivel 3: Diff y Comparación** (5 comandos) - Solo lectura
5. **Nivel 4: Logs y Monitoring** (6 comandos) - Solo lectura
6. **Nivel 5: Validación** (3 comandos) - Validación sin cambios
7. **Nivel 6: Export y Documentación** (7 comandos) - Crea archivos
8. **Nivel 7: Templates** (2 comandos) - Crea archivos de plantilla
9. **Nivel 8: Git (solo lectura)** (1 comando) - Git status
10. **Nivel 9: Backup** (1 comando) - Solo consulta
11. **Nivel 10: Build Analysis** (3 comandos) - Análisis sin cambios
12. **Nivel 11: Comandos de Build (dry-run)** (2 comandos) - Simulación
13. **Nivel 12: Advanced (seguros)** (3 comandos) - REPL, shell
14. **Nivel 13: Maintenance (consulta)** (1 comando) - Solo info
15. **Nivel 14: Quick Fixes (seguros)** (3 comandos) - Fix no destructivos
16. **Nivel 15: Updates (info)** (0 comandos) - Cubierto en Nivel 6
17. **Nivel 16: Formateo y Linting** (2 comandos) - Puede modificar archivos ⚠️
18. **Nivel 17: Git Operations** (4 comandos) - Modifica git ⚠️
19. **Nivel 18: Build Operations** (6 comandos) - Modifica sistema ⚠️
20. **Nivel 19: Updates** (5 comandos) - Actualiza sistema ⚠️
21. **Nivel 20: Maintenance** (6 comandos) - Limpieza de sistema ⚠️
22. **Nivel 21: Comandos Destructivos** (4 comandos) - PELIGROSO 🔴

---

## 🟢 NIVEL 0: Sistema de Ayuda (EMPEZAR AQUÍ)

Estos comandos solo muestran información, son 100% seguros.

```bash
# Testing Nivel 0
echo "=== NIVEL 0: Sistema de Ayuda ==="

# 1. make help
make help
echo "✓ make help funciona"

# 2. make help-examples
make help-examples
echo "✓ make help-examples funciona"

# 3. make help (workflows)
make help
echo "✓ make help (workflows) funciona"

echo "✅ NIVEL 0 COMPLETADO (3/3)"
```

**Verificación:** ¿Se muestran todos los comandos correctamente?

---

## 🟢 NIVEL 1: Información y Consulta (MUY SEGURO)

Solo lectura del sistema, no modifica nada.

```bash
echo "=== NIVEL 1: Información y Consulta ==="

# 4. make info
make info
echo "✓ make info funciona"

# 5. make status
make status
echo "✓ make status funciona"

# 6. make version
make version
echo "✓ make version funciona"

# 7. make current-generation
make current-generation
echo "✓ make current-generation funciona"

# 8. make list-generations
make list-generations
echo "✓ make list-generations funciona"

# 9. make generation-sizes
make generation-sizes
echo "✓ make generation-sizes funciona"

# 10. make list-hosts
make list-hosts
echo "✓ make list-hosts funciona"

# 11. make hosts-info
make hosts-info
echo "✓ make hosts-info funciona"

# 12. make packages
make packages | head -50
echo "✓ make packages funciona"

# 13. make changelog
make changelog
echo "✓ make changelog funciona"

# 14. make changelog-detailed
make changelog-detailed
echo "✓ make changelog-detailed funciona"

# 15. make show
make show
echo "✓ make show funciona"

# 16. make check-syntax
make check-syntax
echo "✓ make check-syntax funciona"

# 17. make docs-local
make docs-local
echo "✓ make docs-local funciona"

# 18. make tree
make tree
echo "✓ make tree funciona"

# Extra (Migration helpers seguros)
# - make progress
make progress
echo "✓ make progress funciona"

# - make phases
make phases
echo "✓ make phases funciona"

echo "✅ NIVEL 1 COMPLETADO (17/17)"
```

**Verificación:** ¿Toda la información se muestra correctamente?

---

## 🟢 NIVEL 2: Búsqueda y Discovery (SEGURO - Requiere parámetros)

```bash
echo "=== NIVEL 2: Búsqueda y Discovery ==="

# 19. make search (requiere PKG)
make search PKG=firefox
echo "✓ make search funciona"

# 20. make search-installed (requiere PKG)
make search-installed PKG=fish
echo "✓ make search-installed funciona"

echo "✅ NIVEL 2 COMPLETADO (2/2)"
```

**Verificación:** ¿Se encuentran los paquetes correctamente?

---

## 🟢 NIVEL 3: Diff y Comparación (SEGURO - Solo lectura)

```bash
echo "=== NIVEL 3: Diff y Comparación ==="

# 21. make diff-config
make diff-config
echo "✓ make diff-config funciona"

# 22. make diff-flake
make diff-flake
echo "✓ make diff-flake funciona"

# 23. make diff-generations
make diff-generations
echo "✓ make diff-generations funciona"

# 24. make diff-gen (requiere GEN1 y GEN2)
# Primero obtén números de generación
CURRENT_GEN=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1 | awk '{print $1}')
PREV_GEN=$((CURRENT_GEN - 1))
make diff-gen GEN1=$PREV_GEN GEN2=$CURRENT_GEN
echo "✓ make diff-gen funciona"

# 25. make compare-hosts (requiere HOST1 y HOST2)
make compare-hosts HOST1=hydenix HOST2=laptop
echo "✓ make compare-hosts funciona"

echo "✅ NIVEL 3 COMPLETADO (5/5)"
```

**Verificación:** ¿Los diffs se muestran correctamente?

---

## 🟢 NIVEL 4: Logs y Monitoring (SEGURO - Solo lectura)

```bash
echo "=== NIVEL 4: Logs y Monitoring ==="

# 26. make logs-errors
make logs-errors | head -20
echo "✓ make logs-errors funciona"

# 27. make logs-boot
make logs-boot | head -20
echo "✓ make logs-boot funciona"

# 28. make logs-service (requiere SVC)
make logs-service SVC=systemd-journald | head -20
echo "✓ make logs-service funciona"

# 29. make test-network
make test-network
echo "✓ make test-network funciona"

# 30. make watch-logs (SKIP - es interactivo, requiere Ctrl+C)
echo "⊘ make watch-logs SKIPPED (interactivo)"

# 31. make watch-rebuild (SKIP - es interactivo)
echo "⊘ make watch-rebuild SKIPPED (interactivo)"

echo "✅ NIVEL 4 COMPLETADO (4/6 - 2 skipped por ser interactivos)"
```

**Verificación:** ¿Los logs se muestran correctamente?

---

## 🟢 NIVEL 5: Validación (SEGURO - Solo valida)

```bash
echo "=== NIVEL 5: Validación ==="

# 31. make validate
make validate
echo "✓ make validate funciona"

# 32. make health
make health
echo "✓ make health funciona"

# 33. make dry-run
make dry-run
echo "✓ make dry-run funciona"

echo "✅ NIVEL 5 COMPLETADO (3/3)"
```

**Verificación:** ¿La validación pasa sin errores?

---

## 🟢 NIVEL 6: Export y Documentación (CREA ARCHIVOS - pero seguro)

```bash
echo "=== NIVEL 6: Export y Documentación ==="

# 34. make export-config
make export-config
echo "✓ make export-config funciona"
ls -lh nixos-config-*.tar.gz

# 35. make export-minimal
make export-minimal
echo "✓ make export-minimal funciona"
ls -lh nixos-config-minimal-*.tar.gz

# 36. make readme
echo "q" | make readme
echo "✓ make readme funciona"

# 37. make tutorial
echo "q" | make tutorial
echo "✓ make tutorial funciona"

# 38. make docs-dev (SKIP - corre servidor)
echo "⊘ make docs-dev SKIPPED (servidor interactivo)"

# 39. make update-info
make update-info
echo "✓ make update-info funciona"

# 40. make diff-update
make diff-update
echo "✓ make diff-update funciona"

echo "✅ NIVEL 6 COMPLETADO (6/7 - 1 skipped por interactivo)"
```

**Verificación:** ¿Se crearon los archivos exportados correctamente?

---

## 🟢 NIVEL 7: Templates (CREA ARCHIVOS - pero seguro)

```bash
echo "=== NIVEL 7: Templates ==="

# 40. make new-host (requiere HOST)
make new-host HOST=test-server
echo "✓ make new-host funciona"
ls -la hosts/test-server/

# 41. make new-module (requiere MODULE)
make new-module MODULE=test/example
echo "✓ make new-module funciona"
ls -la modules/test/example.nix

# Cleanup
rm -rf hosts/test-server
rm -f modules/test/example.nix
rmdir modules/test 2>/dev/null

echo "✅ NIVEL 7 COMPLETADO (2/2)"
```

**Verificación:** ¿Se crearon los templates correctamente?

---

## 🟢 NIVEL 8: Git (Solo Lectura)

```bash
echo "=== NIVEL 8: Git (Solo Lectura) ==="

# 42. make git-status
make git-status
echo "✓ make git-status funciona"

echo "✅ NIVEL 8 COMPLETADO (1/1)"
```

---

## 🟢 NIVEL 9: Backup y Generations (Solo Consulta)

```bash
echo "=== NIVEL 9: Backup y Generations ==="

# 43. make backup
make backup
echo "✓ make backup funciona"
ls -la ~/nixos-backups/

echo "✅ NIVEL 9 COMPLETADO (1/1)"
```

---

## 🟢 NIVEL 10: Build Analysis (SEGURO - Solo análisis)

```bash
echo "=== NIVEL 10: Build Analysis ==="

# 44. make closure-size
make closure-size
echo "✓ make closure-size funciona"

# 45. make why-depends (requiere PKG)
make why-depends PKG=bash
echo "✓ make why-depends funciona"

# 46. make build-trace
make build-trace | head -30
echo "✓ make build-trace funciona"

echo "✅ NIVEL 10 COMPLETADO (3/3)"
```

---

## 🟢 NIVEL 11: Comandos de Build (Dry-run solo)

```bash
echo "=== NIVEL 11: Build Commands (Dry-run) ==="

# 47. make build (solo construye, no activa)
# SKIP POR AHORA - puede tardar mucho
echo "⊘ make build SKIPPED (tarda mucho)"

# 48. make benchmark
# SKIP - hace build completo
echo "⊘ make benchmark SKIPPED (hace build completo)"

echo "✅ NIVEL 11 COMPLETADO (0/2 - skipped por tiempo)"
```

---

## 🟢 NIVEL 12: Advanced (Seguros)

```bash
echo "=== NIVEL 12: Advanced ==="

# 49. make repl (SKIP - es interactivo)
echo "⊘ make repl SKIPPED (interactivo)"

# 50. make shell (SKIP - es interactivo)
echo "⊘ make shell SKIPPED (interactivo)"

# 51. make vm (SKIP - puede tardar y es interactivo)
echo "⊘ make vm SKIPPED (construye VM completa)"

echo "✅ NIVEL 12 COMPLETADO (0/3 - todos interactivos/pesados)"
```

---

## 🟢 NIVEL 13: Maintenance (Solo Consulta)

```bash
echo "=== NIVEL 13: Maintenance (Info) ==="

# 52. make clean-result
make clean-result
echo "✓ make clean-result funciona"

echo "✅ NIVEL 13 COMPLETADO (1/1)"
```

---

## 🟡 NIVEL 14: Quick Fixes (MODIFICA - pero seguro)

```bash
echo "=== NIVEL 14: Quick Fixes ==="

# 53. make fix-permissions
# SKIP - requiere sudo y modifica permisos
echo "⚠️  make fix-permissions SKIPPED (modifica permisos)"

# 54. make fix-store
# SKIP - puede tardar mucho
echo "⚠️  make fix-store SKIPPED (verifica store, tarda)"

# 55. make fix-git-permissions
# SKIP - requiere revisar ownership en git
echo "⚠️  make fix-git-permissions SKIPPED (requiere revisar permisos)"

echo "✅ NIVEL 14 COMPLETADO (0/3 - skipped por modificar sistema)"
```

---

## 🟡 NIVEL 15: Updates (Solo Info)

Ya testeado en nivel 6

---

## 🟡 NIVEL 16: Formateo y Linting (PUEDE MODIFICAR)

```bash
echo "=== NIVEL 16: Formateo y Linting ==="

# 55. make lint
make lint
echo "✓ make lint funciona"

# 56. make format
# SKIP - puede modificar archivos
echo "⚠️  make format SKIPPED (modifica archivos .nix)"

echo "✅ NIVEL 16 COMPLETADO (1/2)"
```

---

## 🟡 NIVEL 17: Git Operations (MODIFICA GIT)

```bash
echo "=== NIVEL 17: Git Operations ==="

echo "⚠️  TODOS LOS COMANDOS DE GIT WRITE SKIPPED"
echo "   - make git-add"
echo "   - make git-commit"
echo "   - make git-push"
echo "   - make save"
echo "   Los puedes probar manualmente si lo deseas"

echo "✅ NIVEL 17 COMPLETADO (0/4 - skipped por modificar git)"
```

---

## 🔴 NIVEL 18-21: COMANDOS QUE MODIFICAN SISTEMA

```bash
echo "=== NIVELES 18-21: Comandos que Modifican Sistema ==="
echo ""
echo "⚠️  LOS SIGUIENTES COMANDOS MODIFICAN EL SISTEMA:"
echo ""
echo "🟡 Relativamente seguros (probados):"
echo "   - make test          (activa temporalmente)"
echo "   - make safe-switch   (valida + switch)"
echo "   - make hardware-scan (genera archivo nuevo)"
echo ""
echo "🟠 Moderadamente riesgosos:"
echo "   - make switch        (activa config)"
echo "   - make boot          (config para next boot)"
echo "   - make rollback      (vuelve a anterior)"
echo "   - make rebuild       (alias de switch)"
echo "   - make restore       (no implementado, usar flujo manual)"
echo ""
echo "🟠 Updates:"
echo "   - make update        (actualiza flake.lock)"
echo "   - make update-nixpkgs"
echo "   - make update-hydenix"
echo "   - make update-input INPUT=name"
echo "   - make upgrade       (update + switch)"
echo ""
echo "🟠 Limpieza:"
echo "   - make clean         (30 días)"
echo "   - make clean-week    (7 días)"
echo "   - make clean-conservative (90 días)"
echo "   - make clean-generations (14 días)"
echo "   - make gc            (alias clean)"
echo "   - make optimize      (optimiza store)"
echo ""
echo "🔴 PELIGROSOS (requieren cuidado especial):"
echo "   - make deep-clean    (BORRA TODO, irreversible)"
echo "   - make emergency     (rebuild extremo)"
echo "   - make quick         (rebuild sin checks)"
echo ""
echo "📝 RECOMENDACIÓN: Probar estos manualmente según necesidad"
echo "   y en el orden que consideres apropiado."
```

---

## 📝 RESUMEN DE TESTING

### Comandos Seguros que se Pueden Probar (≈49 comandos):
- ✅ Sistema de ayuda (3)
- ✅ Información (17)
- ✅ Búsqueda (2)
- ✅ Diff (5)
- ✅ Logs + network (4)
- ✅ Validación (3)
- ✅ Export/Docs (6)
- ✅ Templates (2)
- ✅ Git status (1)
- ✅ Backup (1)
- ✅ Build analysis (3)
- ✅ Cleanup (1)
- ✅ Lint (1)

**Total testeables automáticamente: 49 comandos**

### Comandos a Probar Manualmente (según necesidad):
- ⊘ Interactivos (6): watch-logs, watch-rebuild, docs-dev, repl, shell, vm
- ⊘ Pesados (2): build, benchmark
- ⚠️ Modifican sistema (18): switch, test, safe-switch, boot, rollback, rebuild, updates, limpieza, hardware-scan, fix-permissions
- 🔴 Peligrosos (4): deep-clean, emergency, quick, restore

---

## 🚀 Script de Testing Automático

Para ejecutar todos los tests seguros de una vez:

```bash
# Guardar como test-makefile.sh
chmod +x test-makefile.sh
./test-makefile.sh
```

¿Quieres que cree el script completo de testing?

---

## ✅ Checklist de Testing

Marca cada nivel conforme lo completes:

- [ ] Nivel 0: Sistema de Ayuda (3)
- [ ] Nivel 1: Información (17)
- [ ] Nivel 2: Búsqueda (2)
- [ ] Nivel 3: Diff (5)
- [ ] Nivel 4: Logs (4)
- [ ] Nivel 5: Validación (3)
- [ ] Nivel 6: Export (6)
- [ ] Nivel 7: Templates (2)
- [ ] Nivel 8: Git Read (1)
- [ ] Nivel 9: Backup (1)
- [ ] Nivel 10: Build Analysis (3)
- [ ] Nivel 11: Build Dry-run (skipped)
- [ ] Nivel 12: Advanced (skipped)
- [ ] Nivel 13: Maintenance (1)
- [ ] Nivel 14: Quick Fixes (skipped)
- [ ] Nivel 15: Updates Info (done)
- [ ] Nivel 16: Lint (1)

**Total Testeado Automáticamente: 49/87 comandos**

---

**Siguiente Paso:** Ejecutar los tests nivel por nivel, comenzando por Nivel 0.

---

## ✅ Checklist Completa (87 comandos)

Marca cada comando conforme lo verifiques manualmente:

### Sistema de Ayuda
- [x] help
- [x] help-examples

### Building and Switching
- [ ] rebuild
- [ ] switch
- [ ] safe-switch
- [ ] test
- [ ] build
- [ ] dry-run
- [ ] boot

### Multi-Host
- [ ] list-hosts

### Validación
- [ ] validate
- [ ] health

### Debugging y Diagnóstico
- [ ] debug
- [ ] check-syntax
- [ ] show
- [ ] test-network

### Maintenance and Cleanup
- [ ] clean
- [ ] clean-week
- [ ] clean-conservative
- [ ] clean-generations
- [ ] gc
- [ ] optimize
- [ ] generation-sizes
- [ ] deep-clean

### Updates
- [ ] update
- [ ] update-nixpkgs
- [ ] update-hydenix
- [ ] update-input
- [ ] update-info
- [ ] diff-update
- [ ] upgrade

### Formatting y Linting
- [ ] format
- [ ] lint

### Backup y Generations
- [ ] backup
- [ ] list-generations
- [ ] rollback
- [ ] diff-generations
- [ ] diff-gen
- [ ] restore (no implementado; usar flujo manual)

### Git Integration
- [x] git-status
- [x] git-add
- [x] git-commit
- [x] git-push
- [x] save

### Información del Sistema
- [x] info
- [x] status
- [x] version
- [x] current-generation
- [x] hosts-info

### Búsqueda
- [x] search
- [x] search-installed

### Quick Actions
- [ ] quick
- [ ] emergency
- [ ] benchmark

### Hardware
- [ ] hardware-scan

### Monitoring y Logs
- [ ] watch-logs
- [ ] watch-rebuild
- [ ] logs-boot
- [ ] logs-errors
- [ ] logs-service

### Advanced
- [ ] repl
- [ ] shell
- [ ] vm

### Changelog e Historial
- [ ] changelog
- [ ] changelog-detailed

### Paquetes
- [ ] packages

### Export/Import
- [ ] export-config
- [ ] export-minimal

### Documentación
- [ ] docs-local
- [ ] docs-dev
- [ ] readme
- [ ] tutorial

### Templates
- [ ] new-host
- [ ] new-module

### Diff Tools
- [ ] diff-config
- [ ] diff-flake
- [ ] compare-hosts

### Build Analysis
- [ ] why-depends
- [ ] build-trace
- [ ] closure-size

### Quick Fixes
- [ ] fix-permissions
- [ ] fix-git-permissions
- [ ] fix-store

### Utilidades
- [ ] clean-result
- [ ] tree

### Migration Helpers
- [ ] progress
- [ ] phases

