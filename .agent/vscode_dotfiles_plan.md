# Plan Unificado Final: Gestión Completa de VS Code en Dotfiles

## 📋 Resumen Ejecutivo

Este plan describe cómo tomar control total de VS Code en tus dotfiles:
- ✅ Desactivar Settings Sync de VS Code
- ✅ Gestión declarativa de extensiones (Flow Icons + Wallbash)
- ✅ `settings.json` y `keybindings.json` gestionados por Nix
- ✅ Sobrescribir gestión automática de Hydenix
- ✅ Seguir patrón de archivos mutables existente

---

## 📐 Arquitectura Propuesta

### Estructura de Archivos

```
Dotfiles/
├── resources/
│   └── config/
│       └── vscode/
│           ├── settings.json      # [NUEVO] Configuración personalizada
│           └── keybindings.json   # [NUEVO] Keybindings personalizados
└── modules/
    └── hm/
        ├── default.nix            # [MODIFICAR] Desactivar Hydenix + importar vscode
        ├── files.nix              # [MODIFICAR] Agregar symlinks VSCode
        └── programs/
            └── editors/
                ├── default.nix    # [NUEVO] Importador de editores
                └── vscode.nix     # [NUEVO] Configuración declarativa VSCode
```

---

## 📝 Plan de Implementación Paso a Paso

### FASE 1: Preparación de Archivos de Configuración

#### 1.1 Crear estructura de directorios
```bash
mkdir -p ~/Dotfiles/resources/config/vscode
mkdir -p ~/Dotfiles/modules/hm/programs/editors
```

#### 1.2 Crear `settings.json` con Settings Sync desactivado

**Archivo:** `~/Dotfiles/resources/config/vscode/settings.json`

```json
{
  "workbench.colorTheme": "Wallbash",
  
  "settingsSync.keybindingsPerPlatform": false,
  
  "window.menuBarVisibility": "toggle",
  "editor.fontFamily": "'JetBrainsMono Nerd Font', 'Droid Sans Mono', 'monospace'",
  "editor.fontSize": 14,
  "editor.lineNumbers": "on",
  "editor.rulers": [80, 120],
  "editor.renderWhitespace": "boundary",
  "editor.minimap.enabled": true,
  "editor.cursorBlinking": "smooth",
  "editor.cursorSmoothCaretAnimation": "on",
  
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.fontFamily": "'JetBrainsMono Nerd Font'",
  
  "workbench.iconTheme": "flow-icons",
  
  "telemetry.telemetryLevel": "off",
  
  "git.confirmSync": false,
  "git.autofetch": true,
  "git.enableSmartCommit": true
}
```

**Notas sobre este archivo:**
- ✅ Settings Sync está desactivado
- ✅ Tema Wallbash configurado
- ✅ Iconos Flow Icons configurados
- ✅ Telemetría desactivada
- ✅ Fuentes configuradas para Nerd Fonts
- 📝 Personaliza según tus preferencias

#### 1.3 Crear `keybindings.json` inicial

**Archivo:** `~/Dotfiles/resources/config/vscode/keybindings.json`

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

**Nota:** Agrega tus keybindings personalizados aquí más adelante.

---

### FASE 2: Crear Módulo Declarativo de VS Code

#### 2.1 Crear módulo principal de VS Code

**Archivo:** `~/Dotfiles/modules/hm/programs/editors/vscode.nix`

```nix
{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;  # Versión FHS para mejor compatibilidad
    
    # Permitir instalación manual de extensiones adicionales
    mutableExtensionsDir = true;
    
    # Comenzamos sin extensiones declarativas
    # Las instalaremos manualmente y luego las declararemos
    extensions = [ ];
  };
}
```

**Notas:**
- ✅ `mutableExtensionsDir = true` permite instalar extensiones manualmente
- ✅ `extensions = [ ]` vacío por ahora - Flow Icons se instalará manualmente
- ✅ Wallbash se gestionará por separado (vía symlink)

---

#### 2.2 Crear importador de editores

**Archivo:** `~/Dotfiles/modules/hm/programs/editors/default.nix`

```nix
{ ... }:

{
  imports = [
    ./vscode.nix
  ];
}
```

---

### FASE 3: Gestionar Extensión Wallbash

Wallbash es exclusiva de Hydenix y no está en el marketplace público. Necesitamos copiarla manualmente.

---

### FASE 4: Modificar Módulos de Home Manager

#### 4.1 Agregar symlinks de configuración en `files.nix`

**Archivo:** `~/Dotfiles/modules/hm/files.nix`

**Ubicación:** Después de la línea 23 (después de neovide)

**Código completo a agregar:**

```nix
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
```

**Contexto completo (líneas 18-35 aproximadamente):**

```nix
  home.file = {
    # ... configuraciones anteriores ...
    
    # Neovide configuration
    ".config/neovide/config.toml" = {
      source = mkSymlink "${dotfilesDir}/resources/config/neovide/config.toml";
    };
    
    # VS Code Configuration [AGREGAR AQUÍ]
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
    
    # ... resto de configuraciones ...
  };
```

---

#### 4.2 Modificar `default.nix` para importar y desactivar Hydenix

**Archivo:** `~/Dotfiles/modules/hm/default.nix`

**Cambio 1 - Desactivar VSCode de Hydenix:**

**Ubicación:** Después de la línea 42 (configuraciones de Hydenix)

```nix
  # Desactivar VSCode de Hydenix para usar configuración personalizada
  hydenix.hm.editors.vscode.enable = false;
```

**Contexto completo:**
```nix
  # Configuración de Hydenix
  hydenix.hm = {
    # ... otras configuraciones ...
    
    # Desactivar editores de Hydenix para usar configuración personalizada
    editors.neovim.enable = false;  # Ya existe
    editors.vscode.enable = false;  # [AGREGAR ESTA LÍNEA]
  };
```

**Cambio 2 - Importar módulo de editores:**

**Ubicación:** En la sección `imports`, cambiar la línea comentada

**Antes:**
```nix
  imports = [
    ./programs/shell
    ./programs/media
    ./programs/utils
    # ./programs/editors  # Future: Editors (neovim, vscode, helix)
    ./files.nix
  ];
```

**Después:**
```nix
  imports = [
    ./programs/shell
    ./programs/media
    ./programs/utils
    ./programs/editors  # [DESCOMENTAR Y ACTIVAR]
    ./files.nix
  ];
```

---

### FASE 5: Aplicar y Verificar

#### 5.1 Hacer backup
```bash
# Backup de configuración actual
cp ~/.config/Code/User/settings.json \
   ~/.config/Code/User/settings.json.backup-$(date +%Y%m%d-%H%M%S)
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
2. Instalación de VS Code con extensiones
3. Creación de symlinks
4. Desactivación de gestión de Hydenix
5. Copia de extensión Wallbash

#### 5.4 Verificación de symlinks
```bash
# Verificar configuración
ls -la ~/.config/Code/User/

# Salida esperada:
# settings.json -> /home/ludus/Dotfiles/resources/config/vscode/settings.json
# keybindings.json -> /home/ludus/Dotfiles/resources/config/vscode/keybindings.json

# Verificar extensión Wallbash
ls -la ~/.vscode/extensions/ | grep wallbash
```

#### 5.5 Instalar Flow Icons manualmente (por ahora)
```bash
# Abrir VS Code
code

# En VS Code:
# Ctrl+Shift+X (Extensions)
# Buscar: "Flow Icons"
# Instalar extensión de thang-nm
```

#### 5.6 Verificación funcional
```bash
# Abrir VS Code
code

# Verificar:
# 1. Settings Sync debe estar desactivado
# 2. Tema Wallbash activo
# 3. Iconos Flow Icons activos (después de instalarlos)
# 4. File > Preferences > Settings - muestra tu configuración
```

#### 5.7 Probar edición inmediata
```bash
# Editar settings.json
nvim ~/Dotfiles/resources/config/vscode/settings.json

# Cambiar algo, por ejemplo:
# "editor.fontSize": 16

# En VS Code: Ctrl+Shift+P > "Reload Window"
# El cambio debería reflejarse inmediatamente
```

---

## 🔄 Flujo de Trabajo Futuro

### Agregar Nuevas Extensiones

#### Método 1: Instalación Manual (Recomendado para empezar)
```bash
# 1. Instalar desde VS Code UI
# Ctrl+Shift+X > Buscar extensión > Instalar

# 2. (Opcional) Declarar posteriormente en vscode.nix
```

#### Método 2: Declarativo (Para extensiones críticas)

**Encontrar extensión en nixpkgs:**
```bash
# Buscar en nixpkgs
nix search nixpkgs vscode-extensions | grep nombre-extension
```

**Si existe en nixpkgs, agregar a `vscode.nix`:**
```nix
extensions = with pkgs.vscode-extensions; [
  # Ejemplo
  ms-python.python
  vscodevim.vim
  # ... etc
];
```

**Si NO existe en nixpkgs, agregar desde marketplace:**
```nix
extensions = [ ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
  {
    name = "nombre-extension";
    publisher = "nombre-publisher";
    version = "x.y.z";
    sha256 = "hash-aqui";
  }
];
```

**Obtener información de extensión:**
```bash
# URL de marketplace
# https://marketplace.visualstudio.com/items?itemName=publisher.nombre

# Para obtener hash (después de instalar manualmente):
code --list-extensions --show-versions | grep nombre
```

### Editar Configuración

```bash
# 1. Editar archivos en el repositorio
nvim ~/Dotfiles/resources/config/vscode/settings.json
nvim ~/Dotfiles/resources/config/vscode/keybindings.json

# 2. Los cambios son INMEDIATOS
#    Solo recargar: Ctrl+Shift+P > "Reload Window"

# 3. Commitear cambios
cd ~/Dotfiles
git add resources/config/vscode/
git commit -m "feat(vscode): update settings"
git push
```

### Agregar Extensiones Declarativas

```bash
# 1. Editar vscode.nix
nvim ~/Dotfiles/modules/hm/programs/editors/vscode.nix

# 2. Agregar extensión a la lista

# 3. Rebuild
cd ~/Dotfiles
make switch
```

---

## 📊 Resumen de Archivos

### Archivos NUEVOS a Crear

```
📁 Dotfiles/
├── 📁 resources/config/vscode/
│   ├── 📄 settings.json              # Configuración con Wallbash + Settings Sync OFF
│   └── 📄 keybindings.json           # Keybindings personalizados
└── 📁 modules/hm/programs/editors/
    ├── 📄 default.nix                # Importador
    └── 📄 vscode.nix                 # Configuración declarativa VSCode
```

### Archivos a MODIFICAR

```
📁 Dotfiles/modules/hm/
├── 📄 default.nix
│   ├── Línea ~35: Descomentar ./programs/editors
│   └── Línea ~43: Agregar hydenix.hm.editors.vscode.enable = false;
└── 📄 files.nix
    └── Línea ~24: Agregar 3 bloques (settings, keybindings, wallbash)
```

---

## 🧪 Checklist Completo de Implementación

### Pre-Implementación
- [ ] Backup de `~/.config/Code/User/settings.json`
- [ ] Verificar que `pkgs.hyde` está disponible (para Wallbash)
- [ ] Cerrar VS Code

### Fase 1: Archivos de Configuración
- [ ] `mkdir -p ~/Dotfiles/resources/config/vscode`
- [ ] Crear `settings.json` (copiar contenido del plan)
- [ ] Crear `keybindings.json` (copiar contenido del plan)

### Fase 2: Módulo VSCode
- [ ] `mkdir -p ~/Dotfiles/modules/hm/programs/editors`
- [ ] Crear `vscode.nix` (sin extensiones por ahora)
- [ ] Crear `default.nix` importador

### Fase 3: Modificar Home Manager
- [ ] Editar `modules/hm/files.nix` - agregar 3 bloques
- [ ] Editar `modules/hm/default.nix` - descomentar import
- [ ] Editar `modules/hm/default.nix` - desactivar Hydenix

### Fase 4: Aplicar
- [ ] `make test` (verificar sintaxis)
- [ ] `make switch` (aplicar cambios)

### Fase 5: Verificar
- [ ] Verificar symlinks: `ls -la ~/.config/Code/User/`
- [ ] Verificar Wallbash: `ls -la ~/.vscode/extensions/ | grep wallbash`
- [ ] Abrir VS Code y verificar tema
- [ ] Instalar Flow Icons manualmente
- [ ] Verificar que Settings Sync está desactivado
- [ ] Probar edición inmediata de `settings.json`

### Fase 6: Finalizar
- [ ] Commitear cambios al repositorio
- [ ] Push a remoto

---

## ⚠️ Troubleshooting

### Problema: Wallbash no funciona

**Síntoma:** Tema no se aplica o extensión no aparece

**Diagnóstico:**
```bash
ls -la ~/.vscode/extensions/ | grep wallbash
echo $?  # Si es 1, no existe
```

**Solución A - Verificar pkgs.hyde:**
```bash
nix-shell -p hyde --run "ls -la \$out/share/vscode/extensions/"
```

**Solución B - Copiar manualmente:**
```bash
# Si pkgs.hyde no está disponible, encontrar la extensión
find /nix/store -name "wallbash" 2>/dev/null | grep vscode

# Copiar al repo
mkdir -p ~/Dotfiles/resources/vscode-extensions/
cp -r /ruta/a/wallbash ~/Dotfiles/resources/vscode-extensions/

# Modificar files.nix:
".vscode/extensions/prasanthrangan.wallbash" = {
  source = mkSymlink "${dotfilesDir}/resources/vscode-extensions/wallbash";
  recursive = true;
  force = true;
};
```

### Problema: Settings Sync sigue activo

**Síntoma:** VS Code pregunta sobre sync al iniciar

**Solución:**
```bash
# Editar settings.json
nvim ~/Dotfiles/resources/config/vscode/settings.json

# Asegurar que está:
"settingsSync.keybindingsPerPlatform": false

# Reload VS Code: Ctrl+Shift+P > "Reload Window"
```

### Problema: Flow Icons no aparece

**Solución:**
```bash
# En VS Code:
# 1. Ctrl+Shift+X
# 2. Buscar "Flow Icons" (thang-nm)
# 3. Instalar
# 4. File > Preferences > File Icon Theme > Flow Icons
```

### Problema: Cambios en settings.json no se aplican

**Diagnóstico:**
```bash
# Verificar que es symlink
readlink ~/.config/Code/User/settings.json

# Debe apuntar a:
# /home/ludus/Dotfiles/resources/config/vscode/settings.json
```

**Solución:**
```bash
# Si no es symlink, recrear
rm ~/.config/Code/User/settings.json
make switch
```

### Problema: Error al importar `./programs/editors`

**Síntoma:** `make test` falla con error de import

**Causa:** El directorio `programs/editors/` no existe o falta `default.nix`

**Solución:**
```bash
# Verificar que existen los archivos
ls -la ~/Dotfiles/modules/hm/programs/editors/

# Deben existir:
# - default.nix
# - vscode.nix

# Si no existen, crearlos según FASE 2
```

### Problema: pkgs.hyde no disponible

**Síntoma:** Error al hacer `make switch` relacionado con `pkgs.hyde`

**Solución temporal:**
```bash
# Comentar la sección de Wallbash en files.nix
# Instalar Wallbash manualmente si es necesario
```

---

## 🎯 Resultado Esperado

Después de implementar este plan:

✅ **Settings Sync desactivado** - Nix gestiona todo  
✅ **Tema Wallbash activo** - Integración con HyDE  
✅ **Flow Icons instalado** - Iconos personalizados  
✅ **Configuración versionada** - Todo en git  
✅ **Cambios inmediatos** - Sin rebuild para settings  
✅ **Extensiones reproducibles** - `mutableExtensionsDir` + declarativas futuras  
✅ **Sin conflictos con Hydenix** - Completamente desactivado  

---

## 📚 Próximos Pasos Recomendados

### Corto Plazo (Después de Implementar)
1. Personalizar `settings.json` según tus preferencias
2. Agregar keybindings personalizados
3. Instalar extensiones que uses frecuentemente

### Mediano Plazo
1. Declarar extensiones críticas en `vscode.nix`
2. Documentar extensiones instaladas manualmente
3. Crear snippets personalizados (si los usas)

### Largo Plazo
1. Migrar completamente a extensiones declarativas
2. Considerar crear perfiles de configuración (trabajo/personal)
3. Sincronizar snippets y tasks en el repo

---

## 📝 Notas Finales

### Sobre Extensiones Declarativas

Para el futuro, cuando quieras declarar extensiones:

**Proceso recomendado:**
1. Instalar manualmente primero
2. Probar que funciona
3. Obtener información: `code --list-extensions --show-versions`
4. Buscar en nixpkgs: `nix search nixpkgs vscode-extensions.nombre`
5. Si existe → agregar a `extensions = with pkgs.vscode-extensions;`
6. Si no existe → obtener hash y agregar a `extensionsFromVscodeMarketplace`

### Sobre Settings Sync

Settings Sync de VS Code está **completamente desactivado** en el `settings.json` proporcionado. Toda la sincronización se hace vía git con tus dotfiles.

**Ventajas:**
- ✅ Control total sobre qué se versiona
- ✅ No depender de servicios externos
- ✅ Integración perfecta con tu workflow de dotfiles

### Sobre Wallbash

Si `pkgs.hyde` no está disponible o da problemas:
1. Puedes comentar temporalmente la sección de Wallbash en `files.nix`
2. Cambiar el tema en `settings.json` a otro disponible (ej: "Dark+")
3. Investigar cómo obtener Wallbash de otra forma si lo necesitas

---

## 🔗 Referencias

- **Home Manager VSCode:** https://nix-community.github.io/home-manager/options.xhtml#opt-programs.vscode.enable
- **VSCode Settings:** https://code.visualstudio.com/docs/getstarted/settings
- **Nix Packages Search:** https://search.nixos.org/packages
- **VSCode Marketplace:** https://marketplace.visualstudio.com/vscode

---

**Fecha de creación:** 2025-01-23  
**Última actualización:** 2025-01-23  
**Estado:** ✅ Listo para implementar

---

## 🚀 Comandos Rápidos de Referencia

```bash
# Crear estructura
mkdir -p ~/Dotfiles/resources/config/vscode
mkdir -p ~/Dotfiles/modules/hm/programs/editors

# Verificar symlinks
ls -la ~/.config/Code/User/

# Listar extensiones actuales
code --list-extensions --show-versions

# Buscar extensión en nixpkgs
nix search nixpkgs vscode-extensions.nombre

# Test y aplicar
cd ~/Dotfiles
make test
make switch

# Verificar Wallbash
ls -la ~/.vscode/extensions/ | grep wallbash
```

---

El plan está completo y listo para ser implementado. Sigue el checklist paso a paso y consulta la sección de troubleshooting si encuentras algún problema.