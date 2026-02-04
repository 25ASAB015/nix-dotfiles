---
description: Sync Neovim keymaps from khanelivim config to Dotfiles documentation
repository: https://github.com/khaneliman/khanelivim.git
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

# IMPORTANTE: Buscar which-key specs para categorías
find . -name "*.nix" -type f -exec grep -l "which-key\.settings\.spec" {} \;

# Listar TODOS los archivos encontrados
find . -name "*.nix" -type f | sort
```

### 1.2 Archivo checklist COMPLETO

**IMPORTANTE:** Verificar CADA uno de estos archivos:

#### Archivos Core (OBLIGATORIOS)
- [ ] `keymappings.nix` - Keymaps generales
- [ ] `lsp.nix` - LSP keymaps
- [ ] **`which-key.nix` o archivos con `which-key.settings.spec`** - Categorías y grupos

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

### 2.0 PRIMERO: Extraer Categorías de Which-Key

**IMPORTANTE:** Antes de extraer keymaps, extraer las categorías de which-key para organizar correctamente la documentación.

```bash
cd /home/ludus/Work/khanelivim/modules/nixvim

# Buscar which-key specs
find . -name "*.nix" -type f -exec grep -l "which-key" {} \;

# Extraer todas las definiciones de grupos
rg -A 2 "group\s*=" --type nix | grep -E "(^|<leader>|group)"
```

#### Patrón de Which-Key Groups

```nix
plugins.which-key.settings.spec = [
  # Grupos principales
  { __unkeyed-1 = "<leader>a"; group = "+AI Assistant"; icon = ""; }
  { __unkeyed-1 = "<leader>b"; group = "+Buffers"; icon = ""; }
  { __unkeyed-1 = "<leader>c"; group = "+Code & Comments"; icon = ""; }
  { __unkeyed-1 = "<leader>d"; group = "+Debug"; icon = ""; }
  { __unkeyed-1 = "<leader>f"; group = "+Find"; icon = ""; }
  { __unkeyed-1 = "<leader>g"; group = "+Git"; icon = ""; }
  # ... etc
];
```

#### Extraer TODAS las categorías

```bash
# Crear lista de categorías
cd /home/ludus/Work/khanelivim/modules/nixvim
echo "=== WHICH-KEY CATEGORIES ===" > /tmp/whichkey_categories.txt
rg "group\s*=\s*\".*\"" --type nix | \
  sed -E 's/.*__unkeyed-1.*"(<leader>[^"]*)".*group.*"([^"]*)".*icon.*"([^"]*)".*/\1 | \2 | \3/' | \
  sort -u >> /tmp/whichkey_categories.txt

cat /tmp/whichkey_categories.txt
```

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

**IMPORTANTE:** Usar las categorías extraídas de which-key como base para la organización.

### 3.1 Mapeo de Categorías Which-Key a Documentación

Basándose en las capturas de pantalla, estas son TODAS las categorías de which-key:

| Which-Key Group | Prefix | Icon | Categoría en Docs | Keymaps Ejemplo |
|----------------|--------|------|-------------------|-----------------|
| +AI Assistant | `<leader>a` | 🤖 | **AI Assistant** | aa (AI Assistant) |
| +Buffers | `<leader>b` | 📋 | **Buffers** | bc (Close buffer), bC (Close all) |
| +Code & Comments | `<leader>c` | 💬 | **Code & Comments** | cb (Box title), cl (Simple line) |
| +Debug | `<leader>d` | 🐛 | **Debug (DAP)** | db (Breakpoint), dc (Continue), di (Step into) |
| +Find | `<leader>f` | 🔍 | **Find (Snacks Picker)** | ff (Find files), fw (Live grep), fb (Buffers) |
| +Git | `<leader>g` | 🌿 | **Git** | gg (Lazygit), ghs (Stage hunk), gff (Git files) |
| +Harpoon | `<leader>H` | 🎯 | **Harpoon** | Ha (Add file), He (Quick menu), Hj-Hm (Navigate) |
| +HTTP | `<leader>h` | 🌐 | **HTTP** | hc (Copy as cURL), hi (Inspect), hn (Next request) |
| +REPL (Iron) | `<leader>i` | 🔥 | **REPL (Iron)** | ir (Open REPL), iR (Open REPL here) |
| +Jujutsu | `<leader>j` | ⚡ | **Jujutsu (VCS)** | ja (Abandon), jd (Describe), je (Edit), jf (Fetch) |
| +LSP | `<leader>l` | 🔧 | **LSP** | la (Code action), lf (Format), ld (Diagnostics) |
| +Multicursor | `<leader>m` | 📍 | **Multicursor** | ma (Add cursor above), mb (Add cursor below) |
| +Notes | `<leader>n` | 📝 | **Notes (Scratch)** | nn (New scratch), ns (Select scratch), nj (Today's journal) |
| +Preview | `<leader>p` | 👁️ | **Preview** | pe (Patterns explain), pg (Glow markdown), ph (Patterns hover) |
| +Refactor | `<leader>Q` | ♻️ | **Refactor** | Qb (Extract block), Qc (Debug cleanup), Qi (Inline) |
| +Run | `<leader>R` | ▶️ | **Run** | Ra (Code action Rust), Rc (Open Cargo.toml), Rg (Crate graph) |
| +Replace (Search) | `<leader>r` | 🔄 | **Search & Replace** | rg (Grug-far toggle), rw (Replace word) |
| +Search | `<leader>s` | 🔎 | **Search** | sw (Search word visual/cursor), sh (DevDocs) |
| +Sessions | `<leader>S` | 💾 | **Sessions** | Sl (Load current dir), SL (Load last), Ss (Select session) |
| +Test | `<leader>t` | 🧪 | **Testing (Neotest)** | tt (Run nearest), tr (Run file), tR (Run all) |
| +UI/UX | `<leader>u` | 🎨 | **UI Toggles** | udd (Diagnostics), ues (Spell), uZ (Zen), un (Notifications) |
| +Vim training | `<leader>v` | 🎓 | **Vim Training** | vn (Hardtime toggle), vp (Precognition toggle) |
| +Trouble | `<leader>x` | ⚠️ | **Trouble** | xx (Diagnostics toggle), xX (Buffer diagnostics), xl (Location list) |

### 3.2 Estructura de Categorías (ACTUALIZADA)

### 3.2 Estructura de Categorías (ACTUALIZADA)

Organizar la documentación siguiendo el orden de which-key:

```markdown
## 1. General
Leader key, save, quit, clipboard básico

## 2. Navigation & Windows
Window focus (Ctrl+hjkl), splits, resize, quickfix

## 3. AI Assistant (`<leader>a`)
TODOS los keymaps de AI Assistant

## 4. Buffers (`<leader>b`)
Buffer navigation ([b, ]b) y gestión (<leader>b*)

## 5. Code & Comments (`<leader>c`)
Comment toggle, box title, simple line, titled line, delete box, rename file

## 6. Debug (`<leader>d`)
TODOS los <leader>d* - DAP keymaps

## 7. Find/Search (`<leader>f`, `<leader>s`)
TODOS los <leader>f* y <leader>s* - Snacks Picker keymaps

## 8. Git (`<leader>g`)
### 8.1 Git Operations
<leader>gg (Lazygit), go, gm, etc.

### 8.2 Git Picker
<leader>gf* (gff, gfb, gfc, gfs, etc.)

### 8.3 Gitsigns/Hunks
<leader>gh*, ]c, [c, gb, gS, gR, gU

### 8.4 Diffview
<leader>gdv, gdV, gD

## 9. Harpoon (`<leader>H`)
TODOS los <leader>H* keymaps

## 10. HTTP (`<leader>h`)
HTTP request keymaps

## 11. LSP (`<leader>l` y `g*`)
### 11.1 Go To Navigation
gd, gD, gr, gy, gl, etc.

### 11.2 LSP Actions
<leader>l* - actions, diagnostics, info, etc.

## 12. Multicursor (`<leader>m`)
Multicursor keymaps

## 13. Neoconf
Neoconf configuration keymaps

## 14. Preview (`<leader>p` o `D`)
Preview keymaps

## 15. Refactor (`<leader>Q` o `R`)
Refactoring keymaps

## 16. Search & Replace (`<leader>r`)
Grug-Far keymaps (rg, rw, rW)

## 17. Run (`<leader>R`)
Run keymaps

## 18. Sessions (`<leader>S`)
Session management

## 19. Testing (`<leader>t`)
Neotest keymaps (tt, tr, tR, td, etc.)

## 20. Trouble (`<leader>x`)
Diagnostics keymaps (xx, xX, xl, etc.)

## 21. UI Toggles (`<leader>u`)
TODOS los toggle keymaps (ud*, ue*, ua*, us*, ut*)

## 22. Vim Training (`<leader>v`)
Vim training keymaps

## 23. Flash (Motion)
Motion keymaps: s, S, r, R, gl

## 24. Reference Navigation
]], [[

## 25. File Explorer
<leader>E, <leader>fe

## 26. Editing
Move lines (Alt+j/k), indent, visual mode

## 27. Terminal
<C-/>, <leader>ut

## 28. Other
Cualquier keymap no categorizado
```

## 📝 PASO 4: Formateo Markdown

### 4.1 Template por Sección

Cada sección debe incluir el icono de which-key si está disponible:

```markdown
## [Número]. [Nombre de Sección] (`<leader>X`) [icon]

[Descripción breve de la categoría]

| Key | Description | Mode |
| --- | --- | --- |
| `<key>` | [Descripción] | [Modo] |
```

**Ejemplo real:**

```markdown
## 3. AI Assistant (`<leader>a`) 

Keymaps para interactuar con asistentes de IA.

| Key | Description | Mode |
| --- | --- | --- |
| `<leader>aa` | AI Assistant | Normal |
| `<leader>ac` | AI Chat | Normal |
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

Verificar que estos keymaps SIEMPRE estén en la documentación (organizados por categoría de which-key):

#### General
- [ ] `<leader>` → Show which-key
- [ ] `<leader>w` → Save file
- [ ] `q` → Quit
- [ ] `Q` → Force quit

#### AI Assistant (`<leader>a`)
- [ ] Verificar que TODOS los keymaps de AI Assistant estén documentados

#### Buffers (`<leader>b`)
- [ ] `[b` → Previous buffer
- [ ] `]b` → Next buffer
- [ ] `<leader>bc` → Close buffer
- [ ] `<leader>bC` → Close all but current
- [ ] `<leader>bp` → Pick buffer
- [ ] `<leader>bP` → Pin buffer toggle

#### Code & Comments (`<leader>c`)
- [ ] `<leader>cb` → Box title
- [ ] `<leader>cl` → Simple line
- [ ] `<leader>ct` → Titled line
- [ ] `<leader>cd` → Delete box
- [ ] `<leader>cr` → Rename file

#### Debug (`<leader>d`)
- [ ] `<leader>db` → Toggle breakpoint
- [ ] `<leader>dc` → Continue
- [ ] `<leader>di` → Step into
- [ ] `<leader>do` → Step out
- [ ] `<leader>dO` → Step over
- [ ] `<leader>dR` → Restart
- [ ] `<leader>dt` → Terminate
- [ ] `<leader>de` → Eval
- [ ] `<leader>dh` → Hover
- [ ] `<leader>du` → Toggle UI
- [ ] `<leader>dw` → Widgets

#### Find/Search (`<leader>f`, `<leader>s`)
- [ ] `<leader>ff` → Find files
- [ ] `<leader>fFA` → Find files (all)
- [ ] `<leader>fw` → Live grep
- [ ] `<leader>fW` → Live grep (all files)
- [ ] `<leader>fb` → Buffers
- [ ] `<leader><space>` → Recent files
- [ ] `<leader>fa` → Find autocmds
- [ ] `<leader>fc` → Find commands
- [ ] `<leader>fC` → Find config files
- [ ] `<leader>fh` → Find help tags
- [ ] `<leader>fk` → Find keymaps
- [ ] `<leader>fL` → Find lazy plugins
- [ ] `<leader>fm` → Find man pages
- [ ] `<leader>fr` → Find registers
- [ ] `<leader>fu` → Find undo history
- [ ] `<leader>f'` → Find marks
- [ ] `<leader>fj` → Find jumps
- [ ] `<leader>fe` → File explorer
- [ ] `<leader>fo` → Find old files
- [ ] `<leader>fO` → Find old files (cwd)
- [ ] `<leader>fp` → Find projects
- [ ] `<leader>fq` → Find quickfix
- [ ] `<leader>f/` → Find in current buffer
- [ ] `<leader>f?` → Search history
- [ ] `<leader>f<CR>` → Command history
- [ ] `<leader>fZ` → Find in open buffers
- [ ] `<leader>fz` → Fuzzy find in buffer
- [ ] `<leader>fd` → LSP document symbols
- [ ] `<leader>fD` → LSP workspace symbols
- [ ] `<leader>fl` → LSP locations
- [ ] `<leader>fS` → Find spelling suggestions
- [ ] `<leader>fT` → Find TODO/FIX/etc
- [ ] `<leader>f,` → Find files (current buffer dir)
- [ ] `<leader>fH` → Find highlights
- [ ] `<leader>sw` → Search word

#### Git (`<leader>g`)
- [ ] `<leader>gg` → Lazygit
- [ ] `]c` → Next hunk
- [ ] `[c` → Previous hunk
- [ ] `<leader>ghs` → Stage hunk
- [ ] `<leader>ghr` → Reset hunk
- [ ] `<leader>ghS` → Stage buffer
- [ ] `<leader>ghu` → Undo stage hunk
- [ ] `<leader>ghR` → Reset buffer
- [ ] `<leader>ghp` → Preview hunk
- [ ] `<leader>ghb` → Blame line
- [ ] `<leader>ghd` → Diff this
- [ ] `<leader>ghD` → Diff this ~
- [ ] `<leader>go` → Open in browser
- [ ] `<leader>gO` → Open in browser (file)
- [ ] `<leader>gm` → Blame line
- [ ] `<leader>gM` → Blame full
- [ ] `<leader>gb` → Blame line (toggle)
- [ ] `<leader>gS` → Git status (CodeDiff)
- [ ] `<leader>gR` → Reset buffer
- [ ] `<leader>gU` → Unstage buffer
- [ ] `<leader>gdv` → Open diffview
- [ ] `<leader>gdV` → File history
- [ ] `<leader>gD` → Show range history
- [ ] `<leader>gff` → Git files
- [ ] `<leader>gfb` → Git branches
- [ ] `<leader>gfc` → Git commits
- [ ] `<leader>gfs` → Git status
- [ ] `<leader>gfh` → Git stash
- [ ] `<leader>gfL` → Git log
- [ ] `<leader>gfd` → Git diff
- [ ] `<leader>gfa` → Git worktree add

#### Harpoon (`<leader>H`)
- [ ] `<leader>Ha` → Add mark
- [ ] `<leader>He` → Toggle quick menu
- [ ] `<leader>Hj` → Navigate to mark 1
- [ ] `<leader>Hk` → Navigate to mark 2
- [ ] `<leader>Hl` → Navigate to mark 3
- [ ] `<leader>Hm` → Navigate to mark 4

#### HTTP (`<leader>h`)
- [ ] `<leader>hc` → Copy as cURL
- [ ] `<leader>hi` → Inspect request
- [ ] `<leader>hn` → Jump to next request
- [ ] `<leader>hp` → Jump to previous request
- [ ] `<leader>hq` → Close response window
- [ ] `<leader>hr` → Run HTTP request under cursor
- [ ] `<leader>hR` → Replay last request
- [ ] `<leader>hs` → Open scratchpad
- [ ] `<leader>ht` → Toggle view (body/headers/both)
- [ ] `<leader>he` → Environment

#### REPL - Iron (`<leader>i`)
- [ ] `<leader>ir` → Open REPL
- [ ] `<leader>iR` → Open REPL here

#### Jujutsu (`<leader>j`)
- [ ] `<leader>ja` → Abandon
- [ ] `<leader>jd` → Describe
- [ ] `<leader>je` → Edit
- [ ] `<leader>jf` → Fetch
- [ ] `<leader>jh` → History picker
- [ ] `<leader>jl` → Log
- [ ] `<leader>jL` → Log all
- [ ] `<leader>jn` → New
- [ ] `<leader>jr` → Rebase
- [ ] `<leader>jS` → Squash
- [ ] `<leader>js` → Status
- [ ] `<leader>jt` → Tug
- [ ] `<leader>ju` → Undo
- [ ] `<leader>jy` → Redo
- [ ] `<leader>jb` → Bookmark
- [ ] `<leader>jp` → Picker

#### LSP (`<leader>l` y `g*`)
- [ ] `gd` → Go to definition
- [ ] `gD` → Go to declaration
- [ ] `gr` → References
- [ ] `grr` → References (alternative)
- [ ] `gri` → Implementation
- [ ] `gy` → Type definition
- [ ] `gl` → Line diagnostics
- [ ] `K` → Hover documentation
- [ ] `<leader>la` → Code actions
- [ ] `<leader>lf` → Format
- [ ] `<leader>ld` → Line diagnostics
- [ ] `<leader>li` → LSP info
- [ ] `<leader>lD` → LSP document diagnostics
- [ ] `<leader>lt` → LSP type definition
- [ ] `<leader>lA` → Generate annotation
- [ ] `<leader>lh` → Hover
- [ ] `<leader>lr` → Rename
- [ ] `<leader>lw` → Trim trailing whitespace
- [ ] `<leader>lj` → Next diagnostic
- [ ] `<leader>lk` → Prev diagnostic
- [ ] `<leader>ll` → LazyDev

#### Multicursor (`<leader>m`)
- [ ] `<leader>ma` → Add cursor above
- [ ] `<leader>mA` → Skip cursor above
- [ ] `<leader>mb` → Add cursor below
- [ ] `<leader>mB` → Skip cursor below
- [ ] `<leader>mn` → Add cursor by match (next)
- [ ] `<leader>mp` → Add cursor by match (prev)
- [ ] `<leader>ms` → Skip cursor by match (next)
- [ ] `<leader>mS` → Skip cursor by match (prev)
- [ ] `<leader>mt` → Toggle cursor

#### Notes/Scratch (`<leader>n`)
- [ ] `<leader>nn` → New scratch buffer
- [ ] `<leader>ns` → Select scratch buffer
- [ ] `<leader>nc` → Toggle concealer
- [ ] `<leader>nj` → Today's journal
- [ ] `<leader>nJ` → Custom date journal
- [ ] `<leader>ny` → Yesterday's journal
- [ ] `<leader>no` → Tomorrow's journal
- [ ] `<leader>nN` → Neorg

#### Preview (`<leader>p`)
- [ ] `<leader>pe` → Patterns explain
- [ ] `<leader>pg` → Glow (markdown)
- [ ] `<leader>ph` → Patterns hover
- [ ] `<leader>pm` → Markdown preview

#### Refactor (`<leader>Q`)
- [ ] `<leader>Qb` → Extract block
- [ ] `<leader>QB` → Extract block to file
- [ ] `<leader>Qc` → Debug cleanup
- [ ] `<leader>Qg` → Grug-far toggle
- [ ] `<leader>Qi` → Inline variable
- [ ] `<leader>QI` → Inline function
- [ ] `<leader>Qp` → Debug printf
- [ ] `<leader>QP` → Debug print variable
- [ ] `<leader>Qw` → Rename word in buffer
- [ ] `<leader>QW` → Rename word in project

#### Run (`<leader>R`)
- [ ] `<leader>Ra` → Code action (Rust)
- [ ] `<leader>RA` → Task action
- [ ] `<leader>Rc` → Open Cargo.toml
- [ ] `<leader>Rd` → Open docs
- [ ] `<leader>Rg` → Crate graph
- [ ] `<leader>Rh` → Hover actions (Rust)
- [ ] `<leader>Rm` → Expand macro
- [ ] `<leader>RM` → Rebuild proc macros
- [ ] `<leader>Ro` → Open output
- [ ] `<leader>Rp` → Rust runnables
- [ ] `<leader>Rr` → Run task
- [ ] `<leader>Rs` → Run shell command
- [ ] `<leader>Rt` → Toggle output

#### Replace/Search (`<leader>r`)
- [ ] `<leader>rg` → Grug-far toggle
- [ ] `<leader>rw` → Replace word in buffer
- [ ] `<leader>rW` → Replace word in project

#### Search (`<leader>s`)
- [ ] `<leader>sw` → Search word (visual/cursor)
- [ ] `<leader>sh` → DevDocs

#### Sessions (`<leader>S`)
- [ ] `<leader>Sl` → Load current directory
- [ ] `<leader>SL` → Load last session
- [ ] `<leader>Ss` → Select a session to load
- [ ] `<leader>SS` → Stop persistence

#### Testing (`<leader>t`)
- [ ] `<leader>ta` → Attach test
- [ ] `<leader>td` → Debug test
- [ ] `<leader>to` → Output panel toggle
- [ ] `<leader>tr` → Run nearest test
- [ ] `<leader>tR` → Run file
- [ ] `<leader>ts` → Stop
- [ ] `<leader>tt` → Summary toggle

#### Trouble (`<leader>x`)
- [ ] `<leader>xl` → LSP definitions/references toggle
- [ ] `<leader>xL` → Location list toggle
- [ ] `<leader>xq` → Quickfix list toggle
- [ ] `<leader>xQ` → TodoTrouble RETURN
- [ ] `<leader>xx` → Diagnostics toggle
- [ ] `<leader>xX` → Buffer diagnostics toggle

#### UI Toggles (`<leader>u`)
- [ ] `<leader>udd` → Toggle diagnostics (document)
- [ ] `<leader>udD` → Toggle diagnostics (global)
- [ ] `<leader>ues` → Toggle spell check
- [ ] `<leader>uew` → Toggle wrap
- [ ] `<leader>uei` → Toggle inlay hints
- [ ] `<leader>ueh` → Toggle inlay hints (global)
- [ ] `<leader>uen` → Toggle line numbers
- [ ] `<leader>ueW` → Toggle trailing whitespace
- [ ] `<leader>ueo` → Toggle options
- [ ] `<leader>uet` → Toggle treesitter highlight
- [ ] `<leader>uaa` → Toggle all
- [ ] `<leader>uss` → Toggle statusline
- [ ] `<leader>usZ` → Toggle statusline (global)
- [ ] `<leader>usz` → Toggle tabline
- [ ] `<leader>utt` → Toggle transparency
- [ ] `<leader>utr` → Toggle transparency (global)
- [ ] `<leader>un` → Dismiss notifications
- [ ] `<leader>uN` → Notification history
- [ ] `<leader>uZ` → Zen mode
- [ ] `<leader>uC` → Color picker
- [ ] `<leader>upp` → Toggle profiler
- [ ] `<leader>upP` → Profile snacks
- [ ] `<leader>ups` → Profile start/stop
- [ ] `<leader>ut` → Toggle terminal
- [ ] `<leader>usd` → Toggle show diagnostics

#### Vim Training (`<leader>v`)
- [ ] `<leader>vn` → Hardtime toggle
- [ ] `<leader>vp` → Precognition toggle

#### Other
- [ ] `<C-/>` → Toggle terminal
- [ ] `<leader>E` → File explorer
- [ ] Flash motion keymaps (s, S, r, R, gl)
- [ ] `]]` → Next reference
- [ ] `[[` → Previous reference

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

## 🔄 PASO 6: Actualización Iterativa (NO Reemplazo)

### 6.1 Filosofía de Actualización

**NUNCA reemplazar el archivo completo.** El proceso debe ser iterativo:

1. ✅ **Leer** el archivo existente `/home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx`
2. ✅ **Analizar** qué categorías y keymaps ya existen
3. ✅ **Comparar** con los keymaps extraídos del source
4. ✅ **Agregar** solo los keymaps faltantes
5. ✅ **Actualizar** descripciones si han cambiado
6. ✅ **Preservar** todo el contenido existente

### 6.2 Proceso de Comparación

```bash
# 1. Hacer backup del archivo actual
cp /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx \
   /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup

# 2. Extraer keymaps actuales del archivo de documentación
echo "=== KEYMAPS EN DOCUMENTACIÓN ACTUAL ===" > /tmp/current_keymaps.txt
grep "^| \`" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
  cut -d'|' -f2 | \
  sed 's/[` ]//g' | \
  sort -u >> /tmp/current_keymaps.txt

# 3. Extraer keymaps del source (khanelivim)
# (usar comando del paso 2.3 para generar /tmp/khanelivim_keymaps_raw.txt)

# 4. Comparar y encontrar diferencias
echo "=== KEYMAPS FALTANTES ===" > /tmp/missing_keymaps.txt
# Esto se hace manualmente comparando ambos archivos
```

### 6.3 Estrategia de Actualización por Sección

Para CADA categoría de which-key:

```markdown
## Paso a paso por categoría:

1. Verificar si la sección existe en neovim.mdx
   - Buscar: `## N. [Nombre Categoría]`
   
2. Si NO existe:
   - Crear la sección completa con formato
   - Agregar TODOS los keymaps de esa categoría
   
3. Si SÍ existe:
   - Leer TODOS los keymaps actuales en esa sección
   - Comparar con keymaps del source
   - Agregar SOLO los faltantes al final de la tabla
   - Actualizar descripciones si son diferentes
   - Mantener el orden alfabético dentro de la tabla
```

### 6.4 Comandos de Verificación por Sección

```bash
# Verificar si una sección específica existe
# Ejemplo: AI Assistant
grep -q "^## .*AI Assistant" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx
if [ $? -eq 0 ]; then
  echo "Sección AI Assistant existe - modo ACTUALIZAR"
else
  echo "Sección AI Assistant NO existe - modo CREAR"
fi

# Extraer keymaps de una sección específica
# Ejemplo: extraer todos los keymaps de la sección "AI Assistant"
awk '/^## .*AI Assistant/,/^## / {print}' \
  /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
  grep "^| \`" | \
  cut -d'|' -f2 | \
  sed 's/[` ]//g'
```

### 6.5 Template de Actualización Iterativa

**Para agregar un keymap faltante a una sección existente:**

```bash
# Ejemplo: Agregar <leader>ai a la sección AI Assistant

# 1. Encontrar el número de línea donde termina la sección
SECTION_START=$(grep -n "^## .*AI Assistant" neovim.mdx | cut -d: -f1)
SECTION_END=$(tail -n +$((SECTION_START + 1)) neovim.mdx | \
              grep -n "^## " | head -1 | cut -d: -f1)

# 2. Insertar la nueva fila en la tabla (antes del final de la sección)
# Usar sed, awk o un editor de texto programático

# 3. Mantener el formato de la tabla
# | `<leader>ai` | AI Inline | Normal |
```

### 6.6 Proceso de Actualización Manual/Asistido

**Recomendación:** En lugar de un script automático completo, usar un enfoque asistido:

1. **Claude Code extrae** todos los keymaps del source
2. **Claude Code lee** el archivo actual de documentación
3. **Claude Code identifica** qué keymaps faltan por sección
4. **Claude Code genera** un reporte de diferencias:
   ```
   Sección: AI Assistant (<leader>a)
   - Keymaps actuales: 5
   - Keymaps en source: 8
   - Faltantes: <leader>ai, <leader>ac, <leader>ax
   
   Sección: HTTP (<leader>h)
   - NO EXISTE - necesita crearse completa
   - Keymaps a agregar: 10
   ```
5. **Claude Code actualiza** sección por sección, preservando contenido existente

### 6.7 Verificación de Integridad Post-Actualización

Después de cada actualización, verificar:

```bash
# 1. El archivo es markdown válido
# 2. Todas las tablas tienen el formato correcto
# 3. No hay secciones duplicadas
grep "^## " /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
  sort | uniq -d

# 4. No hay keymaps duplicados
grep "^| \`" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
  cut -d'|' -f2 | sed 's/[` ]//g' | sort | uniq -d

# 5. El conteo de keymaps aumentó (no disminuyó)
BEFORE=$(cat /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup | \
         grep "^| \`" | wc -l)
AFTER=$(cat /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
        grep "^| \`" | wc -l)
echo "Keymaps antes: $BEFORE, después: $AFTER, diff: $((AFTER - BEFORE))"
```

### 6.8 Reporte de Cambios

Después de la actualización, generar un reporte:

```markdown
# Reporte de Actualización de Keymaps
Fecha: [FECHA]

## Resumen
- Secciones creadas: N
- Secciones actualizadas: N
- Keymaps agregados: N
- Keymaps actualizados: N
- Total keymaps ahora: N

## Detalles por Sección

### AI Assistant (<leader>a)
- Estado: ACTUALIZADA
- Keymaps agregados: 3
  - <leader>ai - AI Inline
  - <leader>ac - AI Chat
  - <leader>ax - AI Execute

### HTTP (<leader>h)
- Estado: CREADA (nueva)
- Keymaps agregados: 10
  - <leader>hc - Copy as cURL
  - <leader>hi - Inspect request
  - ... [lista completa]

### [Otras secciones...]
```

### 6.9 Workflow de Actualización Iterativa Completo

```bash
#!/bin/bash
# Script de actualización iterativa

DOC_FILE="/home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx"
SOURCE_DIR="/home/ludus/Work/khanelivim/modules/nixvim"

echo "=== INICIO ACTUALIZACIÓN ITERATIVA ==="

# 1. Backup
cp "$DOC_FILE" "$DOC_FILE.backup.$(date +%Y%m%d_%H%M%S)"

# 2. Analizar estado actual
echo "Analizando documentación actual..."
CURRENT_SECTIONS=$(grep "^## " "$DOC_FILE" | wc -l)
CURRENT_KEYMAPS=$(grep "^| \`" "$DOC_FILE" | wc -l)
echo "Secciones actuales: $CURRENT_SECTIONS"
echo "Keymaps actuales: $CURRENT_KEYMAPS"

# 3. Extraer keymaps del source
echo "Extrayendo keymaps del source..."
cd "$SOURCE_DIR"
# [Ejecutar comandos del paso 2.3]

# 4. Para cada categoría de which-key:
CATEGORIES=(
  "AI Assistant:<leader>a"
  "Buffers:<leader>b"
  "Code & Comments:<leader>c"
  # ... [todas las categorías]
)

for category in "${CATEGORIES[@]}"; do
  NAME="${category%%:*}"
  PREFIX="${category##*:}"
  
  echo "Procesando: $NAME ($PREFIX)"
  
  # Verificar si existe
  if grep -q "^## .*$NAME" "$DOC_FILE"; then
    echo "  - Sección existe, verificando keymaps..."
    # [Comparar y actualizar]
  else
    echo "  - Sección NO existe, creando..."
    # [Crear sección completa]
  fi
done

# 5. Verificar integridad
echo "Verificando integridad..."
# [Ejecutar verificaciones del paso 6.7]

# 6. Generar reporte
echo "Generando reporte..."
# [Crear reporte del paso 6.8]

echo "=== ACTUALIZACIÓN COMPLETADA ==="
```

### 6.10 Instrucciones para Claude Code

**Prompt optimizado para actualización iterativa:**

```
Usa /home/ludus/Dotfiles/.agent/workflows/sync-neovim-keymaps.md 
para ACTUALIZAR (no reemplazar) la documentación en
/home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx

MODO: ITERATIVO - Preservar todo el contenido existente

Proceso:
1. LEE el archivo neovim.mdx actual completamente
2. ANALIZA qué secciones y keymaps ya existen
3. EXTRAE keymaps del source (/home/ludus/Work/khanelivim)
4. COMPARA para identificar faltantes
5. ACTUALIZA solo lo necesario:
   - CREA secciones que no existen
   - AGREGA keymaps faltantes a secciones existentes
   - ACTUALIZA descripciones si cambiaron
   - PRESERVA todo lo demás

6. VERIFICA integridad (paso 6.7)
7. GENERA reporte de cambios (paso 6.8)

NUNCA reemplaces el archivo completo.
SIEMPRE preserva el contenido existente.
SOLO agrega o actualiza lo necesario.
```

## 🚨 CASOS ESPECIALES

### Which-key Groups vs Keymaps

**IMPORTANTE:** Distinguir entre grupos y keymaps reales.

#### Grupos (NO documentar como keymaps)
```nix
# Estos son SOLO etiquetas de grupo
{ __unkeyed-1 = "<leader>g"; group = "Git"; icon = ""; }
{ __unkeyed-1 = "<leader>f"; group = "Find"; icon = ""; }
```

**Acción:** Usar estos para:
1. Crear encabezados de sección con el nombre del grupo
2. Incluir el icono en el encabezado si está disponible
3. Agregar breve descripción de la categoría

#### Keymaps Reales (SÍ documentar)
```nix
# Estos SÍ son keymaps funcionales
{
  key = "<leader>gg";
  action = "<cmd>Lazygit<CR>";
  options.desc = "Lazygit";
}
```

### Categorías de Which-Key sin Keymaps Propios

Algunas categorías en which-key pueden ser solo organizacionales y no tener keymaps directos.

**Ejemplo:** `<leader>g` es un grupo, pero los keymaps reales son `<leader>gg`, `<leader>ghs`, etc.

**Acción:** 
1. Crear la sección con el nombre del grupo
2. Documentar TODOS los keymaps que empiecen con ese prefix
3. Si no hay keymaps, marcar como "Categoría organizacional - ver subsecciones"

### Keymaps Condicionales

Muchos keymaps están condicionados con:
```nix
mkIf config.plugins.*.enable { ... }
```

**Decisión:** Documentar TODOS los keymaps que estén habilitados en la configuración default de khanelivim.

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

La documentación está completa y actualizada cuando:

1. ✅ Todos los archivos de la checklist están revisados
2. ✅ TODAS las categorías de which-key tienen su sección correspondiente
3. ✅ El conteo de keymaps **aumentó o se mantuvo** (nunca disminuyó)
4. ✅ Todos los keymaps críticos están presentes (ver checklist 5.2)
5. ✅ No hay duplicados sin resolver
6. ✅ Cada categoría de which-key tiene su sección con keymaps o nota explicativa
7. ✅ El formato markdown es consistente y válido
8. ✅ Los keymaps de las capturas de pantalla están incluidos
9. ✅ Los iconos de which-key están en los encabezados (si disponibles)
10. ✅ El orden de secciones sigue el orden de which-key
11. ✅ **El contenido previo fue PRESERVADO, no reemplazado**
12. ✅ **El reporte de cambios muestra solo adiciones/actualizaciones**

## 📌 NOTAS IMPORTANTES

1. **Siempre buscar en TODO el árbol de archivos**, no solo en los conocidos
2. **Extraer PRIMERO las categorías de which-key** antes de organizar keymaps
3. **Usar el orden de which-key** para estructurar la documentación
4. **No asumir que un archivo no tiene keymaps** - verificar cada uno
5. **Distinguir entre grupos y keymaps** - los grupos son solo organizacionales
6. **Documentar el comportamiento default**, no todas las variantes condicionales
7. **Incluir iconos de which-key** en los encabezados cuando estén disponibles
8. **Mantener el orden de categorías** - facilita la navegación y coincide con which-key
9. **Usar el formato EXACTO de las keys** - copiar tal cual de los archivos
10. **Actualizar este workflow** cada vez que se descubra un nuevo patrón o categoría
11. **🚨 NUNCA REEMPLAZAR EL ARCHIVO COMPLETO** - siempre modo iterativo
12. **🚨 PRESERVAR TODO EL CONTENIDO EXISTENTE** - solo agregar/actualizar
13. **Hacer backup antes de cada actualización** - por seguridad
14. **Generar reporte de cambios** - para auditar qué se agregó/cambió
15. **Verificar integridad post-actualización** - conteo debe aumentar, no disminuir

### Sobre las Categorías de Which-Key

- Las categorías en which-key son la FUENTE DE VERDAD para la organización
- Cada grupo de which-key (`group = "..."`) debe tener su propia sección
- El prefix del grupo (`<leader>a`, `<leader>b`, etc.) debe estar en el encabezado
- Si un grupo no tiene keymaps directos, documentar sus sub-keymaps

### Sobre el Modo Iterativo

- **NUNCA** usar `> neovim.mdx` para sobrescribir
- **SIEMPRE** leer primero, luego actualizar
- **SOLO** agregar lo que falta
- **PRESERVAR** descripciones personalizadas si existen
- **MANTENER** el orden dentro de cada tabla
- **REPORTAR** todos los cambios realizados

## 🔍 DEBUGGING

Si faltan keymaps o hay problemas:

```bash
# 1. Listar TODOS los archivos .nix
find /home/ludus/Work/khanelivim/modules/nixvim -name "*.nix" | sort

# 2. Grep TODOS los posibles patrones de keymaps
cd /home/ludus/Work/khanelivim/modules/nixvim
rg -A 5 -B 2 'keymaps|lazyLoad|lz-n|vim\.keymap|which-key' --type nix

# 3. Buscar el keymap específico faltante
# Ejemplo: buscar <leader>db
rg "<leader>db" --type nix

# 4. Ver el archivo completo donde está definido
cat [archivo_encontrado]

# 5. Verificar categorías de which-key
rg "group\s*=" --type nix -A 1 -B 1

# 6. Extraer TODAS las categorías con sus prefixes
rg "__unkeyed-1.*<leader>.*group" --type nix | \
  sed -E 's/.*__unkeyed-1.*"(<leader>[^"]*)".*group.*"([^"]*)".*icon.*"([^"]*)".*/Prefix: \1 | Group: \2 | Icon: \3/'
```

### Debugging Categorías Faltantes

Si una categoría de which-key no aparece en la documentación:

```bash
# Buscar el prefix específico
rg "<leader>a" --type nix  # Para AI Assistant
rg "<leader>h" --type nix  # Para HTTP
rg "<leader>m" --type nix  # Para Multicursor

# Ver contexto completo
rg -C 10 "<leader>a" --type nix
```

### Verificar Completitud de Categorías

```bash
# Listar TODAS las categorías definidas en which-key
cd /home/ludus/Work/khanelivim/modules/nixvim
echo "=== CATEGORÍAS EN WHICH-KEY ===" 
rg "group\s*=\s*\"" --type nix | \
  sed -E 's/.*group\s*=\s*"([^"]*)".*/ - \1/' | \
  sort -u

# Comparar con secciones en documentación
echo ""
echo "=== SECCIONES EN DOCUMENTACIÓN ==="
grep "^##" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx
```

### Debugging Actualización Iterativa

Si la actualización no está funcionando como esperado:

```bash
# 1. Verificar que el backup existe
ls -lh /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup*

# 2. Comparar diferencias entre backup y actual
diff /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup \
     /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx

# 3. Ver solo las líneas agregadas
diff /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup \
     /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
     grep "^>"

# 4. Contar cambios
echo "Líneas agregadas:"
diff /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup \
     /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
     grep "^>" | wc -l

echo "Líneas eliminadas:"
diff /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup \
     /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
     grep "^<" | wc -l

# 5. Si algo salió mal, restaurar backup
cp /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx.backup \
   /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx
```

### Verificar Keymaps Específicos por Sección

```bash
# Extraer keymaps de una sección específica
# Ejemplo: AI Assistant
awk '/^## .*AI Assistant/,/^## /' \
  /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
  grep "^| \`" | \
  cut -d'|' -f2 | \
  sed 's/[` ]//g' | \
  sort

# Comparar con el source
cd /home/ludus/Work/khanelivim/modules/nixvim
rg "<leader>a" --type nix | grep "key\|__unkeyed-1"
```

### Validar Formato de Tablas

```bash
# Verificar que todas las filas de tabla tienen el formato correcto
grep "^| \`" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx | \
  while read line; do
    # Contar pipes (debe ser 4: inicio, key, desc, mode, fin)
    pipes=$(echo "$line" | tr -cd '|' | wc -c)
    if [ $pipes -ne 4 ]; then
      echo "ERROR en línea: $line (pipes: $pipes)"
    fi
  done
```

---

**Última actualización:** Enero 2025
**Versión:** 2.0
**Mantenedor:** @ludus
