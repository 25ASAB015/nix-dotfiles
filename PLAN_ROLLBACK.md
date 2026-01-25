# Plan de Rollback al Commit 9220122

## 📋 Resumen

Este documento describe cómo volver a generar el sistema basado en el commit `9220122` si después de hacer `make switch` no estás conforme con los cambios.

**Commit objetivo:** `9220122face1b1f71f0cf9b1fcc8536fa0cd2842`  
**Mensaje:** `fix(fish): mover configuración de starship a shellInit`  
**Fecha:** 2026-01-24 18:57:16 -0600

---

## 🎯 Métodos de Rollback

### Método 1: Rollback Rápido (Recomendado) ⚡

**Usa este método si solo quieres volver a la generación anterior (33).**

```bash
make gen-rollback
```

**Ventajas:**
- ✅ Rápido e inmediato
- ✅ No modifica el repositorio git
- ✅ Revierte solo la generación del sistema
- ✅ Puedes volver a avanzar fácilmente

**Limitaciones:**
- ⚠️ Solo revierte a la generación anterior (N-1)
- ⚠️ No restaura los archivos de configuración en git

---

### Método 2: Rollback a Commit Específico (Completo) 🔄

**Usa este método si quieres volver exactamente al commit 9220122.**

#### Opción A: Usando el nuevo comando make

```bash
make gen-rollback-commit COMMIT=9220122
```

#### Opción B: Manual paso a paso

```bash
# 1. Verificar el commit objetivo
git show 9220122 --stat

# 2. Hacer checkout al commit específico (sin perder cambios locales)
git checkout 9220122

# 3. Aplicar la configuración desde ese commit
make sys-apply

# 4. (Opcional) Si quieres mantener el repositorio en ese commit
git checkout -b rollback-9220122
```

**Ventajas:**
- ✅ Vuelve exactamente al commit que quieres
- ✅ Restaura tanto el sistema como los archivos de configuración
- ✅ Puedes crear una rama para mantener el estado

**Limitaciones:**
- ⚠️ Modifica el estado del repositorio git
- ⚠️ Requiere más pasos

---

### Método 3: Rollback Selectivo (Solo archivos específicos) 📁

**Usa este método si solo quieres restaurar archivos específicos.**

```bash
# Restaurar solo los archivos modificados en el commit actual
git checkout 9220122 -- modules/hm/programs/terminal/shell/fish.nix
git checkout 9220122 -- modules/hm/programs/terminal/shell/starship.nix

# Luego aplicar
make sys-apply
```

**Ventajas:**
- ✅ Restaura solo los archivos que necesitas
- ✅ Mantiene otros cambios que hayas hecho
- ✅ Control granular

---

## 🚀 Plan de Ejecución Automatizado

He creado un nuevo comando `make gen-rollback-commit` que automatiza el proceso completo.

### Uso:

```bash
# Rollback al commit 9220122
make gen-rollback-commit COMMIT=9220122

# O usando el hash corto
make gen-rollback-commit COMMIT=9220122face1b1f71f0cf9b1fcc8536fa0cd2842
```

### Qué hace el comando:

1. ✅ Verifica que el commit existe
2. ✅ Muestra información del commit (mensaje, fecha, cambios)
3. ✅ Pide confirmación antes de proceder
4. ✅ Hace checkout al commit especificado
5. ✅ Aplica la configuración con `make sys-apply`
6. ✅ Muestra el resultado y próximos pasos

---

## 📝 Flujo de Trabajo Recomendado

### Escenario: Probaste `make switch` y no te gustan los cambios

```bash
# Paso 1: Rollback rápido a la generación anterior
make gen-rollback

# Paso 2: (Opcional) Si quieres volver exactamente al commit 9220122
make gen-rollback-commit COMMIT=9220122

# Paso 3: Verificar que todo está bien
make gen-list
nixos-version
```

### Escenario: Quieres experimentar con seguridad

```bash
# Paso 1: Crear una rama de respaldo
git checkout -b backup-before-switch
git push origin backup-before-switch

# Paso 2: Volver a main y hacer switch
git checkout main
make switch

# Paso 3: Si no te gusta, rollback
make gen-rollback-commit COMMIT=9220122

# Paso 4: Si quieres volver a la rama de respaldo
git checkout backup-before-switch
```

---

## ⚠️ Advertencias Importantes

1. **Backup antes de rollback:**
   - El rollback no afecta tus datos personales
   - Pero puede cambiar configuraciones del sistema
   - Considera hacer backup de configuraciones críticas

2. **Commits no guardados:**
   - Si tienes cambios sin commit, el rollback puede perderlos
   - Usa `git stash` antes de hacer rollback si es necesario

3. **Generaciones del sistema:**
   - Las generaciones anteriores no se eliminan
   - Puedes volver a cualquier generación desde GRUB al arrancar

4. **Sincronización con remoto:**
   - Si haces rollback a un commit anterior, tu repositorio local estará "detrás" del remoto
   - Usa `git push --force` solo si sabes lo que haces

---

## 🔍 Verificación Post-Rollback

Después de hacer rollback, verifica que todo está correcto:

```bash
# Ver la generación actual
make gen-list

# Ver el commit actual
git log -1

# Verificar que el sistema funciona
nixos-version
systemctl status

# Verificar que los archivos están correctos
git status
git diff HEAD
```

---

## 📚 Comandos Relacionados

- `make gen-list` - Ver todas las generaciones
- `make gen-rollback` - Rollback rápido a generación anterior
- `make gen-rollback-commit COMMIT=xxx` - Rollback a commit específico
- `make sys-apply` - Aplicar configuración actual
- `make git-status` - Ver estado del repositorio

---

## 🆘 Solución de Problemas

### Problema: "Commit not found"
```bash
# Verificar que el commit existe
git log --oneline | grep 9220122

# O buscar por hash completo
git show 9220122face1b1f71f0cf9b1fcc8536fa0cd2842
```

### Problema: "Working directory is dirty"
```bash
# Guardar cambios actuales
git stash

# Hacer rollback
make gen-rollback-commit COMMIT=9220122

# (Opcional) Recuperar cambios guardados
git stash pop
```

### Problema: "Permission denied"
```bash
# Asegúrate de tener permisos sudo
sudo -v

# O verifica permisos del repositorio
make sys-fix-git
```

---

## ✅ Checklist de Rollback

Antes de ejecutar el rollback:

- [ ] Verificar que el commit objetivo existe
- [ ] Hacer backup de cambios importantes (si los hay)
- [ ] Verificar que no hay procesos críticos ejecutándose
- [ ] Tener acceso a sudo
- [ ] Entender qué cambios se van a revertir

Después del rollback:

- [ ] Verificar que el sistema arranca correctamente
- [ ] Verificar que los servicios están funcionando
- [ ] Verificar que la configuración es la esperada
- [ ] Documentar el rollback si es necesario

---

**Última actualización:** 2026-01-24  
**Creado por:** Auto (AI Assistant)

