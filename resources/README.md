# Resources Folder

This directory contains **mutable configurations and resources** that are not Nix code. These files are designed to be edited directly without requiring a system rebuild after the initial setup.

## Philosophy

This folder enables a **hybrid approach** to system configuration:

- **Immutable (Nix)**: For stable, complex configurations managed declaratively
- **Mutable (Resources)**: For files you edit frequently or prefer as plain text files

After the first `make sys-apply`, edits in `resources/` take effect immediately without needing to rebuild the system.

## Structure

```
resources/
├── config/         # Plain text configuration files
│   ├── keybinds.conf    # Hyprland keybindings
│   ├── kitty.conf      # Terminal emulator config
│   ├── monitors.conf   # Monitor layout configuration
│   └── .zshrc_extra    # Zsh aliases and exports (if using Zsh)
├── scripts/       # Utility scripts (bash, python, etc.)
└── wallpapers/    # Wallpaper images for themes
```

## Quick Start

If you're just getting started or want to make quick changes, start here:

1. **Keybinds**: `resources/config/keybinds.conf` - Customize window manager shortcuts
2. **Scripts**: `resources/scripts/` - Add utility scripts and launchers
3. **Terminal**: `resources/config/kitty.conf` - Terminal appearance and behavior
4. **Monitors**: `resources/config/monitors.conf` - Display layout configuration

## Configuration Files

### Keybinds (`config/keybinds.conf`)

Hyprland keybindings that override the default configuration. Edit this file to customize your window management shortcuts.

**Location in system**: Managed by `modules/hm/keybinds.nix`

### Terminal (`config/kitty.conf`)

Kitty terminal emulator configuration. Customize colors, fonts, window behavior, and more.

### Monitors (`config/monitors.conf`)

Monitor layout and display configuration. Define resolutions, positions, and scaling for your displays.

### Shell Extras (`config/.zshrc_extra`)

If you're using Zsh, this file contains personal aliases and exports that don't need to be in Nix modules.

## Scripts

Utility scripts that you want available system-wide. Scripts in `resources/scripts/` are automatically made available through the script launcher.

**Example script structure:**
```bash
#!/usr/bin/env bash
# resources/scripts/my-script.sh
# Your script content here
```

Scripts are integrated via `modules/hm/keybinds.nix` and can be launched through the keybind system.

## Wallpapers

Wallpaper images for Hydenix themes. Place your custom wallpapers here and reference them in your theme configuration.

**Example usage:**
```nix
home.activation.copyWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
  cp ${../../resources/wallpapers/my-wallpaper.png} \
     "$HOME/.config/hyde/themes/My Theme/wallpapers/"
'';
```

## Integration with Nix

Resources are integrated into the Nix configuration through Home Manager modules. The main integration point is:

- **Module**: `modules/hm/keybinds.nix` - Handles keybinds, scripts, and resource management

### Custom Integration Example

To integrate a custom resource file:

```nix
# In a Home Manager module
home.file.".config/my-app/config.conf" = lib.mkForce {
  source = ../../resources/config/my-app/config.conf;
};
```

For executable scripts:

```nix
home.file.".local/bin/my-script.sh" = {
  source = ../../resources/scripts/my-script.sh;
  executable = true;
};
```

## Workflow

1. **Initial Setup**: Run `make sys-apply` once to set up the resources
2. **Edit Resources**: Modify files in `resources/` directly
3. **No Rebuild Needed**: Changes take effect immediately (after initial setup)
4. **Version Control**: All changes are tracked in git

## Best Practices

- **Use resources for**: Frequently edited configs, personal preferences, quick tweaks
- **Use Nix for**: Complex configurations, package management, system-wide settings
- **Keep it organized**: Follow the directory structure to maintain clarity
- **Document custom scripts**: Add comments explaining what your scripts do

## Related Documentation

- Main README: `../README.md`
- User Manual: `../docs/src/content/docs/index.mdx`
- Configuration Analysis: `../ANALYSIS.md` (if exists)
