---
description: Sync Neovim keymaps from khanelivim config to Dotfiles documentation
---

# Sync Neovim Keymaps Documentation

Este workflow sincroniza TODOS los keybindings desde la configuración `khanelivim` hacia la documentación en Dotfiles.

## 🎯 OBJETIVO
Mantener `/home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx` 100% actualizado con TODOS los keybindings definidos en `/home/ludus/Work/khanelivim/modules/nixvim`.

## 📁 Rutas Clave

### Fuente (khanelivim)
```
/home/ludus/Work/khanelivim/modules/nixvim/
```

### Destino (Documentación)
```
/home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx
```

## 🔍 PASO 1: Búsqueda EXHAUSTIVA de Keymaps

### 1.1 Buscar TODOS los archivos con keymaps

Ejecutar estos comandos para encontrar TODAS las definiciones:

```bash
# Cambiar al directorio base
cd /home/ludus/Work/khanelivim/modules/nixvim

# Buscar keymaps estándar
find . -name "*.nix" -type f -exec grep -l "keymaps\s*=" {} \;

# Buscar lazy-loaded keymaps
find . -name "*.nix" -type f -exec grep -l "lazyLoad\.settings\.keys" {} \;

# Buscar lz-n plugins
find . -name "*.nix" -type f -exec grep -l "plugins\.lz-n\.plugins" {} \;

# Buscar keymaps específicos de plugins
find . -name "*.nix" -type f -exec grep -l "\.keymaps\s*=" {} \;

# Listar TODOS los archivos encontrados
find . -name "*.nix" -type f | sort
```

### 1.2 Archivo checklist COMPLETO

**IMPORTANTE:** Verificar CADA uno de estos archivos:

#### Archivos Core (OBLIGATORIOS)
- [ ] `keymappings.nix` - Keymaps generales
- [ ] `lsp.nix` - LSP keymaps

#### Plugins Directory (VERIFICAR TODOS)
```
plugins/
├── [ ] conform/default.nix
├── [ ] dap/default.nix
├── [ ] dap-ui/default.nix
├── [ ] diffview/default.nix
├── [ ] flash/default.nix
├── [ ] gitsigns/default.nix
├── [ ] glance/default.nix
├── [ ] grug-far/default.nix
├── [ ] harpoon/default.nix
├── [ ] inc-rename/default.nix
├── [ ] neo-tree/default.nix
├── [ ] neotest/default.nix
├── [ ] todo-comments/default.nix
├── [ ] trouble/default.nix
├── [ ] undotree/default.nix
└── snacks/
    ├── [ ] bufdelete.nix
    ├── [ ] gitbrowse.nix
    ├── [ ] lazygit.nix
    ├── [ ] notifier.nix
    ├── [ ] scratch.nix
    ├── [ ] terminal.nix
    ├── [ ] toggle.nix
    ├── [ ] words.nix
    ├── [ ] zen.nix
    └── picker/
        ├── [ ] git.nix
        ├── [ ] lsp.nix
        ├── [ ] neovim.nix
        ├── [ ] search.nix
        └── [ ] ui.nix
```

#### Archivos Adicionales
- [ ] Cualquier otro `.nix` encontrado en el paso 1.1

## 📋 PASO 2: Extracción de Keymaps

### 2.1 Patrones de Definición a Buscar

Para CADA archivo verificado, buscar estos patrones:

#### Patrón 1: Keymaps Estándar
```nix
keymaps = [
  {
    mode = "n";  # o ["n" "v"], etc.
    key = "<leader>ff";
    action = "<cmd>Telescope find_files<CR>";
    options = { 
      desc = "Find files";
      silent = true;
    };
  }
];
```

#### Patrón 2: Lazy-Loaded Keys
```nix
lazyLoad.settings.keys = [
  {
    __unkeyed-1 = "<leader>db";
    __unkeyed-2 = "<cmd>DapToggleBreakpoint<CR>";
    desc = "Toggle breakpoint";
    mode = "n";  # puede estar ausente, asumir "n"
  }
];
```

#### Patrón 3: lz-n Plugins
```nix
plugins.lz-n.plugins = [
  {
    name = "plugin-name";
    keys = [
      {
        __unkeyed-1 = "<leader>key";
        __unkeyed-2 = "action";
        desc = "Description";
      }
    ];
  }
];
```

#### Patrón 4: Plugin-Specific Keymaps
```nix
plugins.todo-comments.keymaps = {
  todoTelescope = {
    key = "<leader>ft";
    keywords = "TODO,FIX";
  };
};

# O también:
plugins.gitsigns.settings.on_attach = ''
  function(bufnr)
    -- keymaps aquí
  end
'';
```

### 2.2 Datos a Extraer

Para CADA keymap encontrado, extraer:

1. **key** - El keybinding (ej: `<leader>ff`, `gd`, `]c`)
2. **desc** - La descripción (en `options.desc` o `desc`)
3. **mode** - El modo(s):
   - Si no está presente, asumir `"n"` (Normal)
   - Puede ser string: `"n"`, `"v"`, `"i"`, etc.
   - Puede ser array: `["n" "v"]`, `["n" "x" "o"]`
4. **action** - La acción (para entender el contexto)
5. **archivo** - De qué archivo proviene (para debugging)

### 2.3 Comando para Extraer TODO

```bash
# Extraer TODAS las definiciones de keymaps en un solo archivo
cd /home/ludus/Work/khanelivim/modules/nixvim

# Crear archivo temporal con TODOS los keymaps
{
  echo "=== KEYMAPS EXTRACTION ==="
  echo ""
  
  # Por cada archivo .nix
  find . -name "*.nix" -type f | while read file; do
    if grep -q -E "(keymaps\s*=|lazyLoad\.settings\.keys|plugins\.lz-n\.plugins|\.keymaps\s*=)" "$file"; then
      echo "FILE: $file"
      echo "---"
      cat "$file"
      echo ""
      echo "=========================================="
      echo ""
    fi
  done
} > /tmp/khanelivim_keymaps_raw.txt

echo "Keymaps extraídos en: /tmp/khanelivim_keymaps_raw.txt"
```

## 🗂️ PASO 3: Organización por Categorías

Agrupar los keymaps en estas categorías **EN ESTE ORDEN**:

### Estructura de Categorías

```markdown
## 1. General
Keymaps básicos: leader key, save, quit, clipboard

## 2. Navigation & Windows
Window focus (Ctrl+hjkl), splits (<leader>w*), resize, quickfix (]q, [q)

## 3. Buffers
Buffer navigation ([b, ]b) y gestión (<leader>b*)

## 4. Search (Snacks Picker)
TODOS los <leader>f* y <leader>s* - File finder, live grep, buffers, etc.

## 5. LSP
TODOS los g* (gd, gD, gr, gy, gl, etc.) y <leader>l*

## 6. Git
### 6.1 Git Operations
<leader>g* principales (gg, go, gm, etc.)

### 6.2 Git Picker
<leader>gf* (gff, gfb, gfc, gfs, etc.)

### 6.3 Gitsigns/Hunks
<leader>gh*, ]c, [c, gb, gS, gR, gU

### 6.4 Diffview
<leader>gdv, gdV, gD

## 7. Trouble (Diagnostics)
<leader>x* (xx, xX, xl, xL, xQ) y <leader>us

## 8. Debug (DAP)
<leader>d* (db, dc, di, do, dO, dR, dt, dw, etc.)

## 9. Testing (Neotest)
<leader>t* (tt, tr, tR, td, tD, ts, tS, to, tO, etc.)

## 10. Harpoon
<leader>H* (Ha, He, Hj, Hk, Hl, Hm)

## 11. Search & Replace (Grug-Far)
<leader>r* (rg, rw, rW)

## 12. Flash (Motion)
Motion keymaps: s, S, r, R, gl

## 13. Reference Navigation
]], [[

## 14. File Explorer
<leader>E, <leader>fe

## 15. Editing
Move lines (Alt+j/k), indent (< >), comment (gc)

## 16. Scratch Buffers
<leader>nn, <leader>ns

## 17. UI Toggles
<leader>u* (ud*, ue*, ua*, us*, ut*)

## 18. Profiler
<leader>X, <leader>up*

## 19. Terminal
<C-/>, <leader>ut

## 20. Other
Cualquier keymap que no encaje en las categorías anteriores
```

## 📝 PASO 4: Formateo Markdown

### 4.1 Template por Sección

```markdown
## [Número]. [Nombre de Sección]

| Key | Description | Mode |
| --- | --- | --- |
| `<key>` | [Descripción] | [Modo] |
```

### 4.2 Mapeo de Modos

| Nix Mode | Markdown Display |
|----------|------------------|
| `"n"` | Normal |
| `"v"` | Visual |
| `"i"` | Insert |
| `"o"` | Operator |
| `"x"` | Visual Block |
| `"t"` | Terminal |
| `["n" "v"]` | Normal/Visual |
| `["n" "x" "o"]` | Normal/Visual/Op |
| `["n" "v" "o"]` | Normal/Visual/Op |

### 4.3 Formato de Keys

- Usar backticks para todas las keys: `` `<leader>ff` ``
- Mantener el formato exacto: `<leader>`, `<C-h>`, `<M-j>`, etc.
- Si la key tiene espacios, mantenerlos: `` `<leader> ` ``

### 4.4 Frontmatter Requerido

```yaml
---
title: Neovim
description: Keymaps and configuration for Neovim.
---
```

## ✅ PASO 5: Verificación de Completitud

### 5.1 Conteo de Keymaps

```bash
# En khanelivim - Contar definiciones
cd /home/ludus/Work/khanelivim/modules/nixvim
echo "Keymaps estándar:"
grep -r "key = " --include="*.nix" . | wc -l

echo "Lazy-loaded keys:"
grep -r "__unkeyed-1 = " --include="*.nix" . | wc -l

echo "TOTAL APROXIMADO:"
# Sumar los dos números anteriores

# En documentación - Contar filas de tabla
echo "En documentación:"
grep -c "^| \`" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx
```

### 5.2 Checklist de Keymaps Críticos

Verificar que estos keymaps SIEMPRE estén en la documentación:

#### General
- [ ] `<leader>` → Show which-key
- [ ] `<leader>w` → Save file

#### Search (Picker)
- [ ] `<leader>ff` → Find files
- [ ] `<leader>fw` → Live grep
- [ ] `<leader>fb` → Buffers
- [ ] `<leader><space>` → Recent files

#### LSP
- [ ] `gd` → Go to definition
- [ ] `gr` → References
- [ ] `K` → Hover documentation
- [ ] `<leader>la` → Code actions

#### Git
- [ ] `<leader>gg` → Lazygit
- [ ] `]c` → Next hunk
- [ ] `[c` → Previous hunk
- [ ] `<leader>ghs` → Stage hunk

#### Debug
- [ ] `<leader>db` → Toggle breakpoint
- [ ] `<leader>dc` → Continue
- [ ] `<leader>di` → Step into

#### Testing
- [ ] `<leader>tt` → Run nearest test
- [ ] `<leader>tr` → Run file tests

#### UI Toggles
- [ ] `<leader>udd` → Toggle diagnostics
- [ ] `<leader>ues` → Toggle spell check
- [ ] `<leader>uZ` → Zen mode

### 5.3 Verificación de Duplicados

```bash
# Buscar keys duplicadas en la documentación
grep "^| \`" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
  cut -d'|' -f2 | \
  sort | \
  uniq -d
```

Si hay duplicados, decidir cuál mantener basándose en:
1. La definición más específica
2. La que está en el archivo de plugin (no en keymappings.nix)
3. La que tiene mejor descripción

## 🔄 PASO 6: Proceso de Actualización

### 6.1 Workflow Completo

```bash
# 1. Ir al directorio de trabajo
cd /home/ludus/Work/khanelivim/modules/nixvim

# 2. Extraer TODOS los keymaps
# (usar el comando del paso 2.3)

# 3. Procesar el archivo raw y crear documentación
# (hacer esto manualmente o con script)

# 4. Actualizar el archivo de documentación
# Editar: /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx

# 5. Verificar conteo
# (usar comandos del paso 5.1)

# 6. Verificar keymaps críticos
# (usar checklist del paso 5.2)

# 7. Commit cambios
cd /home/ludus/Dotfiles
git diff docs/src/content/docs/neovim.mdx
git add docs/src/content/docs/neovim.mdx
git commit -m "docs: sync neovim keymaps from khanelivim"
```

## 🚨 CASOS ESPECIALES

### Keymaps Condicionales

Muchos keymaps están condicionados con:
```nix
mkIf config.plugins.*.enable { ... }
```

**Decisión:** Documentar TODOS los keymaps que estén habilitados en la configuración default de khanelivim.

### Keymaps en Lua Strings

Algunos plugins definen keymaps en strings Lua:
```nix
extraConfigLua = ''
  vim.keymap.set("n", "<leader>key", function() ... end)
'';
```

**Acción:** Buscar también `vim.keymap.set` en todos los archivos.

### Which-key Specs

Los `which-key.settings.spec` definen GRUPOS, no keymaps:
```nix
{ "<leader>g", group = "Git"; }
```

**Acción:** NO documentar estos, solo usar para contexto.

### Keymaps Sobrescritos

Si un keymap está definido múltiples veces:
- En `keymappings.nix` y en un plugin
- Documentar el del plugin (más específico)
- Agregar nota si es necesario

## 🎯 CRITERIOS DE ÉXITO

La documentación está completa cuando:

1. ✅ TODOS los archivos de la checklist están revisados
2. ✅ El conteo de keymaps es >= 90% del total en source
3. ✅ Todos los keymaps críticos están presentes
4. ✅ No hay duplicados sin resolver
5. ✅ Cada sección tiene al menos 1 keymap (o está marcada como vacía)
6. ✅ El formato markdown es consistente
7. ✅ Los keymaps de la captura de pantalla están incluidos

## 📌 NOTAS IMPORTANTES

1. **Siempre buscar en TODO el árbol de archivos**, no solo en los conocidos
2. **No asumir que un archivo no tiene keymaps** - verificar cada uno
3. **Documentar el comportamiento default**, no todas las variantes condicionales
4. **Mantener el orden de categorías** - facilita la navegación
5. **Usar el formato EXACTO de las keys** - copiar tal cual de los archivos
6. **Actualizar este workflow** cada vez que se descubra un nuevo patrón

## 🔍 DEBUGGING

Si faltan keymaps:

```bash
# 1. Listar TODOS los archivos .nix
find /home/ludus/Work/khanelivim/modules/nixvim -name "*.nix" | sort

# 2. Grep TODOS los posibles patrones de keymaps
cd /home/ludus/Work/khanelivim/modules/nixvim
rg -A 5 -B 2 'keymaps|lazyLoad|lz-n|vim\.keymap' --type nix

# 3. Buscar el keymap específico faltante
# Ejemplo: buscar <leader>db
rg "<leader>db" --type nix

# 4. Ver el archivo completo donde está definido
cat [archivo_encontrado]
```

---

**Última actualización:** Enero 2025
**Versión:** 2.0
**Mantenedor:** @ludus