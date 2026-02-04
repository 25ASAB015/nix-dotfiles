# Hosts Configuration

This directory contains configurations for multiple NixOS hosts (machines).

## Structure

```
hosts/
├── default.nix       # Shared configuration (all hosts inherit this)
├── hydenix/          # Main desktop PC (active)
├── vm/               # VM template
└── laptop/           # Laptop template
```

## Adding a New Host

### 1. Create Host Directory

```bash
mkdir -p hosts/my-new-host
```

### 2. Create Configuration Files

Create three files in your new host directory:

#### `configuration.nix`
```nix
{ inputs, pkgs, ... }:
{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
    ./user.nix
    # Add hardware-specific modules here
  ];

  hydenix = {
    hostname = "my-new-host";
    timezone = "America/El_Salvador";
    locale = "en_US.UTF-8";
  };

  system.stateVersion = "25.05";
}
```

#### `user.nix`
```nix
{ inputs, pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    
    users."your-username" = { ... }: {
      imports = [
        inputs.hydenix.homeModules.default
        ../../modules/hm
      ];
    };
  };

  users.users.your-username = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" "networkmanager" "video" ];
    shell = pkgs.zsh;
  };
}
```

#### `hardware-configuration.nix`
Generate this automatically:
```bash
sudo nixos-generate-config --show-hardware-config > hosts/my-new-host/hardware-configuration.nix
```

### 3. Update flake.nix

Add your new host to `flake.nix`:

```nix
outputs = { ... }@inputs:
let
  # Your existing hosts...
  
  # New host
  myNewHostConfig = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [ ./hosts/my-new-host/configuration.nix ];
  };
in
{
  nixosConfigurations = {
    hydenix = hydenixConfig;
    vm = vmConfig;
    my-new-host = myNewHostConfig; # Add this line
  };
};
```

### 4. Build and Switch

```bash
# Test the configuration
sudo nixos-rebuild test --flake .#my-new-host

# Apply the configuration
sudo nixos-rebuild switch --flake .#my-new-host
```

## Host-Specific Configurations

### Desktop PC (hydenix)
- Full Hydenix desktop environment
- Gaming optimizations available
- Intel CPU + SSD

### VM (template)
- QEMU guest additions
- Reduced resource usage
- No gaming features
- Template only - customize before use

### Laptop (template)
- TLP power management
- Touchpad configuration
- Backlight control
- Battery optimization
- WiFi management
- Template only - customize before use

## Shared Configuration

All hosts inherit from `default.nix`:
- Common Nix settings
- Base system packages
- NetworkManager
- Experimental features (flakes, nix-command)

## Tips

### 1. Minimal Differences
Keep host-specific files minimal. Put shared configuration in:
- `hosts/default.nix` - System-wide shared
- `modules/hm/` - User-level shared

### 2. Hardware Modules
Use nixos-hardware modules for common hardware:
```nix
imports = [
  inputs.nixos-hardware.nixosModules.common-cpu-intel
  inputs.nixos-hardware.nixosModules.common-pc-ssd
  inputs.nixos-hardware.nixosModules.common-pc-laptop # For laptops
];
```

### 3. Per-Host Packages
Add host-specific packages in the host's `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # Host-specific packages here
];
```

### 4. Testing
Always test before switching:
```bash
# Dry run (no changes)
sudo nixos-rebuild dry-run --flake .#hostname

# Build without switching
sudo nixos-rebuild build --flake .#hostname

# Test (temporary, doesn't survive reboot)
sudo nixos-rebuild test --flake .#hostname

# Switch (permanent)
sudo nixos-rebuild switch --flake .#hostname
```

## Examples

### Clone Hydenix Configuration for New PC
```bash
cp -r hosts/hydenix hosts/new-pc
cd hosts/new-pc
# Edit configuration.nix and change hostname
# Generate new hardware-configuration.nix on the new PC
# Update user.nix if username is different
```

### Create VM from Template
```bash
cp -r hosts/vm hosts/test-vm
cd hosts/test-vm
# Edit configuration.nix
# Generate hardware config in VM
# Update flake.nix
```

## Makefile Integration

The Makefile is configured for the default host (`hydenix`). To use with other hosts:

```bash
# Override hostname
HOSTNAME=my-new-host make switch

# Or edit Makefile and change:
HOSTNAME := my-new-host
```

## Documentation

- Main README: `../README.md`
- Analysis: `../ANALYSIS.md`
- Migration tracking: `../AGENTS.md`

