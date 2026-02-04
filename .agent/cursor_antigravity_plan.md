# Plan Unificado: Gestión de Cursor y AntiGravity en Dotfiles

## 📋 Resumen Ejecutivo

Este plan describe cómo gestionar **Cursor** y **AntiGravity** en tus dotfiles siguiendo el mismo patrón que VS Code:
- ✅ Configuración de Cursor (`settings.json` y `keybindings.json`)
- ✅ Configuración de AntiGravity (`settings.json` y `keybindings.json`)
- ✅ Configuración mínima funcional para construir desde cero
- ✅ Desactivar Settings Sync
- ✅ Control total mediante Nix

**Ambos editores ya están instalados y funcionando.**

---

## 📐 Arquitectura Propuesta

### Estructura de Archivos

```
Dotfiles/
├── resources/
│   └── config/
│       ├── vscode/
│       │   ├── settings.json
│       │   └── keybindings.json
│       ├── cursor/
│       │   ├── settings.json      # [NUEVO] Configuración mínima Cursor
│       │   └── keybindings.json   # [NUEVO] Keybindings Cursor
│       └── antigravity/
│           ├── settings.json      # [NUEVO] Configuración mínima AntiGravity
│           └── keybindings.json   # [NUEVO] Keybindings AntiGravity
└── modules/
    └── hm/
        ├── default.nix            # [MODIFICAR] Importar editores
        ├── files.nix              # [MODIFICAR] Agregar symlinks
        └── programs/
            └── editors/
                ├── default.nix    # [MODIFICAR] Importar cursor y antigravity
                ├── vscode.nix     # Ya existe
                ├── cursor.nix     # [NUEVO] Módulo Cursor
                └── antigravity.nix # [NUEVO] Módulo AntiGravity
```

---

## 📝 Plan de Implementación Paso a Paso

### FASE 1: Preparación de Archivos de Configuración

#### 1.1 Crear estructura de directorios
```bash
mkdir -p ~/Dotfiles/resources/config/cursor
mkdir -p ~/Dotfiles/resources/config/antigravity
```

#### 1.2 Hacer backup de configuraciones actuales
```bash
# Backup Cursor
cp ~/.config/Cursor/User/settings.json \
   ~/.config/Cursor/User/settings.json.backup-$(date +%Y%m%d-%H%M%S)
cp ~/.config/Cursor/User/keybindings.json \
   ~/.config/Cursor/User/keybindings.json.backup-$(date +%Y%m%d-%H%M%S) 2>/dev/null

# Backup AntiGravity
cp ~/.config/Antigravity/User/settings.json \
   ~/.config/Antigravity/User/settings.json.backup-$(date +%Y%m%d-%H%M%S)
cp ~/.config/Antigravity/User/keybindings.json \
   ~/.config/Antigravity/User/keybindings.json.backup-$(date +%Y%m%d-%H%M%S) 2>/dev/null
```

---

### FASE 2: Crear Archivos de Configuración Mínimos

#### 2.1 Cursor - `settings.json` mínimo

**Archivo:** `~/Dotfiles/resources/config/cursor/settings.json`

```json
{
  "settingsSync.keybindingsPerPlatform": false,
  
  "workbench.colorTheme": "Dark+",
  "workbench.iconTheme": "vs-seti",
  
  "editor.fontFamily": "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'",
  "editor.fontSize": 14,
  "editor.lineNumbers": "on",
  "editor.minimap.enabled": true,
  
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'",
  
  "telemetry.telemetryLevel": "off",
  
  "cursor.ai.enableAutoCompletion": true,
  "cursor.ai.enableChat": true
}
```

**Características:**
- ✅ Settings Sync desactivado
- ✅ Configuración básica de editor
- ✅ IA de Cursor habilitada
- ✅ Telemetría desactivada
- 📝 Listo para expandir según necesites

---

#### 2.2 Cursor - `keybindings.json`

**Archivo:** `~/Dotfiles/resources/config/cursor/keybindings.json`

```json
[
  {
    "key": "ctrl+i",
    "command": "composerMode.agent"
  },
  {
    "key": "ctrl+shift+t",
    "command": "workbench.action.terminal.toggleTerminal"
  },
  {
    "key": "ctrl+shift+e",
    "command": "workbench.view.explorer"
  }
]
```

**Características:**
- ✅ Ctrl+I para Composer Mode (según tu configuración)
- ✅ Keybindings básicos de terminal y explorador
- 📝 Listo para agregar más shortcuts

---

#### 2.3 AntiGravity - `settings.json` mínimo

**Archivo:** `~/Dotfiles/resources/config/antigravity/settings.json`

```json
{
  "settingsSync.keybindingsPerPlatform": false,
  
  "workbench.colorTheme": "Dark+",
  "workbench.iconTheme": "vs-seti",
  
  "editor.fontFamily": "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'",
  "editor.fontSize": 14,
  "editor.lineNumbers": "on",
  "editor.minimap.enabled": true,
  
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'",
  
  "telemetry.telemetryLevel": "off"
}
```

**Características:**
- ✅ Settings Sync desactivado
- ✅ Configuración básica idéntica a Cursor
- ✅ Sin configuraciones específicas de IA (agregar si AntiGravity las tiene)
- 📝 Mínimo funcional

---

#### 2.4 AntiGravity - `keybindings.json` mínimo

**Archivo:** `~/Dotfiles/resources/config/antigravity/keybindings.json`

```json
[
  {
    "key": "ctrl+shift+t",
    "command": "workbench.action.terminal.toggleTerminal"
  },
  {
    "key": "ctrl+shift+e",
    "command": "workbench.view.explorer"
  }
]
```

**Características:**
- ✅ Keybindings básicos universales
- 📝 Agregar shortcuts específicos de AntiGravity según descubras

---

### FASE 3: Crear Módulos de Nix

#### 3.1 Crear módulo de Cursor

**Archivo:** `~/Dotfiles/modules/hm/programs/editors/cursor.nix`

```nix
{ config, lib, pkgs, ... }:

{
  # Cursor ya está instalado manualmente
  # Este módulo solo documenta su presencia
  # La configuración se gestiona con symlinks en files.nix
}
```

---

#### 3.2 Crear módulo de AntiGravity

**Archivo:** `~/Dotfiles/modules/hm/programs/editors/antigravity.nix`

```nix
{ config, lib, pkgs, ... }:

{
  # AntiGravity ya está instalado manualmente
  # Este módulo solo documenta su presencia
  # La configuración se gestiona con symlinks en files.nix
}
```

---

#### 3.3 Modificar importador de editores

**Archivo:** `~/Dotfiles/modules/hm/programs/editors/default.nix`

**Antes:**
```nix
{ ... }:

{
  imports = [
    ./vscode.nix
  ];
}
```

**Después:**
```nix
{ ... }:

{
  imports = [
    ./vscode.nix
    ./cursor.nix
    ./antigravity.nix
  ];
}
```

---

### FASE 4: Modificar `files.nix`

**Archivo:** `~/Dotfiles/modules/hm/files.nix`

**Ubicación:** Después de la configuración de VS Code

**Código completo a agregar:**

```nix
    # Cursor Configuration
    ".config/Cursor/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/cursor/settings.json";
      force = true;
    };
    
    ".config/Cursor/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/cursor/keybindings.json";
      force = true;
    };
    
    # AntiGravity Configuration
    ".config/Antigravity/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/antigravity/settings.json";
      force = true;
    };
    
    ".config/Antigravity/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/antigravity/keybindings.json";
      force = true;
    };
```

**Contexto completo (aproximadamente líneas 24-50):**

```nix
  home.file = {
    # ... configuraciones anteriores ...
    
    # VS Code Configuration
    ".config/Code/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/vscode/settings.json";
      force = true;
    };
    
    ".config/Code/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/vscode/keybindings.json";
      force = true;
    };
    
    # Extensión Wallbash de Hydenix
    ".vscode/extensions/prasanthrangan.wallbash" = {
      source = "${pkgs.hyde}/share/vscode/extensions/prasanthrangan.wallbash";
      recursive = true;
      force = true;
    };
    
    # Cursor Configuration [AGREGAR AQUÍ]
    ".config/Cursor/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/cursor/settings.json";
      force = true;
    };
    
    ".config/Cursor/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/cursor/keybindings.json";
      force = true;
    };
    
    # AntiGravity Configuration
    ".config/Antigravity/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/antigravity/settings.json";
      force = true;
    };
    
    ".config/Antigravity/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/antigravity/keybindings.json";
      force = true;
    };
    
    # ... resto de configuraciones ...
  };
```

---

### FASE 5: Aplicar y Verificar

#### 5.1 Cerrar editores
```bash
# Cerrar todos los editores antes de aplicar
pkill -f "cursor"
pkill -f "antigravity"
```

#### 5.2 Prueba de sintaxis
```bash
cd ~/Dotfiles
make test
```

**Salida esperada:** Sin errores de sintaxis Nix.

#### 5.3 Aplicar cambios
```bash
make switch
```

**Esto ejecutará:**
1. Rebuild de Home Manager
2. Creación de symlinks para Cursor
3. Creación de symlinks para AntiGravity

#### 5.4 Verificación de symlinks

```bash
# Verificar Cursor
ls -la ~/.config/Cursor/User/
readlink -f ~/.config/Cursor/User/settings.json
readlink -f ~/.config/Cursor/User/keybindings.json

# Salida esperada:
# settings.json -> /home/ludus/Dotfiles/resources/config/cursor/settings.json
# keybindings.json -> /home/ludus/Dotfiles/resources/config/cursor/keybindings.json

# Verificar AntiGravity
ls -la ~/.config/Antigravity/User/
readlink -f ~/.config/Antigravity/User/settings.json
readlink -f ~/.config/Antigravity/User/keybindings.json

# Salida esperada:
# settings.json -> /home/ludus/Dotfiles/resources/config/antigravity/settings.json
# keybindings.json -> /home/ludus/Dotfiles/resources/config/antigravity/keybindings.json
```

#### 5.5 Verificación funcional

**Cursor:**
```bash
# Abrir Cursor
cursor

# Verificar:
# 1. Settings Sync debe estar desactivado
# 2. Tema Dark+ aplicado
# 3. Ctrl+I debe abrir Composer Mode
# 4. File > Preferences > Settings - muestra configuración mínima
```

**AntiGravity:**
```bash
# Abrir AntiGravity (ajustar comando según cómo se lance)
antigravity  # o el comando correcto

# Verificar:
# 1. Settings Sync debe estar desactivado
# 2. Tema Dark+ aplicado
# 3. File > Preferences > Settings - muestra configuración mínima
```

#### 5.6 Probar edición inmediata

```bash
# Editar settings de Cursor
nvim ~/Dotfiles/resources/config/cursor/settings.json

# Cambiar algo, por ejemplo:
# "editor.fontSize": 16

# En Cursor: Ctrl+Shift+P > "Reload Window"
# El cambio debería reflejarse inmediatamente

# Repetir para AntiGravity
nvim ~/Dotfiles/resources/config/antigravity/settings.json
```

---

## 🔄 Flujo de Trabajo Futuro

### Agregar Configuraciones Gradualmente

```bash
# 1. Editar archivos en el repositorio
nvim ~/Dotfiles/resources/config/cursor/settings.json
nvim ~/Dotfiles/resources/config/antigravity/settings.json

# 2. Los cambios son INMEDIATOS
#    Solo recargar ventana en el editor correspondiente
#    Ctrl+Shift+P > "Reload Window"

# 3. Commitear cambios
cd ~/Dotfiles
git add resources/config/cursor/
git add resources/config/antigravity/
git commit -m "feat(editors): add cursor and antigravity settings"
git push
```

### Ejemplo de Configuraciones para Agregar Gradualmente

**Cursor - Settings avanzados:**
```json
{
  // Configuración mínima actual...
  
  // Agregar gradualmente:
  "cursor.ai.model": "gpt-4",
  "cursor.ai.temperature": 0.7,
  "cursor.ai.maxTokens": 2000,
  
  "editor.rulers": [80, 120],
  "editor.renderWhitespace": "boundary",
  "editor.cursorBlinking": "smooth",
  
  "git.confirmSync": false,
  "git.autofetch": true
}
```

**AntiGravity - Settings avanzados:**
```json
{
  // Configuración mínima actual...
  
  // Agregar configuraciones específicas de AntiGravity
  // según descubras funcionalidades
}
```

---

## 📊 Resumen de Archivos

### Archivos NUEVOS a Crear

```
📁 Dotfiles/
├── 📁 resources/config/cursor/
│   ├── 📄 settings.json              # Configuración mínima Cursor
│   └── 📄 keybindings.json           # Keybindings con Ctrl+I
├── 📁 resources/config/antigravity/
│   ├── 📄 settings.json              # Configuración mínima AntiGravity
│   └── 📄 keybindings.json           # Keybindings básicos
└── 📁 modules/hm/programs/editors/
    ├── 📄 cursor.nix                 # Módulo Cursor (vacío)
    └── 📄 antigravity.nix            # Módulo AntiGravity (vacío)
```

### Archivos a MODIFICAR

```
📁 Dotfiles/modules/hm/
├── 📄 programs/editors/default.nix   # +2 líneas (imports)
└── 📄 files.nix                      # +16 líneas (symlinks)
```

---

## 🧪 Checklist Completo de Implementación

### Pre-Implementación
- [ ] Verificar que Cursor funciona: `cursor --version` o abrir Cursor
- [ ] Verificar que AntiGravity funciona: abrir AntiGravity
- [ ] Backup de configuraciones actuales (ejecutar comandos de FASE 1.2)
- [ ] Cerrar ambos editores

### Fase 1: Archivos de Configuración
- [ ] `mkdir -p ~/Dotfiles/resources/config/cursor`
- [ ] `mkdir -p ~/Dotfiles/resources/config/antigravity`
- [ ] Crear `cursor/settings.json` (copiar del plan)
- [ ] Crear `cursor/keybindings.json` (copiar del plan)
- [ ] Crear `antigravity/settings.json` (copiar del plan)
- [ ] Crear `antigravity/keybindings.json` (copiar del plan)

### Fase 2: Módulos de Nix
- [ ] Crear `modules/hm/programs/editors/cursor.nix`
- [ ] Crear `modules/hm/programs/editors/antigravity.nix`
- [ ] Modificar `modules/hm/programs/editors/default.nix` (agregar imports)

### Fase 3: Modificar Home Manager
- [ ] Editar `modules/hm/files.nix` - agregar symlinks de Cursor (8 líneas)
- [ ] Editar `modules/hm/files.nix` - agregar symlinks de AntiGravity (8 líneas)

### Fase 4: Aplicar
- [ ] Cerrar editores: `pkill -f "cursor" && pkill -f "antigravity"`
- [ ] `make test` (verificar sintaxis)
- [ ] `make switch` (aplicar cambios)

### Fase 5: Verificar
- [ ] Verificar symlinks Cursor: `readlink ~/.config/Cursor/User/settings.json`
- [ ] Verificar symlinks AntiGravity: `readlink ~/.config/Antigravity/User/settings.json`
- [ ] Abrir Cursor y verificar configuración
- [ ] Abrir AntiGravity y verificar configuración
- [ ] Probar Ctrl+I en Cursor (Composer Mode)
- [ ] Probar edición inmediata de settings.json

### Fase 6: Finalizar
- [ ] Commitear cambios al repositorio
- [ ] Push a remoto

---

## ⚠️ Troubleshooting

### Problema: Symlinks no se crean

**Diagnóstico:**
```bash
# Verificar que los directorios existen
ls -la ~/.config/Cursor/User/
ls -la ~/.config/Antigravity/User/

# Ver generaciones de home-manager
home-manager generations | head -n 5
```

**Solución:**
```bash
# Crear directorios si no existen
mkdir -p ~/.config/Cursor/User
mkdir -p ~/.config/Antigravity/User

# Forzar recreación
rm ~/.config/Cursor/User/settings.json 2>/dev/null
rm ~/.config/Antigravity/User/settings.json 2>/dev/null
make switch
```

---

### Problema: Cursor no reconoce Ctrl+I para Composer Mode

**Diagnóstico:**
```bash
# Verificar keybindings
cat ~/.config/Cursor/User/keybindings.json

# Debe contener:
# {"key": "ctrl+i", "command": "composerMode.agent"}
```

**Solución:**
```bash
# Editar keybindings
nvim ~/Dotfiles/resources/config/cursor/keybindings.json

# Verificar formato JSON válido
jq . ~/Dotfiles/resources/config/cursor/keybindings.json

# Reload Cursor: Ctrl+Shift+P > "Reload Window"
```

---

### Problema: Settings Sync sigue activo

**Síntoma:** Editor pregunta sobre sincronización al iniciar

**Solución:**
```bash
# Verificar settings.json
cat ~/Dotfiles/resources/config/cursor/settings.json | grep settingsSync
cat ~/Dotfiles/resources/config/antigravity/settings.json | grep settingsSync

# Debe mostrar:
# "settingsSync.keybindingsPerPlatform": false

# Si no está, agregarlo y reload
```

---

### Problema: Cambios en settings.json no se aplican

**Diagnóstico:**
```bash
# Verificar que son symlinks
ls -la ~/.config/Cursor/User/settings.json
ls -la ~/.config/Antigravity/User/settings.json

# Debe mostrar -> apuntando a Dotfiles
```

**Solución:**
```bash
# Si no son symlinks, recrear
rm ~/.config/Cursor/User/settings.json
rm ~/.config/Antigravity/User/settings.json
make switch

# Verificar de nuevo
readlink ~/.config/Cursor/User/settings.json
readlink ~/.config/Antigravity/User/settings.json
```

---

### Problema: AntiGravity no inicia después de cambios

**Diagnóstico:**
```bash
# Verificar permisos
ls -la ~/Dotfiles/resources/config/antigravity/

# Verificar JSON válido
jq . ~/Dotfiles/resources/config/antigravity/settings.json
```

**Solución:**
```bash
# Si hay error de sintaxis JSON, corregir
nvim ~/Dotfiles/resources/config/antigravity/settings.json

# Asegurar permisos correctos
chmod 644 ~/Dotfiles/resources/config/antigravity/*.json

# Reiniciar AntiGravity
```

---

## 🎯 Resultado Esperado

Después de implementar este plan:

✅ **Cursor configurado** - Settings mínimo funcional en dotfiles  
✅ **AntiGravity configurado** - Settings mínimo funcional en dotfiles  
✅ **Settings Sync desactivado** - En ambos editores  
✅ **Ctrl+I funciona** - Composer Mode en Cursor  
✅ **Cambios inmediatos** - Sin rebuild para settings  
✅ **Configuración versionada** - Todo en git  
✅ **Base sólida** - Lista para expandir gradualmente  

---

## 📚 Comandos Rápidos de Referencia

```bash
# Crear estructura
mkdir -p ~/Dotfiles/resources/config/{cursor,antigravity}
mkdir -p ~/Dotfiles/modules/hm/programs/editors

# Verificar configuraciones actuales
cat ~/.config/Cursor/User/settings.json
cat ~/.config/Antigravity/User/settings.json

# Verificar symlinks después de aplicar
readlink -f ~/.config/Cursor/User/settings.json
readlink -f ~/.config/Antigravity/User/settings.json

# Editar configuraciones
nvim ~/Dotfiles/resources/config/cursor/settings.json
nvim ~/Dotfiles/resources/config/antigravity/settings.json

# Test y aplicar
cd ~/Dotfiles
make test
make switch

# Verificar JSON válido
jq . ~/Dotfiles/resources/config/cursor/settings.json
jq . ~/Dotfiles/resources/config/antigravity/settings.json
```

---

## 🔄 Ejemplos de Expansión Gradual

### Paso 1: Configuración básica (ACTUAL)
```json
{
  "settingsSync.keybindingsPerPlatform": false,
  "workbench.colorTheme": "Dark+",
  "editor.fontSize": 14
}
```

### Paso 2: Agregar preferencias de editor
```json
{
  // ... configuración básica ...
  "editor.rulers": [80, 120],
  "editor.renderWhitespace": "boundary",
  "editor.bracketPairColorization.enabled": true,
  "editor.guides.bracketPairs": true
}
```

### Paso 3: Agregar preferencias de terminal
```json
{
  // ... configuración anterior ...
  "terminal.integrated.defaultProfile.linux": "bash",
  "terminal.integrated.cursorStyle": "line",
  "terminal.integrated.cursorBlinking": true
}
```

### Paso 4: Agregar extensiones y lenguajes
```json
{
  // ... configuración anterior ...
  "[nix]": {
    "editor.defaultFormatter": "jnoortheen.nix-ide"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter"
  }
}
```

---

## 🔗 Referencias

- **Cursor Official:** https://cursor.sh
- **Cursor Docs:** https://docs.cursor.sh
- **VSCode Settings Reference:** https://code.visualstudio.com/docs/getstarted/settings
- **Home Manager:** https://nix-community.github.io/home-manager/

---

**Fecha de creación:** 2025-01-23  
**Última actualización:** 2025-01-23  
**Estado:** ✅ Listo para implementar

---

## 🚀 Inicio Rápido

```bash
# 1. Crear estructura
mkdir -p ~/Dotfiles/resources/config/{cursor,antigravity}
mkdir -p ~/Dotfiles/modules/hm/programs/editors

# 2. Copiar archivos del plan (usar artifact arriba)
# - cursor/settings.json
# - cursor/keybindings.json
# - antigravity/settings.json
# - antigravity/keybindings.json
# - cursor.nix
# - antigravity.nix

# 3. Modificar default.nix y files.nix según el plan

# 4. Aplicar
cd ~/Dotfiles
make test && make switch

# 5. Verificar
readlink ~/.config/Cursor/User/settings.json
readlink ~/.config/Antigravity/User/settings.json
```

¡El plan está completo y listo para implementar! Sigue el checklist paso a paso.