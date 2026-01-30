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
    backupFileExtension = "hm-bak";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    
    # User Configuration for ludus
    users."ludus" = { pkgs, inputs, ... }: {
      imports = [
        inputs.hydenix.homeModules.default
        inputs.nix-flatpak.homeManagerModules.nix-flatpak  # Flatpak declarative management
        ../../modules/hm # Custom home-manager modules (configure hydenix.hm here!)
      ];
      
      # Use khanelivim as neovim package (replaces default nvim)
      home.packages = [
        inputs.khanelivim.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.openspec.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code
        inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.gemini-cli
      ];
      
      # Set as default editor
      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
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

