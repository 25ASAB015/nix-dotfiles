---
description: Sync Neovim keymaps from khanelivim config to Dotfiles documentation
---

# Sync Neovim Keymaps Documentation

This workflow synchronizes keybindings from the `khanelivim` Neovim configuration to the documentation in your Dotfiles.

## Source and Target Files

### Source (khanelivim configuration)
**Base Path:** `/home/ludus/Work/khanelivim/modules/nixvim`

#### Core Keymaps
- `/home/ludus/Work/khanelivim/modules/nixvim/keymappings.nix` - General keymaps (leader, navigation, buffers, editing, window splits)
- `/home/ludus/Work/khanelivim/modules/nixvim/lsp.nix` - LSP keymaps and which-key specs

#### Plugin Keymaps (check ALL)
```
/home/ludus/Work/khanelivim/modules/nixvim/plugins/
├── conform/default.nix          # Format keymaps (<leader>lf)
├── dap/default.nix              # Debug keymaps (<leader>db, dc, di, do, dO, etc.)
├── dap-ui/default.nix           # Debug UI keymaps (<leader>du, de, dh)
├── diffview/default.nix         # Diffview keymaps (<leader>gdv, gdV, gD)
├── flash/default.nix            # Motion keymaps (s, S, r, R, gl)
├── gitsigns/default.nix         # Git hunks keymaps (]c, [c, <leader>gh*, gb, gS, gR, gU)
├── glance/default.nix           # LSP glance keymaps
├── grug-far/default.nix         # Search/replace keymaps (<leader>rg, rw, rW)
├── harpoon/default.nix          # File marks keymaps (<leader>Ha, He, Hj-Hm)
├── inc-rename/default.nix       # Rename keymaps (gR)
├── neo-tree/default.nix         # File explorer keymaps (<leader>E)
├── neotest/default.nix          # Testing keymaps (<leader>tt, tr, tR, td, etc.)
├── todo-comments/default.nix    # TODO finder keymaps (<leader>ft, xq)
├── trouble/default.nix          # Diagnostics keymaps (<leader>xx, xX, xl, xL, xQ, us)
├── undotree/default.nix         # Undo history keymaps (<leader>ueu)
├── snacks/
│   ├── bufdelete.nix            # Buffer close keymaps (<C-w>, <leader>bc, bC)
│   ├── gitbrowse.nix            # Git browser keymaps (<leader>go, gO, gm, gM)
│   ├── lazygit.nix              # Lazygit keymap (<leader>gg)
│   ├── notifier.nix             # Notification keymaps (<leader>un, uN)
│   ├── scratch.nix              # Scratch buffer keymaps (<leader>nn, ns)
│   ├── terminal.nix             # Terminal keymaps (<C-/>, <leader>ut)
│   ├── toggle.nix               # UI toggle keymaps (<leader>udd, udD, ues, uew, uei, ueh, uen, uaa, usd, uss, usZ, usz, utt, utr, ueo, uet, ueW)
│   ├── words.nix                # Reference navigation keymaps (]], [[)
│   ├── zen.nix                  # Zen mode keymap (<leader>uZ)
│   └── picker/
│       ├── git.nix              # Git picker keymaps (<leader>gff, gfb, gfc, gfs, gfh, gfL, gfd, gfa)
│       ├── lsp.nix              # LSP picker keymaps (gd, gD, grr, gri, gy, <leader>ld, li, lD, lt, fd, fD, fl)
│       ├── neovim.nix           # Neovim picker keymaps (<leader>fa, fc, fC, fh, fk, fL, fm, fr, fu, f', fj, X)
│       ├── search.nix           # Search picker keymaps (<leader><space>, :, fb, fe, ff, fFA, fo, fO, fp, fq, fw, fW, f/, f?, f<CR>, fZ, fz, sw)
│       └── ui.nix               # UI picker keymaps (<leader>fS, fT, f,, uC, fH)
```

### Target (Documentation)
- `/home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx`

## Step-by-Step Process

### Step 1: Find ALL Files with Keymaps
Run this grep command to find all files containing keymap definitions:
```bash
grep -rl "keymaps =" /home/ludus/Work/khanelivim/modules/nixvim --include="*.nix"
```

Also check for lazy-loaded keymaps in `lazyLoad.settings.keys`:
```bash
grep -rl "lazyLoad.settings.keys" /home/ludus/Work/khanelivim/modules/nixvim --include="*.nix"
```

And check `lz-n.plugins` for additional lazy-loaded keymaps:
```bash
grep -rl "lz-n.plugins" /home/ludus/Work/khanelivim/modules/nixvim --include="*.nix"
```

### Step 2: Extract Keymaps from Each File
For each file found, extract:
1. **key** - The keybinding (e.g., `<leader>ff`)
2. **action** - What it does
3. **options.desc** - The description
4. **mode** - The mode(s) it applies to (n, v, i, o, x, t)

Look for these patterns:
```nix
# Standard keymaps
keymaps = [
  {
    mode = "n";
    key = "<leader>ff";
    action = "...";
    options = { desc = "Find files"; };
  }
];

# Lazy-loaded keymaps
lazyLoad.settings.keys = [
  {
    __unkeyed-1 = "<leader>db";
    __unkeyed-2 = "...";
    desc = "Breakpoint toggle";
  }
];

# lz-n plugin keymaps
plugins.lz-n.plugins = [
  {
    keys = [
      {
        __unkeyed-1 = "<leader>ueu";
        __unkeyed-2 = "<cmd>UndotreeToggle<CR>";
        desc = "Undotree toggle";
      }
    ];
  }
];

# Plugin-specific keymaps (like todo-comments)
plugins.todo-comments.keymaps = { ... };
```

### Step 3: Organize Keymaps into Categories
Group keymaps into these sections (in this order):
1. **General** - Basic editing, save, quit, leader key
2. **Navigation & Windows** - Window focus, splits, resize, quickfix
3. **Buffers** - Buffer navigation and management
4. **Search (Snacks Picker)** - All `<leader>f*` and `<leader>s*` search keymaps
5. **LSP** - All `g*` and `<leader>l*` LSP keymaps
6. **Git** - All `<leader>g*` keymaps
   - Git Picker (sub-section for `<leader>gf*`)
   - Gitsigns/Hunks (sub-section for `<leader>gh*`, `]c`, `[c`)
7. **Trouble** - All `<leader>x*` keymaps
8. **Debug (DAP)** - All `<leader>d*` keymaps
9. **Testing (Neotest)** - All `<leader>t*` keymaps
10. **Harpoon** - All `<leader>H*` keymaps
11. **Search & Replace (Grug-Far)** - All `<leader>r*` keymaps
12. **Flash (Motion)** - Motion keymaps (s, S, r, R, gl)
13. **Reference Navigation** - `]]`, `[[`
14. **File Explorer** - `<leader>E`, `<leader>fe`
15. **Editing** - Move lines, indent, comment
16. **Scratch Buffers** - `<leader>nn`, `<leader>ns`
17. **UI Toggles** - All `<leader>u*` toggle keymaps
18. **Profiler** - `<leader>X`, `<leader>up*`
19. **Terminal** - `<C-/>`, `<leader>ut`

### Step 4: Format as Markdown Tables
Each section should use this format:
```markdown
## Section Name

| Key | Description | Mode |
| --- | --- | --- |
| `<leader>ff` | Find Files | Normal |
| `<leader>fw` | Live Grep | Normal |
```

Mode abbreviations:
- `Normal` for mode = "n"
- `Visual` for mode = "v"
- `Insert` for mode = "i"
- `Operator` for mode = "o"
- `Normal/Visual` for mode = ["n", "v"]
- `Normal/Visual/Op` for mode = ["n", "v", "o"] or ["n", "x", "o"]
- `Term` for mode = "t"

### Step 5: Write to Documentation File
Update `/home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx` with the complete keymap reference.

Frontmatter should be:
```yaml
---
title: Neovim
description: Keymaps and configuration for Neovim.
---
```

### Step 6: Verify Completeness
Cross-check by running:
```bash
# Count keymaps in source
grep -h "key = " /home/ludus/Work/khanelivim/modules/nixvim/**/*.nix 2>/dev/null | wc -l
grep -h "__unkeyed-1 = " /home/ludus/Work/khanelivim/modules/nixvim/**/*.nix 2>/dev/null | wc -l

# Count keymaps in documentation (approximate)
grep -c "^\| \`" /home/ludus/Dotfiles/docs/src/content/docs/neovim.mdx
```

## Important Notes

1. **Conditional Keymaps**: Many keymaps are conditional based on `config.plugins.*.enable` or `config.khanelivim.*` settings. Document these as they represent the default configuration.

2. **Lazy Loading**: Keymaps defined in `lazyLoad.settings.keys` are lazy-loaded but still active. Include them.

3. **Plugin-Specific Keymaps**: Some plugins like `todo-comments` have their own keymap syntax. Check `plugins.*.keymaps` attributes.

4. **which-key Specs**: The `which-key.settings.spec` entries define group labels but not actual keymaps. Use them for context but don't document them as keymaps.

5. **Duplicate Keys**: Some keys appear in multiple files with conditional logic (e.g., `<leader>bC` in both `keymappings.nix` and `bufdelete.nix`). Document once with the most common behavior.

// turbo-all