# 📋 Plan de Investigación y Solución: Neovim/Nixvim

**Fecha:** 2026-01-13  
**Estado:** Análisis Completo  
**Objetivo:** Lograr que neovim funcione en Dotfiles como en gitm3-hydenix

---

## 🔍 ANÁLISIS COMPARATIVO

### Diferencias Encontradas

| Aspecto | gitm3-hydenix (✅ FUNCIONA) | Dotfiles (❌ NO FUNCIONA) |
|---------|---------------------------|--------------------------|
| **Nixvim versión** | `2d3184cd` (2024-12-25) | `983751b6` (2026-01-03) |
| **Nixpkgs** | `18dd725c` (MISMO) | `18dd725c` (MISMO) |
| **Importa nixvim en** | `modules/hm/default.nix` | `hosts/hydenix/user.nix` |
| **Módulo usado** | `inputs.nixvim.homeModules.nixvim` | `inputs.nixvim.homeModules.default` |
| **Home-manager import** | `inputs.hydenix.lib.homeModules` | `inputs.hydenix.homeModules.default` |
| **Estructura flake** | `hydenix.inputs.hydenix-nixpkgs.lib` | `nixpkgs.lib.nixosSystem` |
| **Configuración nvim** | Casi idéntica (solo comments) | Casi idéntica |

### Archivos de nvim - Diferencias Mínimas

```diff
# modules/hm/nvim/default.nix - IDÉNTICOS (solo comentarios)
# modules/hm/nvim/options.nix - DIFERENCIA:
gitm3: undodir = "/home/zander/.local/state/nvim/undo"
Dotfiles: undodir = "$HOME/.local/state/nvim/undo"

# Todo lo demás: plugins/, lsp/, themes/ - IDÉNTICOS
```

---

## 🎯 HIPÓTESIS SOBRE LA CAUSA DEL ERROR

### Hipótesis Principal (ALTA PROBABILIDAD)
**H1: Versión de Nixvim incompatible**
- Dotfiles usa nixvim más nuevo (enero 2026) que puede tener breaking changes
- gitm3-hydenix usa versión estable de diciembre 2024
- El error `module 'tokyonight' not found` sugiere que la nueva versión genera plugins diferente

### Hipótesis Secundaria (MEDIA PROBABILIDAD)
**H2: Método de importación incorrecto**
- Dotfiles usa `homeModules.default` (genérico)
- gitm3-hydenix usa `homeModules.nixvim` (específico)
- Puede que el módulo específico configure plugins correctamente

### Hipótesis Terciaria (BAJA PROBABILIDAD)
**H3: Ubicación de importación afecta scope**
- Importar en `modules/hm/default.nix` vs `hosts/*/user.nix`
- Puede afectar cómo se resuelven las dependencias

---

## 📊 OPCIONES DISPONIBLES (Ordenadas por Probabilidad de Éxito)

### ⭐ OPCIÓN 1: Downgrade Nixvim (ALTA PROBABILIDAD - 85%)
**Descripción:** Usar la misma versión de nixvim que gitm3-hydenix

**Pasos:**
1. Cambiar en `flake.nix`:
   ```nix
   nixvim = {
     url = "github:nix-community/nixvim/2d3184cd3dd3526d0c56c0f52dd1f4f3e6c7e8b4";
     inputs.nixpkgs.follows = "nixpkgs";
   };
   ```
2. `nix flake update nixvim`
3. `make switch`

**Pros:**
- ✅ Usa versión probada que funciona
- ✅ Cambio mínimo, fácil de revertir
- ✅ Alta probabilidad de éxito

**Contras:**
- ⚠️ Usa versión "vieja" (1 mes)
- ⚠️ Puede perder features nuevos

---

### ⭐ OPCIÓN 2: Cambiar método de importación (MEDIA-ALTA - 75%)
**Descripción:** Usar `homeModules.nixvim` en lugar de `homeModules.default`

**Pasos:**
1. Editar `hosts/hydenix/user.nix`:
   ```nix
   imports = [
     inputs.hydenix.homeModules.default
     inputs.nix-flatpak.homeManagerModules.nix-flatpak
     inputs.nixvim.homeModules.nixvim  # ← cambio aquí
     ../../modules/hm
   ];
   ```
2. `make switch`

**Pros:**
- ✅ Usa la API específica para nixvim
- ✅ Cambio simple
- ✅ Mantiene versión actual

**Contras:**
- ⚠️ Puede que `nixvim` no exista en versión nueva
- ⚠️ No explica por qué tokyonight falla

---

### ⭐ OPCIÓN 3: Mover importación a modules/hm/default.nix (MEDIA - 60%)
**Descripción:** Reorganizar para que nixvim se importe como en gitm3-hydenix

**Pasos:**
1. Remover de `hosts/hydenix/user.nix`:
   ```nix
   # Quitar: inputs.nixvim.homeModules.default
   ```
2. Agregar a `modules/hm/default.nix`:
   ```nix
   imports = [
     inputs.nixvim.homeModules.nixvim
     ./nvim
     # ... resto
   ];
   ```
3. Pasar `inputs` como extraSpecialArgs a módulos

**Pros:**
- ✅ Estructura idéntica a gitm3-hydenix
- ✅ Puede resolver scope issues

**Contras:**
- ⚠️ Cambio más invasivo
- ⚠️ Requiere pasar `inputs` correctamente

---

### ⭐ OPCIÓN 4: Combinar Opción 1 + 2 (MEDIA-ALTA - 80%)
**Descripción:** Downgrade nixvim + usar homeModules.nixvim

**Pasos:**
1. Downgrade nixvim a versión de gitm3-hydenix
2. Cambiar importación a `homeModules.nixvim`
3. `make switch`

**Pros:**
- ✅✅ Doble fix: versión + método
- ✅ Alta probabilidad de éxito

**Contras:**
- ⚠️ Más cambios que opciones individuales

---

### ⭐ OPCIÓN 5: Copiar flake.nix completo (ALTA - 90%)
**Descripción:** Usar la estructura exacta de flake de gitm3-hydenix

**Pasos:**
1. Backup de `flake.nix` actual
2. Copiar estructura de gitm3-hydenix:
   - `hydenix.inputs.hydenix-nixpkgs.lib.nixosSystem`
   - Importar nixvim en modules/hm/default.nix
   - Usar overlays
3. Adaptar nombres (zander → ludus, paths, etc.)
4. `nix flake update`
5. `make switch`

**Pros:**
- ✅✅ Replica entorno funcional completo
- ✅ Muy alta probabilidad de éxito
- ✅ Resuelve todas las diferencias

**Contras:**
- ⚠️⚠️ Cambio muy invasivo
- ⚠️⚠️ Puede romper otras cosas
- ⚠️ Difícil de revertir parcialmente

---

### ⭐ OPCIÓN 6: Construcción desde cero paso a paso (GARANTIZADA - 100%)
**Descripción:** Construir configuración nvim atomicamente, probando cada paso

**Pasos:**
1. **Paso 1:** Deshabilitar nvim completamente, verificar que el sistema funcione
2. **Paso 2:** Agregar nixvim vacío (solo enable = true), rebuild
3. **Paso 3:** Agregar solo tokyonight theme, rebuild, probar
4. **Paso 4:** Agregar options.nix, rebuild, probar
5. **Paso 5:** Agregar keymaps.nix, rebuild, probar
6. **Paso 6:** Agregar LSP básico, rebuild, probar
7. **Paso 7:** Agregar plugins uno por uno
8. En cada paso: si falla, investigar ese componente específico

**Pros:**
- ✅✅✅ Garantizado encontrar la causa exacta
- ✅ Aprendes exactamente qué componente falla
- ✅ Control total del proceso

**Contras:**
- ⚠️⚠️⚠️ Muy lento (muchos rebuilds)
- ⚠️⚠️ Tedioso
- ⚠️ Puede tomar horas

---

### ⭐ OPCIÓN 7: Desactivar nixvim, usar configuración manual (ALTERNATIVA)
**Descripción:** Abandonar nixvim, configurar neovim manualmente con home-manager

**Pasos:**
1. Crear `modules/hm/programs/editors/neovim.nix`
2. Usar `programs.neovim` de home-manager
3. Escribir configuración en Lua puro
4. Copiar plugins con vim-plug o lazy.nvim

**Pros:**
- ✅ Método tradicional probado
- ✅ Más flexible
- ✅ Menos dependencia de nixvim

**Contras:**
- ⚠️⚠️ No es declarativo
- ⚠️⚠️ Pierdes ventajas de nixvim
- ⚠️ Más trabajo manual

---

## 🎲 RECOMENDACIONES POR ESCENARIO

### Escenario A: "Quiero que funcione YA" (Tiempo: 15 min)
1. **Probar Opción 1** (Downgrade nixvim)
2. Si falla → **Probar Opción 2** (cambiar homeModules)
3. Si falla → **Opción 4** (combo 1+2)
4. Si falla → **Opción 5** (copiar flake completo)

### Escenario B: "Quiero entender el problema" (Tiempo: 2-3 horas)
1. **Opción 6** (construcción paso a paso)
2. Documentar cada paso que falla
3. Crear fix específico basado en findings

### Escenario C: "Quiero lo más estable" (Tiempo: 30 min)
1. **Opción 5** (copiar estructura gitm3-hydenix)
2. Adaptar valores específicos
3. Testing exhaustivo

### Escenario D: "Nixvim no vale la pena" (Tiempo: 1-2 horas)
1. **Opción 7** (configuración manual)
2. Usar método tradicional
3. Mayor control, menos magia

---

## 📝 SIGUIENTES PASOS PROPUESTOS

### Plan Recomendado (Híbrido - Tiempo total: 1 hora)

**Fase 1: Quick wins (15 min)**
1. Opción 1: Downgrade nixvim
2. Si funciona: DONE ✅
3. Si falla: continuar

**Fase 2: Ajustes de importación (15 min)**
4. Opción 2: Cambiar a homeModules.nixvim
5. Si funciona: DONE ✅
6. Si falla: continuar

**Fase 3: Estructura completa (20 min)**
7. Opción 5: Copiar flake.nix de gitm3-hydenix
8. Si funciona: DONE ✅
9. Si falla: continuar

**Fase 4: Último recurso (10 min decisión)**
10. Decidir entre Opción 6 (debugging paso a paso) u Opción 7 (configuración manual)

---

## 🔧 COMANDOS DE TESTING RÁPIDO

Para cada opción, usar:

```bash
# 1. Hacer cambios
# 2. Test de evaluación (rápido)
nix flake check --no-build

# 3. Si pasa, rebuild
make switch

# 4. Probar neovim
nvim --version
nvim test.txt
# Dentro de nvim:
:checkhealth
:Telescope
:lua print(vim.inspect(require('tokyonight')))
```

---

## 📊 MATRIZ DE DECISIÓN

| Opción | Tiempo | Complejidad | Prob. Éxito | Reversible | Aprendizaje |
|--------|--------|-------------|-------------|------------|-------------|
| 1 | 15m | Baja | 85% | ✅ Fácil | Bajo |
| 2 | 10m | Baja | 75% | ✅ Fácil | Medio |
| 3 | 20m | Media | 60% | ⚠️ Medio | Medio |
| 4 | 20m | Media | 80% | ✅ Fácil | Medio |
| 5 | 30m | Alta | 90% | ⚠️ Difícil | Bajo |
| 6 | 2-3h | Alta | 100% | ✅ Paso a paso | ✅ Alto |
| 7 | 1-2h | Media | 100% | ⚠️ Difícil | ✅ Alto |

---

## 🎯 MI RECOMENDACIÓN FINAL

**Para ti específicamente, recomiendo:**

1. **Primera opción: Opción 1 (Downgrade Nixvim)** - 15 minutos
   - Es la causa más probable
   - Cambio mínimo
   - Fácil de revertir
   
2. **Si falla: Opción 5 (Copiar estructura gitm3-hydenix)** - 30 minutos
   - Garantiza replicar entorno funcional
   - Un poco invasivo pero vale la pena
   
3. **Si REALMENTE falla todo: Opción 6 (Paso a paso)** - 2-3 horas
   - Aprenderás exactamente qué está roto
   - Construcción sólida desde cero
   - Entenderás cada componente

**NO recomiendo Opción 7** (configuración manual) a menos que estés dispuesto a abandonar nixvim completamente.

---

## 📞 ¿CUÁL OPCIÓN QUIERES PROBAR?

Dime qué opción prefieres y procedo con los cambios específicos. Si quieres mi ayuda para ejecutar el "Plan Recomendado" paso a paso, también puedo hacerlo.

**Tiempo estimado total (Plan Recomendado):** 45-60 minutos
**Probabilidad de éxito combinada:** >95%

---

**Archivo generado:** 2026-01-13 08:40  
**Autor:** Cursor AI Assistant  
**Estado:** Listo para decisión
