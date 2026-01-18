# Comparación: Tu Configuración vs Omarchy Keybindings

**Fecha:** 2025-01-17  
**Repositorio Omarchy:** https://github.com/basecamp/omarchy/tree/master/default/hypr/bindings

---

## 📊 Resumen Ejecutivo

Este documento compara los keybindings de tu configuración actual con los de Omarchy, identificando:
- ✅ Funcionalidades que ambos tienen
- ➕ Funcionalidades que tienes y Omarchy no
- ➖ Funcionalidades que Omarchy tiene y tú no
- 💡 Sugerencias de adaptación priorizadas

---

## ✅ Lo que Ambos Tienen (Funcionalidad Similar)

| Funcionalidad | Tu Config | Omarchy | Estado |
|--------------|-----------|---------|--------|
| Cerrar ventana | `SUPER + Q` | `SUPER + W` | ⚠️ Diferente tecla |
| Toggle float | `SUPER + Shift + Space` | `SUPER + T` | ⚠️ Diferente tecla |
| Fullscreen | `SUPER + F` | `SUPER + F` | ✅ Igual |
| Toggle group | `SUPER + G` | `SUPER + G` | ✅ Igual |
| Launcher | `SUPER + Space` | `SUPER + Space` | ✅ Igual |
| Workspaces 1-10 | `SUPER + 1-0` | `SUPER + 1-0` | ✅ Igual |
| Mover ventana a workspace | `SUPER + Shift + 1-0` | `SUPER + Shift + 1-0` | ✅ Igual |
| Scratchpad | `SUPER + =` | `SUPER + S` | ⚠️ Diferente tecla |
| Toggle split | `SUPER + S` | `SUPER + J` | ⚠️ Diferente tecla |
| Mouse move/resize | `SUPER + Mouse` | `SUPER + Mouse` | ✅ Igual |
| Media controls | Teclas multimedia | Teclas multimedia | ✅ Similar |
| Screenshot | `SUPER + Shift + S` | `PRINT` | ⚠️ Diferente tecla |

---

## ➕ Lo que Tienes y Omarchy NO Tiene

### 🎯 Navegación Estilo Vim (HJKL) - **TU FORTALEZA**

Tu configuración tiene una excelente navegación estilo Vim que Omarchy no tiene:

#### Navegación de Foco
- `SUPER + H` - Foco a la izquierda
- `SUPER + J` - Foco abajo
- `SUPER + K` - Foco arriba
- `SUPER + L` - Foco a la derecha

#### Movimiento de Ventanas
- `SUPER + Shift + H` - Mover ventana a la izquierda
- `SUPER + Shift + J` - Mover ventana abajo
- `SUPER + Shift + K` - Mover ventana arriba
- `SUPER + Shift + L` - Mover ventana a la derecha

#### Redimensionar Ventanas
- `SUPER + Ctrl + H` - Disminuir ancho
- `SUPER + Ctrl + J` - Disminuir alto
- `SUPER + Ctrl + K` - Aumentar alto
- `SUPER + Ctrl + L` - Aumentar ancho

### 📍 Navegación Relativa de Workspaces

- `SUPER + Grave` - Cambiar a último workspace activo
- `SUPER + Alt + H` - Workspace anterior (relativo)
- `SUPER + Alt + L` - Workspace siguiente (relativo)
- `SUPER + Shift + N` - Mover ventana a workspace siguiente (relativo)
- `SUPER + Shift + B` - Mover ventana a workspace anterior (relativo)
- `SUPER + N` - Navegar al workspace vacío más cercano

### 🛠️ Funcionalidades Específicas de Tu Config

#### Gestión de Ventanas
- `SUPER + Shift + P` - Pin window
- `SUPER + X` - Lock screen
- `SUPER + Z` - Hold to move window
- `SUPER + Shift + Z` - Hold to resize window

#### Rofi Menus
- `SUPER + /` - Keybindings hint
- `SUPER + ;` - Emoji picker ✅ (documentado en hotkeys.mdx línea 103)
- `SUPER + '` - Glyph picker
- `SUPER + P` - Clipboard
- `SUPER + Shift + P` - Clipboard manager
- `SUPER + Shift + E` - File finder
- `SUPER + Tab` - Window switcher

#### Screen Recording
- `SUPER + Shift + R` - Toggle region recording (mp4)
- `SUPER + Shift + G` - Toggle region recording (gif)

#### Utilidades
- `SUPER + Shift + S` - Script launcher
- `SUPER + D` - Dictionary (open or focus)
- `SUPER + Backslash` - Toggle keyboard layout
- `SUPER + F11` - Game mode
- `SUPER + Alt + G` - Game launcher
- `Alt_R + Control_R` - Toggle waybar and reload config

#### Theming y Wallpaper
- `SUPER + .` - Next global wallpaper
- `SUPER + ,` - Previous global wallpaper
- `SUPER + W` - Select a global wallpaper
- `SUPER + Ctrl + .` - Next waybar layout
- `SUPER + Ctrl + ,` - Previous waybar layout
- `SUPER + R` - Wallbash mode selector
- `SUPER + T` - Select a theme

#### Input Method
- `Control + Space` - Toggle input method (fcitx5)
- `SUPER + Shift + I` - fcitx5 config tool

---

## ➖ Lo que Omarchy Tiene y Tú NO Tienes

### 🪟 Gestión Avanzada de Ventanas

#### Cerrar y Control
- `SUPER + W` - Cerrar ventana (vs tu `SUPER + Q`)
- `SUPER + T` - Toggle float (vs tu `SUPER + Shift + Space`)
- `SUPER + J` - Toggle split (vs tu `SUPER + S`)
- `SUPER + P` - Pseudo window (dwindle)
- `SUPER + O` - Pop window out (float & pin)
- `SUPER + Ctrl + F` - Tiled fullscreen
- `SUPER + Alt + F` - Full width
- `SUPER + Shift + Alt + F11` - Force fullscreen
- `ALT + F11` - Full width

#### Swap Windows ⭐ **MUY ÚTIL**
- `SUPER + Shift + LEFT` - Swap window to the left
- `SUPER + Shift + RIGHT` - Swap window to the right
- `SUPER + Shift + UP` - Swap window up
- `SUPER + Shift + DOWN` - Swap window down

> **Nota:** Actualmente usas estas teclas para mover ventanas. Swap es diferente: intercambia la posición de dos ventanas.

#### Cycle Windows ⭐ **ESTÁNDAR**
- `ALT + Tab` - Cycle to next window
- `ALT + Shift + Tab` - Cycle to prev window
- `ALT + Tab` - Reveal active window on top

### 📦 Workspaces Avanzados

#### Navegación con Tab
- `SUPER + Tab` - Next workspace (tú usas para window switcher)
- `SUPER + Shift + Tab` - Previous workspace
- `SUPER + Ctrl + Tab` - Former workspace

#### Mover Workspace a Otro Monitor
- `SUPER + Shift + Alt + LEFT` - Move workspace to left monitor
- `SUPER + Shift + Alt + RIGHT` - Move workspace to right monitor
- `SUPER + Shift + Alt + UP` - Move workspace to up monitor
- `SUPER + Shift + Alt + DOWN` - Move workspace to down monitor

#### Scratchpad
- `SUPER + S` - Toggle scratchpad (vs tu `SUPER + =`)
- `SUPER + Alt + S` - Move window to scratchpad

### 🔗 Grupos Avanzados

#### Gestión de Grupos
- `SUPER + Alt + G` - Move active window out of group
- `SUPER + Alt + LEFT` - Move window to group on left
- `SUPER + Alt + RIGHT` - Move window to group on right
- `SUPER + Alt + UP` - Move window to group on top
- `SUPER + Alt + DOWN` - Move window to group on bottom

#### Navegación en Grupos
- `SUPER + Alt + Tab` - Next window in group
- `SUPER + Alt + Shift + Tab` - Previous window in group
- `SUPER + Ctrl + LEFT` - Move grouped window focus left
- `SUPER + Ctrl + RIGHT` - Move grouped window focus right
- `SUPER + Alt + 1-5` - Activate window in group by number
- `SUPER + Alt + Mouse scroll` - Scroll through grouped windows

### 📏 Resize con Teclas -/= ⭐ **MÁS INTUITIVO**

- `SUPER + -` - Expand window left
- `SUPER + =` - Shrink window left
- `SUPER + Shift + -` - Shrink window up
- `SUPER + Shift + =` - Expand window down

> **Nota:** Más intuitivo que `SUPER + Ctrl + HJKL`. No interfiere con tus bindings actuales.

### 🛠️ Utilities de Omarchy

#### Menús
- `SUPER + Escape` - System menu ⭐
- `SUPER + K` - Show key bindings
- `SUPER + Alt + Space` - Omarchy menu
- `SUPER + Ctrl + E` - Emoji picker

#### Controles del Sistema
- `SUPER + Ctrl + T` - Activity monitor (btop) ⭐
- `SUPER + Ctrl + A` - Audio controls
- `SUPER + Ctrl + B` - Bluetooth controls
- `SUPER + Ctrl + W` - WiFi controls
- `SUPER + Ctrl + L` - Lock system
- `SUPER + Ctrl + S` - Share menu
- `SUPER + Ctrl + X` - Dictation (start/stop)

#### Aesthetics
- `SUPER + Shift + Space` - Toggle top bar
- `SUPER + Ctrl + Space` - Next background in theme
- `SUPER + Shift + Ctrl + Space` - Theme menu
- `SUPER + Backspace` - Toggle window transparency
- `SUPER + Shift + Backspace` - Toggle workspace gaps

#### Notifications
- `SUPER + ,` - Dismiss last notification
- `SUPER + Shift + ,` - Dismiss all notifications
- `SUPER + Ctrl + ,` - Toggle silencing notifications
- `SUPER + Alt + ,` - Invoke last notification
- `SUPER + Shift + Alt + ,` - Restore last notification

#### System Controls
- `SUPER + Ctrl + I` - Toggle locking on idle
- `SUPER + Ctrl + N` - Toggle nightlight
- `SUPER + Ctrl + Alt + T` - Show time
- `SUPER + Ctrl + Alt + B` - Show battery remaining

#### Screenshots
- `PRINT` - Screenshot with editing
- `SHIFT + PRINT` - Screenshot to clipboard
- `ALT + PRINT` - Screenrecording menu
- `SUPER + PRINT` - Color picker

### 📋 Clipboard Universal ⭐ **MUY ÚTIL**

- `SUPER + C` - Universal copy
- `SUPER + V` - Universal paste
- `SUPER + X` - Universal cut
- `SUPER + Ctrl + V` - Clipboard manager

> **Nota:** Funciona en todas las aplicaciones, incluso las que no soportan Ctrl+C/V nativamente.  
> **Conflicto:** Tu `SUPER + V` está ocupado con editor, `SUPER + C` está libre.

### 🔊 Media con OSD

Omarchy usa `swayosd-client` para mostrar OSD (On-Screen Display) en el monitor enfocado:

- Ajustes precisos con `ALT + teclas multimedia` (1% increments)
- `SUPER + XF86AudioMute` - Switch audio output

---

## 💡 Sugerencias de Adaptación Priorizadas

### 🔴 Alta Prioridad (Muy Útiles)

#### 1. Swap Windows ⭐⭐⭐
**Teclas:** `SUPER + Shift + Arrow`  
**Por qué:** Intercambiar posición de ventanas es muy útil para reorganizar rápidamente.  
**Conflicto:** Actualmente usas estas teclas para mover ventanas.  
**Solución:** Considera usar `SUPER + Ctrl + Arrow` para mover ventanas, o mantener ambas funcionalidades.

#### 2. Cycle Windows ⭐⭐⭐
**Teclas:** `ALT + Tab` / `ALT + Shift + Tab`  
**Por qué:** Estándar en muchos sistemas, muy intuitivo.  
**Conflicto:** Tu `SUPER + Tab` está ocupado con window switcher.  
**Solución:** `ALT + Tab` está libre, no hay conflicto.

#### 3. Resize con -/= ⭐⭐⭐
**Teclas:** `SUPER + -` / `SUPER + =` / `SUPER + Shift + -` / `SUPER + Shift + =`  
**Por qué:** Más intuitivo que `SUPER + Ctrl + HJKL`.  
**Conflicto:** Tu `SUPER + =` está ocupado con scratchpad.  
**Solución:** Considera cambiar scratchpad a otra tecla (ej: `SUPER + S` como Omarchy).

#### 4. Workspace Navigation con Tab ⭐⭐
**Teclas:** `SUPER + Tab` (next) / `SUPER + Shift + Tab` (prev) / `SUPER + Ctrl + Tab` (former)  
**Por qué:** Navegación rápida entre workspaces.  
**Conflicto:** Tu `SUPER + Tab` está ocupado con window switcher.  
**Solución:** Mover window switcher a otra tecla (ej: `SUPER + Grave` o `SUPER + Alt + Tab`).

#### 5. Clipboard Universal ⭐⭐
**Teclas:** `SUPER + C` (copy) / `SUPER + V` (paste) / `SUPER + X` (cut)  
**Por qué:** Funciona en todas las aplicaciones, incluso las que no soportan Ctrl+C/V.  
**Conflicto:** Tu `SUPER + V` está ocupado con editor.  
**Solución:** Considera usar `SUPER + Ctrl + V` para editor, o mantener ambos.

#### 6. System Menu ⭐⭐
**Teclas:** `SUPER + Escape`  
**Por qué:** Acceso rápido a logout/shutdown.  
**Conflicto:** Ninguno, `SUPER + Escape` está libre.

#### 7. Activity Monitor Alternativo ⭐
**Teclas:** `SUPER + Ctrl + T`  
**Por qué:** Más corto que `Ctrl + Shift + Escape`.  
**Conflicto:** Ninguno.  
**Solución:** Agregar además del actual, no reemplazar.

### 🟡 Media Prioridad (Útiles pero Opcionales)

#### 8. Grupos Avanzados
**Teclas:** `SUPER + Alt + Arrow` (mover a grupos), `SUPER + Alt + Tab` (navegar grupos)  
**Por qué:** Útil si usas grupos frecuentemente.  
**Conflicto:** Tu `SUPER + Alt + H/L` está ocupado con workspaces relativos.  
**Solución:** Considera usar `SUPER + Alt + Ctrl + Arrow` para grupos.

#### 9. Mover Workspace a Otro Monitor
**Teclas:** `SUPER + Shift + Alt + Arrow`  
**Por qué:** Útil con múltiples monitores.  
**Conflicto:** Ninguno aparente.

#### 10. Full Width / Tiled Fullscreen
**Teclas:** `SUPER + Alt + F` (full width), `SUPER + Ctrl + F` (tiled fullscreen)  
**Por qué:** Variaciones útiles de fullscreen.  
**Conflicto:** Tu `SUPER + F` está ocupado con fullscreen normal.

### 🟢 Baja Prioridad (Específicos de Omarchy)

#### 11. Utilities de Omarchy
Muchos dependen de scripts específicos de Omarchy (`omarchy-*`). Solo adaptar si:
- Necesitas la funcionalidad específica
- Estás dispuesto a crear scripts equivalentes
- Ejemplos: Audio controls, Bluetooth controls, WiFi controls, Share menu, Dictation

---

## 🎯 Recomendaciones Finales

### ✅ Mantener (Tu Fortaleza)
1. **Navegación Vim (HJKL)** - Es más eficiente que flechas
2. **Navegación relativa de workspaces** - Muy útil
3. **Tus utilidades específicas** - Theming, wallpaper, scripts personalizados

### ➕ Agregar (Alta Prioridad)
1. **Swap windows** - `SUPER + Shift + Arrow` (o usar `SUPER + Ctrl + Arrow` para mover)
2. **Cycle windows** - `ALT + Tab` / `ALT + Shift + Tab`
3. **Resize con -/=** - Considerar cambiar scratchpad a `SUPER + S`
4. **System menu** - `SUPER + Escape`
5. **Activity monitor alternativo** - `SUPER + Ctrl + T`

### 🤔 Considerar (Media Prioridad)
1. **Clipboard universal** - Si no usas `SUPER + C/V` para apps
2. **Workspace navigation con Tab** - Si estás dispuesto a mover window switcher
3. **Grupos avanzados** - Si usas grupos frecuentemente

### ❌ No Agregar (Baja Prioridad)
1. **Utilities específicos de Omarchy** - Requieren scripts personalizados
2. **Funcionalidades que ya tienes mejoradas** - Tu navegación Vim es superior

---

## 📝 Notas Adicionales

### Conflictos de Teclas a Resolver

1. **`SUPER + Shift + Arrow`**
   - Tu uso: Mover ventanas
   - Omarchy: Swap windows
   - **Solución sugerida:** Usar `SUPER + Ctrl + Arrow` para mover ventanas

2. **`SUPER + Tab`**
   - Tu uso: Window switcher
   - Omarchy: Next workspace
   - **Solución sugerida:** Mover window switcher a `SUPER + Grave` o `SUPER + Alt + Tab`

3. **`SUPER + =`**
   - Tu uso: Toggle scratchpad
   - Omarchy: Shrink window left (resize)
   - **Solución sugerida:** Cambiar scratchpad a `SUPER + S` (como Omarchy)

4. **`SUPER + V`**
   - Tu uso: Editor
   - Omarchy: Universal paste
   - **Solución sugerida:** Usar `SUPER + Ctrl + V` para editor, o mantener ambos

5. **`SUPER + S`**
   - Tu uso: Toggle split
   - Omarchy: Toggle scratchpad
   - **Solución sugerida:** Cambiar split a `SUPER + J` (como Omarchy), usar `SUPER + S` para scratchpad

### Documentación

- ✅ `SUPER + ;` (Emoji picker) está documentado en `hotkeys.mdx` línea 103
- 📝 Considera actualizar `hotkeys.mdx` con los nuevos keybindings que agregues

---

## 🔗 Referencias

- **Repositorio Omarchy:** https://github.com/basecamp/omarchy
- **Bindings Omarchy:** https://github.com/basecamp/omarchy/tree/master/default/hypr/bindings
- **Tu configuración:** `resources/config/keybinds.conf`
- **Documentación:** `docs/src/content/docs/hotkeys.mdx`

---

**Última actualización:** 2025-01-17
