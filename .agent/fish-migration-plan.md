# Plan de Migración: Fish Shell desde kaku

**Objetivo**: Migrar el 100% de la funcionalidad de Fish de `/home/ludus/Work/kaku` a `/home/ludus/Dotfiles` de forma metódica y atómica (archivo por archivo).

**Fecha de creación**: 2025-01-XX

---

## Análisis Comparativo

### Archivos en kaku relacionados con Fish

1. **`system/programs/fish.nix`** - Configuración a nivel de sistema
2. **`home/terminal/shell/fish.nix`** - Configuración principal de Fish
3. **`home/terminal/shell/carapace.nix`** - Integración de Carapace
4. **`home/terminal/shell/starship.nix`** - Configuración de Starship
5. **`home/terminal/software/fzf.nix`** - Integración de fzf
6. **`home/terminal/software/zoxide.nix`** - Integración de zoxide
7. **`home/terminal/software/atuin.nix`** - Integración de atuin
8. **`home/terminal/software/autojump.nix`** - Integración de autojump
9. **`home/terminal/software/command-not-found.nix`** - Handler de comandos no encontrados
10. **`home/terminal/software/skim.nix`** - Integración de skim (sk)
11. **`home/terminal/software/nix-your-shell.nix`** - Integración de nix-your-shell

---

## Plan de Migración Archivo por Archivo

### FASE 1: Configuración del Sistema

#### Archivo 1: `system/programs/fish.nix`

**Ubicación kaku**: `/home/ludus/Work/kaku/system/programs/fish.nix`  
**Ubicación Dotfiles**: Necesita crearse o actualizarse en módulo de sistema

**Cambios necesarios**:
- [ ] Agregar `fish` a `environment.shells`
- [ ] Agregar `"/share/fish"` a `environment.pathsToLink`
- [ ] Habilitar `programs.fish.enable = true`
- [ ] Habilitar `programs.less.enable = true`

**Estado actual**: Revisar si existe configuración de sistema para Fish

---

### FASE 2: Configuración Principal de Fish

#### Archivo 2: `modules/hm/programs/terminal/shell/fish.nix`

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/shell/fish.nix`  
**Ubicación Dotfiles**: `/home/ludus/Dotfiles/modules/hm/programs/terminal/shell/fish.nix`

**Diferencias encontradas**:

1. **Variables de entorno desde agenix/secrets**:
   - [ ] kaku carga tokens desde `/run/agenix/` (discordo, openrouter, github, twt)
   - [ ] Nuestra config no tiene esto - **DECISIÓN**: ¿Agregar soporte para secrets?

2. **Editor**:
   - [ ] kaku usa `hx` (helix) como editor
   - [ ] Nuestra usa `nvim` - **MANTENER** (configurable)

3. **Keybindings personalizados**:
   - [ ] kaku tiene `bind -M insert \cx\ce edit_command_buffer` (nuestro usa `\cx`)
   - [ ] kaku desvincula `alt-s`, `alt-v`, `alt-z` (para Zellij)
   - [ ] **AGREGAR**: Desvincular alt-s, alt-v, alt-z

4. **History search**:
   - [ ] kaku usa `history-prefix-search-backward/forward` (ya lo tenemos)
   - ✅ Ya implementado

5. **Cursor shapes**:
   - ✅ Ya implementado (igual en ambos)

6. **Colores de sintaxis**:
   - ✅ Ya implementado (igual en ambos)

7. **Plugin settings**:
   - [ ] kaku: `fifc_keybinding \cv` vs nuestra: `\cx`
   - [ ] **DECISIÓN**: ¿Cambiar a `\cv` o mantener `\cx`?
   - [ ] kaku: `sudope_sequence \cs` - **AGREGAR** si no está

8. **Funciones personalizadas**:
   - ✅ `fcd` - Ya implementado
   - ✅ `installed` - Ya implementado
   - ✅ `installedall` - Ya implementado
   - ✅ `fm` - Ya implementado
   - ✅ `gitgrep` - Ya implementado

9. **Abbreviations**:
   - ✅ `z` y `zi` - Ya implementado

10. **Aliases**:
    - [ ] kaku tiene `koji="meteor"` - **AGREGAR** si meteor está instalado
    - [ ] kaku tiene alias `zed="zeditor"` - **AGREGAR**
    - ✅ Resto de aliases ya implementados

11. **Plugins**:
    - ✅ Todos los plugins ya están implementados

12. **Wrapper script `hx`**:
    - [ ] kaku crea wrapper `hx` para helix - **NO APLICABLE** (usamos nvim)

---

### FASE 3: Integración de Carapace

#### Archivo 3: `modules/hm/programs/terminal/shell/carapace.nix` (CREAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/shell/carapace.nix`  
**Ubicación Dotfiles**: `/home/ludus/Dotfiles/modules/hm/programs/terminal/shell/carapace.nix` (NO EXISTE)

**Cambios necesarios**:
- [ ] **CREAR** archivo `carapace.nix`
- [ ] Instalar paquetes: `carapace`, `carapace-bridge`, `inshellisense`
- [ ] Configurar `CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense"`
- [ ] Configurar `CARAPACE_CACHE_DIR`
- [ ] Crear archivo de configuración `carapace/carapace.toml`
- [ ] Generar completions de Fish: `carapace _carapace fish`

**Nota**: Nuestra config actual tiene carapace integrado en `fish.nix`, pero kaku lo tiene separado.

---

### FASE 4: Configuración de Starship

#### Archivo 4: `modules/hm/programs/terminal/shell/starship.nix`

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/shell/starship.nix`  
**Ubicación Dotfiles**: `/home/ludus/Dotfiles/modules/hm/programs/terminal/shell/starship.nix`

**Diferencias encontradas**:

1. **Formato del prompt**:
   - [ ] kaku: Formato de 2 líneas con `$status$username$hostname$directory...`
   - [ ] Nuestra: Formato de 3 líneas con decoraciones `┌───`, `│`, `└─>`
   - [ ] **DECISIÓN**: ¿Usar formato de kaku o mantener el nuestro?

2. **Módulos**:
   - [ ] kaku tiene `status` con símbolo `│` y colores específicos
   - [ ] kaku tiene `username` y `hostname` separados
   - [ ] kaku tiene `cmd_duration` con `min_time = 2000` y `show_milliseconds = true`
   - [ ] kaku tiene `nix_shell` con formato `[nix]($style)`
   - [ ] **ACTUALIZAR**: Ajustar formato según kaku

3. **Variables de entorno**:
   - [ ] kaku: `STARSHIP_CONFIG` y `STARSHIP_LOG` en `environment.sessionVariables`
   - [ ] Nuestra: En `fish/conf.d/starship.fish`
   - [ ] **DECISIÓN**: ¿Mover a sessionVariables o mantener en Fish?

4. **Completions**:
   - [ ] kaku: `fish/completions/starship.fish` desde paquete
   - [ ] **AGREGAR**: Completions de Starship

---

### FASE 5: Integraciones con Software

#### Archivo 5: `modules/hm/programs/terminal/software/fzf.nix` (CREAR o ACTUALIZAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/software/fzf.nix`  
**Ubicación Dotfiles**: Verificar si existe

**Cambios necesarios**:
- [ ] Instalar `fzf`
- [ ] Crear `fish/conf.d/fzf.fish` desde key-bindings del paquete
- [ ] Crear `fish/conf.d/fzf-extra.fish` con `FZF_DEFAULT_OPTS`

---

#### Archivo 6: `modules/hm/programs/terminal/software/zoxide.nix` (CREAR o ACTUALIZAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/software/zoxide.nix`  
**Ubicación Dotfiles**: Verificar si existe

**Cambios necesarios**:
- [ ] Instalar `zoxide`
- [ ] Generar `fish/conf.d/zoxide.fish` con `zoxide init fish`

---

#### Archivo 7: `modules/hm/programs/terminal/software/atuin.nix` (CREAR o ACTUALIZAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/software/atuin.nix`  
**Ubicación Dotfiles**: Verificar si existe

**Cambios necesarios**:
- [ ] Instalar `atuin`
- [ ] Crear `atuin/config.toml` con configuración completa:
  - `auto_sync = false`
  - `update_check = false`
  - `workspaces = false`
  - `ctrl_n_shortcuts = true`
  - `dialect = "uk"`
  - `filter_mode = "host"`
  - `search_mode = "skim"`
  - `filter_mode_shell_up_key_binding = "session"`
  - `style = "compact"`
  - `inline_height = 7`
  - `show_help = false`
  - `enter_accept = true`
  - `history_filter = ["shit"]`
  - `keymap_mode = "vim-normal"`
  - `sync.records = true`
- [ ] Generar `fish/conf.d/atuin.fish` con `atuin init fish --disable-up-arrow`

---

#### Archivo 8: `modules/hm/programs/terminal/software/autojump.nix` (CREAR o ACTUALIZAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/software/autojump.nix`  
**Ubicación Dotfiles**: Verificar si existe

**Cambios necesarios**:
- [ ] Instalar `autojump`
- [ ] Crear `fish/conf.d/autojump.fish` desde paquete

---

#### Archivo 9: `modules/hm/programs/terminal/software/command-not-found.nix` (CREAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/software/command-not-found.nix`  
**Ubicación Dotfiles**: NO EXISTE

**Cambios necesarios**:
- [ ] **CREAR** archivo
- [ ] Crear función `__fish_command_not_found_handler` que llama a `command-not-found`

---

#### Archivo 10: `modules/hm/programs/terminal/software/skim.nix` (CREAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/software/skim.nix`  
**Ubicación Dotfiles**: NO EXISTE

**Cambios necesarios**:
- [ ] **CREAR** archivo
- [ ] Instalar `skim`, `ripgrep`, `eza`
- [ ] Crear wrapper `sk-default` con flag `--cmd 'rg --files --hidden'`
- [ ] Crear script `sk-cd` con preview usando eza
- [ ] Crear `skim/skimrc` con configuración:
  - `preview-window: "right:60%"`
  - `multi: true`
  - `tiebreak: "index,begin,end,length"`
- [ ] Crear `fish/conf.d/skim.fish` con completions

**Nota**: kaku usa `sk` (skim) en lugar de `fzf` en funciones como `fcd`, `installed`, etc.

---

#### Archivo 11: `modules/hm/programs/terminal/software/nix-your-shell.nix` (CREAR)

**Ubicación kaku**: `/home/ludus/Work/kaku/home/terminal/software/nix-your-shell.nix`  
**Ubicación Dotfiles**: NO EXISTE

**Cambios necesarios**:
- [ ] **CREAR** archivo
- [ ] Instalar `nix-your-shell`
- [ ] Generar `fish/conf.d/nix-your-shell.fish` con `nix-your-shell fish`

---

## Resumen de Cambios por Prioridad

### Alta Prioridad (Funcionalidad Core)

1. ✅ **fish.nix** - Ya tiene la mayoría, falta:
   - Desvincular alt-s, alt-v, alt-z
   - Ajustar `fifc_keybinding` (decidir `\cv` vs `\cx`)
   - Agregar `sudope_sequence`
   - Agregar alias `koji` y `zed`

2. ⚠️ **skim.nix** - CREAR (kaku usa `sk` en lugar de `fzf`)
   - Esto afecta funciones: `fcd`, `installed`, `installedall`
   - **DECISIÓN**: ¿Migrar a skim o mantener fzf?

3. ⚠️ **carapace.nix** - CREAR (separar de fish.nix)
   - Actualmente está integrado en fish.nix
   - kaku lo tiene separado

### Media Prioridad (Integraciones)

4. ⚠️ **atuin.nix** - CREAR o ACTUALIZAR
   - Configuración completa de atuin

5. ⚠️ **starship.nix** - ACTUALIZAR
   - Formato del prompt diferente
   - Módulos adicionales

6. ⚠️ **fzf.nix** - CREAR o ACTUALIZAR
   - Solo si no migramos a skim

7. ⚠️ **zoxide.nix** - CREAR o ACTUALIZAR
   - Integración básica

8. ⚠️ **autojump.nix** - CREAR o ACTUALIZAR
   - Integración básica

### Baja Prioridad (Utilidades)

9. ⚠️ **command-not-found.nix** - CREAR
   - Handler simple

10. ⚠️ **nix-your-shell.nix** - CREAR
    - Integración opcional

11. ⚠️ **system/programs/fish.nix** - ACTUALIZAR
    - Configuración a nivel de sistema

---

## Decisiones Pendientes

1. **Editor**: ¿Mantener `nvim` o cambiar a `hx` (helix)?
   - **Recomendación**: Mantener `nvim` (ya configurado)

2. **Fuzzy Finder**: ¿Usar `skim` (sk) o mantener `fzf`?
   - kaku usa `sk` en todas las funciones
   - **Recomendación**: Migrar a `skim` para consistencia

3. **Keybinding fifc**: ¿`\cv` (kaku) o `\cx` (nuestra)?
   - **Recomendación**: Cambiar a `\cv` para consistencia

4. **Formato Starship**: ¿Formato de kaku (2 líneas) o mantener nuestro (3 líneas)?
   - **Recomendación**: Ofrecer ambos, usar kaku por defecto

5. **Secrets/agenix**: ¿Agregar soporte para cargar tokens desde `/run/agenix/`?
   - **Recomendación**: Agregar como opcional

6. **Carapace**: ¿Separar en archivo propio o mantener integrado?
   - **Recomendación**: Separar para mejor organización

---

## Orden de Ejecución Recomendado

1. **Paso 1**: Actualizar `fish.nix` con cambios menores (keybindings, aliases)
2. **Paso 2**: Crear `skim.nix` y actualizar funciones para usar `sk`
3. **Paso 3**: Separar `carapace.nix` de `fish.nix`
4. **Paso 4**: Actualizar `starship.nix` con formato de kaku
5. **Paso 5**: Crear `atuin.nix` con configuración completa
6. **Paso 6**: Crear integraciones restantes (fzf, zoxide, autojump, etc.)
7. **Paso 7**: Crear utilidades (command-not-found, nix-your-shell)
8. **Paso 8**: Actualizar configuración de sistema

---

## Notas Importantes

- kaku usa `sk` (skim) como fuzzy finder principal, no `fzf`
- kaku tiene integración con Zellij (desvincula alt-s, alt-v, alt-z)
- kaku usa `hx` (helix) como editor, nosotros usamos `nvim`
- kaku carga secrets desde agenix en `config.fish`
- kaku tiene wrapper `hx` para helix (no aplicable si usamos nvim)

---

## Checklist de Verificación

Después de cada cambio, verificar:
- [ ] El archivo compila sin errores
- [ ] Las funciones funcionan correctamente
- [ ] Los keybindings funcionan
- [ ] Los plugins se cargan
- [ ] Las integraciones funcionan
- [ ] No hay conflictos con configuración existente

---

**Estado**: Plan creado, listo para ejecución paso a paso

