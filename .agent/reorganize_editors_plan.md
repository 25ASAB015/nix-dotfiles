# Plan: Reorganizar Instalación de Cursor y AntiGravity

## 📋 Resumen Ejecutivo

Este plan describe cómo mover la instalación de **Cursor** y **AntiGravity** desde `modules/hm/programs/terminal/software/essentials.nix` a sus respectivos módulos en `modules/hm/programs/editors/`, mejorando la organización y coherencia del código.

**Objetivo**: Centralizar la gestión de editores en un solo lugar, manteniendo la funcionalidad existente.

---

## 🎯 Objetivos

1. ✅ Mover instalación de Cursor a `modules/hm/programs/editors/cursor.nix`
2. ✅ Mover instalación de AntiGravity a `modules/hm/programs/editors/antigravity.nix`
3. ✅ Limpiar `essentials.nix` removiendo editores
4. ✅ Mantener funcionalidad existente (sin romper nada)
5. ✅ Actualizar documentación

---

## 📐 Estado Actual

### Archivos Involucrados

```
modules/hm/
├── default.nix
│   └── Importa: ./programs/terminal/software/essentials.nix
├── programs/
│   ├── default.nix
│   │   └── Importa: ./editors
│   ├── terminal/
│   │   └── software/
│   │       └── essentials.nix  ← Cursor y AntiGravity aquí
│   └── editors/
│       ├── default.nix
│       ├── vscode.nix         ← VS Code instalado aquí
│       ├── cursor.nix         ← Vacío (solo documenta)
│       └── antigravity.nix    ← Vacío (solo documenta)
```

### Instalación Actual

**`essentials.nix`** (líneas 13-22):
```nix
home.packages = with pkgs; [
  # Editors
  code-cursor-fhs # Cursor AI
  cursor-cli # Cursor CLI
  
  # Git tools
  gitkraken # GitKraken GUI
  gk-cli # GitKraken CLI
  
  # Other
  antigravity-fhs # Antigravity by Google
  dropbox # Dropbox
  meld # Visual diff and merge tool
  unzip # Unzip utility
];
```

---

## 📝 Plan de Implementación

### FASE 1: Actualizar Módulo de Cursor

**Archivo**: `modules/hm/programs/editors/cursor.nix`

**Antes**:
```nix
{ config, lib, pkgs, ... }:

{
  # Cursor ya está instalado manualmente
  # Este módulo solo documenta su presencia
  # La configuración se gestiona con symlinks en files.nix
}
```

**Después**:
```nix
{ config, lib, pkgs, ... }:

{
  # Cursor - Editor de código con IA
  # Instalado como paquetes en home.packages
  # La configuración se gestiona con symlinks en files.nix
  home.packages = with pkgs; [
    code-cursor-fhs  # Cursor AI (versión FHS para mejor compatibilidad)
    cursor-cli        # Cursor CLI
  ];
}
```

---

### FASE 2: Actualizar Módulo de AntiGravity

**Archivo**: `modules/hm/programs/editors/antigravity.nix`

**Antes**:
```nix
{ config, lib, pkgs, ... }:

{
  # AntiGravity ya está instalado manualmente
  # Este módulo solo documenta su presencia
  # La configuración se gestiona con symlinks en files.nix
}
```

**Después**:
```nix
{ config, lib, pkgs, ... }:

{
  # AntiGravity - Editor de código por Google
  # Instalado como paquete en home.packages
  # La configuración se gestiona con symlinks en files.nix
  home.packages = with pkgs; [
    antigravity-fhs  # AntiGravity by Google (versión FHS)
  ];
}
```

---

### FASE 3: Limpiar essentials.nix

**Archivo**: `modules/hm/programs/terminal/software/essentials.nix`

**Antes**:
```nix
home.packages = with pkgs; [
  # Editors
  code-cursor-fhs # Cursor AI
  cursor-cli # Cursor CLI
  
  # Git tools
  gitkraken # GitKraken GUI
  gk-cli # GitKraken CLI
  
  # Other
  antigravity-fhs # Antigravity by Google
  dropbox # Dropbox
  meld # Visual diff and merge tool
  unzip # Unzip utility
];
```

**Después**:
```nix
home.packages = with pkgs; [
  # Git tools
  gitkraken # GitKraken GUI
  gk-cli # GitKraken CLI
  
  # Other
  dropbox # Dropbox
  meld # Visual diff and merge tool
  unzip # Unzip utility
];
```

**Nota**: Los editores (Cursor y AntiGravity) se movieron a `modules/hm/programs/editors/`

---

### FASE 4: Verificar Imports

**Archivo**: `modules/hm/programs/editors/default.nix`

**Estado actual** (ya correcto):
```nix
{
  imports = [
    ./vscode.nix
    ./cursor.nix
    ./antigravity.nix
  ];
}
```

✅ **No requiere cambios** - Ya importa ambos módulos

---

### FASE 5: Actualizar Documentación

**Archivo**: `docs/src/content/docs/editors.mdx`

**Cambios necesarios**:
1. Actualizar sección "Ubicación de Instalación"
2. Cambiar referencias de `essentials.nix` a los módulos de editores
3. Actualizar ejemplos de código

---

## 🧪 Verificación y Testing

### Checklist de Verificación

- [ ] Verificar sintaxis Nix: `nix-instantiate --parse`
- [ ] Verificar que no hay errores de linter
- [ ] Probar build: `make test` (o `nixos-rebuild test`)
- [ ] Verificar que Cursor se instala: `which cursor`
- [ ] Verificar que AntiGravity se instala: `which antigravity` (o comando correcto)
- [ ] Verificar que los symlinks siguen funcionando
- [ ] Verificar que VS Code no se afecta

### Comandos de Verificación

```bash
# 1. Verificar sintaxis
cd ~/Dotfiles
nix-instantiate --parse --expr 'import ./modules/hm/programs/editors/cursor.nix'
nix-instantiate --parse --expr 'import ./modules/hm/programs/editors/antigravity.nix'
nix-instantiate --parse --expr 'import ./modules/hm/programs/terminal/software/essentials.nix'

# 2. Verificar que los paquetes están en los módulos correctos
grep -r "code-cursor-fhs" modules/hm/programs/editors/
grep -r "antigravity-fhs" modules/hm/programs/editors/

# 3. Verificar que se removieron de essentials.nix
grep -i "cursor\|antigravity" modules/hm/programs/terminal/software/essentials.nix
# Debe retornar vacío o solo comentarios

# 4. Aplicar cambios
make switch

# 5. Verificar instalación
which cursor
cursor --version
# Verificar AntiGravity (ajustar comando según cómo se lance)
```

---

## ⚠️ Consideraciones Importantes

### Orden de Imports

Los módulos de editores se importan a través de:
1. `modules/hm/default.nix` → `./programs` → `./programs/default.nix` → `./editors` → `./editors/default.nix`
2. `essentials.nix` se importa directamente en `modules/hm/default.nix`

**No hay conflicto** porque:
- Los módulos de editores agregan a `home.packages` en sus propios módulos
- `essentials.nix` también agrega a `home.packages`
- Home Manager combina todas las listas de `home.packages` automáticamente

### Compatibilidad

✅ **No rompe nada** porque:
- Los paquetes se instalan en el mismo lugar (`home.packages`)
- Los symlinks en `files.nix` no cambian
- La funcionalidad es idéntica, solo cambia la organización

### Rollback

Si algo sale mal:
```bash
# Revertir cambios
cd ~/Dotfiles
git restore modules/hm/programs/editors/cursor.nix
git restore modules/hm/programs/editors/antigravity.nix
git restore modules/hm/programs/terminal/software/essentials.nix
make switch
```

---

## 📊 Resumen de Cambios

### Archivos a MODIFICAR

1. `modules/hm/programs/editors/cursor.nix`
   - Agregar `home.packages` con `code-cursor-fhs` y `cursor-cli`

2. `modules/hm/programs/editors/antigravity.nix`
   - Agregar `home.packages` con `antigravity-fhs`

3. `modules/hm/programs/terminal/software/essentials.nix`
   - Remover líneas de Cursor y AntiGravity

4. `docs/src/content/docs/editors.mdx`
   - Actualizar referencias de instalación

### Archivos que NO cambian

- ✅ `modules/hm/default.nix` - No requiere cambios
- ✅ `modules/hm/programs/default.nix` - No requiere cambios
- ✅ `modules/hm/programs/editors/default.nix` - Ya importa ambos módulos
- ✅ `modules/hm/files.nix` - Los symlinks no cambian
- ✅ `modules/hm/programs/editors/vscode.nix` - No afectado

---

## 🚀 Orden de Ejecución

1. **FASE 1**: Actualizar `cursor.nix` (agregar instalación)
2. **FASE 2**: Actualizar `antigravity.nix` (agregar instalación)
3. **FASE 3**: Limpiar `essentials.nix` (remover editores)
4. **FASE 4**: Verificar imports (ya están correctos)
5. **FASE 5**: Actualizar documentación
6. **FASE 6**: Testing y verificación
7. **FASE 7**: Commit y push

---

## ✅ Resultado Esperado

Después de implementar este plan:

✅ **Cursor** instalado desde `modules/hm/programs/editors/cursor.nix`  
✅ **AntiGravity** instalado desde `modules/hm/programs/editors/antigravity.nix`  
✅ **essentials.nix** limpio, sin editores  
✅ **Organización mejorada**: Todos los editores en un solo lugar  
✅ **Funcionalidad intacta**: Todo sigue funcionando igual  
✅ **Documentación actualizada**: Refleja la nueva estructura  

---

## 📝 Notas Finales

- Este cambio es **puramente organizacional**
- No afecta la funcionalidad existente
- Mejora la coherencia del código
- Facilita el mantenimiento futuro
- Sigue el principio de organización por categoría

---

**Fecha de creación**: 2025-01-23  
**Estado**: ✅ Listo para implementar

