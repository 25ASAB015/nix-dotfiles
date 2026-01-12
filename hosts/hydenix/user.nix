# hosts/hydenix/user.nix
# User configuration for ludus on hydenix host
{
  inputs,
  pkgs,
  ...
}:

{
  # Home Manager Configuration - manages user-specific configurations (dotfiles, themes, etc.)
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    
    # User Configuration for ludus
    users."ludus" = { ... }: {
      imports = [
        inputs.hydenix.homeModules.default
        inputs.nix-flatpak.homeManagerModules.nix-flatpak  # Flatpak declarative management
        inputs.nixvim.homeModules.default                  # Nixvim - Neovim configuration (renamed from homeManagerModules)
        ../../modules/hm # Custom home-manager modules (configure hydenix.hm here!)
      ];
    };
  };

  # User Account Setup for ludus
  users.users.ludus = {
    isNormalUser = true;
    initialPassword = "0394661280"; # SECURITY: Change this password after first login with `passwd`
    extraGroups = [
      # ── Core System Access ──────────────────────────────────────────────────
      "wheel"           # Sudo access
      "networkmanager"  # Network management
      "video"           # Display/graphics access
      
      # ── Audio ───────────────────────────────────────────────────────────────
      "audio"           # Audio devices access
      "pipewire"        # PipeWire audio system
      "rtkit"           # Real-time priority for low-latency audio
      
      # ── Hardware/Devices ────────────────────────────────────────────────────
      "dialout"         # Serial ports (Arduino, USB devices, etc.)
      "plugdev"         # USB devices and peripherals
      
      # ── Containers/Virtualization ───────────────────────────────────────────
      "docker"          # Docker without sudo
      "libvirtd"        # KVM/QEMU virtualization (if using virt-manager)
    ];
    shell = pkgs.zsh; # Default shell (options: pkgs.bash, pkgs.zsh, pkgs.fish)
  };

  # Nix Settings - Trust user for binary caches and faster builds
  nix.settings.trusted-users = [
    "root"
    "ludus"
  ];
}

