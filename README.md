<img align="right" width="75px" alt="NixOS" src="https://github.com/HyDE-Project/HyDE/blob/master/Source/assets/nixos.png?raw=true"/>

# Ludus's NixOS Configuration

Personal NixOS configuration based on [Hydenix](https://github.com/richen604/hydenix) with a professional, organized structure.

## ✨ Features

- 🎨 **Hyprland** desktop environment via Hydenix
- 🐚 **Fish shell** with custom prompt (Starship)
- 🔧 **40+ Make commands** for easy management
- 📁 **Multi-host support** ready for 3 PCs + VMs
- 🤖 **AI-powered terminal** (OpenCode with Claude/Gemini)
- 🎯 **Modular structure** inspired by top community configs

## 🚀 Quick Start

```bash
# Clone this repo
git clone https://github.com/25ASAB015/nix-dotfiles ~/dotfiles
cd ~/dotfiles

# Generate hardware config
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# Build and switch
make switch

# Or manually:
sudo nixos-rebuild switch --flake .#hydenix
```

## 📁 Structure

```
dotfiles/
├── flake.nix              # Flake entry point
├── Makefile               # 40+ management commands
├── ANALYSIS.md            # Comparative analysis of Hydenix configs
├── AGENTS.md              # Migration progress tracking
│
├── hosts/                 # Multi-host configurations
│   ├── default.nix        # Shared configuration
│   └── hydenix/           # Main desktop PC
│       ├── configuration.nix
│       └── user.nix       # User ludus config
│
├── modules/
│   ├── hm/                # Home Manager modules
│   │   ├── default.nix    # Main imports
│   │   ├── hydenix-config.nix  # All modules.* configurations
│   │   └── programs/      # Organized by category
│   │       ├── terminal/  # Terminal: emulators, shell, CLI tools
│   │       ├── browsers/  # Web browsers
│   │       └── development/ # Dev tools & languages
│   │
│   └── system/            # System-level modules
│       ├── default.nix
│       └── packages.nix   # System packages (VLC, etc.)
│
├── resources/             # Mutable configs & assets
│   ├── config/            # Plain text configs
│   ├── scripts/           # Utility scripts
│   └── wallpapers/        # Theme backgrounds
│
└── docs/                  # Hydenix documentation
```

## 🎯 Key Files

| File | Purpose |
|------|---------|
| `flake.nix` | Flake inputs and outputs |
| `Makefile` | Management commands (try `make help`) |
| `hosts/hydenix/configuration.nix` | Main system config |
| `hosts/hydenix/user.nix` | User ludus configuration |
| `modules/hm/hydenix-config.nix` | All program configurations |
| `modules/system/packages.nix` | System-level packages |
| `hardware-configuration.nix` | Hardware-specific (auto-generated) |

## 🛠️ Makefile Commands

```bash
make help              # Show all available commands
make switch            # Build and switch configuration
make test              # Test configuration without switching
make update            # Update flake inputs
make clean             # Clean old generations (30 days)
make backup            # Backup current configuration
make rollback          # Rollback to previous generation
make test-network      # Run network diagnostics
make progress          # Show migration progress
```

See `make help` for all 40+ commands!

## 📦 Installed Software

### Terminal Tools
- **Emulators:** Foot, Ghostty
- **Shell:** Fish + Starship prompt (separated from Hydenix's ZSH)
- **Git:** git + delta (beautiful diffs) + lazygit (TUI) + gh (GitHub CLI)
- **CLI Tools:** eza, fzf, ripgrep, bat, bottom, yazi, atuin, zoxide
- **AI:** OpenCode with Claude/Gemini/GPT support

### Development
- Programming languages configured via `modules/hm/programs/development/languages.nix`

### Browsers
- Configured via `modules/hm/programs/browsers/`
- Zen Browser support

### Media
- VLC (system-level)

## 🔧 Configuration Philosophy

### Hybrid Approach
- **Immutable (Nix)**: Stable, complex configurations
- **Mutable (Resources)**: Frequently-edited configs in `resources/`

### Modular Design
- Each tool/program has its own module with options
- Easy to enable/disable features
- Well-documented inline comments in Spanish

### Multi-host Ready
- `hosts/` structure supports multiple machines
- Shared config in `hosts/default.nix`
- Per-host overrides in `hosts/<hostname>/`

## 📖 Documentation

| Document | Description |
|----------|-------------|
| [`ANALYSIS.md`](./ANALYSIS.md) | Comparative analysis of 3 Hydenix configs |
| [`AGENTS.md`](./AGENTS.md) | Migration progress & task tracking |
| [`resources/README.md`](./resources/README.md) | How to use resources folder |
| [`docs/`](./docs/) | Full Hydenix documentation |

## 🎨 Customization

### Add a New Package
```nix
# For system-wide: modules/system/packages.nix
environment.systemPackages = [ pkgs.your-package ];

# For user-only: modules/hm/hydenix-config.nix or create new module
```

### Add a New Host
```bash
# 1. Create host directory
mkdir -p hosts/laptop

# 2. Create configuration.nix
cp hosts/hydenix/configuration.nix hosts/laptop/

# 3. Edit and customize for that machine

# 4. Update flake.nix to add the new host
```

### Customize Existing Module
Edit `modules/hm/hydenix-config.nix` and find the module you want to change.
All configurations use the `modules.*` pattern with clear comments.

## 🚀 Upgrading

```bash
# Update hydenix
make update-hydenix

# Update all inputs
make update

# Update and rebuild
make upgrade
```

## 💾 Backup & Rollback

```bash
# Backup current config
make backup

# List previous generations
make list-generations

# Rollback to previous
make rollback
```

## 🐛 Troubleshooting

```bash
# Check flake syntax
make check-syntax

# Debug build with full trace
make debug

# Emergency rebuild with max verbosity
make emergency
```

See [`docs/troubleshooting.md`](./docs/troubleshooting.md) for more help.

## 🤝 Contributing

This is a personal configuration, but feel free to:
- Fork and adapt for your own use
- Open issues for questions
- Submit PRs for improvements

See the [comparative analysis](./ANALYSIS.md) to understand the design decisions.

## 📝 License

MIT - Feel free to use, modify, and distribute.

## 🙏 Acknowledgments

- [Hydenix](https://github.com/richen604/hydenix) by @richen604
- [Kaku](https://github.com/linuxmobile/kaku) by @linuxmobile - Inspiration for modular structure
- Community configs analyzed in `ANALYSIS.md`

## 🔗 Links

- [Hydenix Documentation](https://github.com/richen604/hydenix/tree/main/docs)
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyde Discord](https://discord.gg/AYbJ9MJez7)
