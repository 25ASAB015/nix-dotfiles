# hosts/laptop/configuration.nix
# Laptop host configuration (template)
# Copy this template and customize for your laptop
{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../default.nix # Shared configuration for all hosts
    ./hardware-configuration.nix # Laptop hardware config
    ./user.nix # Laptop user configuration

    # Hardware Configuration - Laptop-specific
    # UNCOMMENT and adjust based on your laptop hardware:
    # inputs.nixos-hardware.nixosModules.common-cpu-intel # or common-cpu-amd
    # inputs.nixos-hardware.nixosModules.common-gpu-intel # or common-gpu-nvidia/amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop # Laptop optimizations
    # inputs.nixos-hardware.nixosModules.common-hidpi # For high-DPI displays
    inputs.nixos-hardware.nixosModules.common-pc-ssd # SSD storage
  ];

  # Hydenix Configuration - Laptop-specific
  hydenix = {
    hostname = "hydenix-laptop"; # Change this for your laptop
    timezone = "America/El_Salvador"; # Adjust as needed
    locale = "en_US.UTF-8";
  };

  # Laptop-specific settings
  
  # Power management
  services.tlp = {
    enable = true; # Battery optimization
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      
      # Prevent battery from charging above 80% (extends battery life)
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # Touchpad support
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      naturalScrolling = true; # macOS-style scrolling
      disableWhileTyping = true;
    };
  };

  # Backlight control
  programs.light.enable = true;

  # Laptop-specific optimizations
  services.upower.enable = true; # Battery status monitoring
  powerManagement = {
    enable = true;
    powertop.enable = true; # Power consumption analysis
  };

  # System Version
  system.stateVersion = "25.05";
}

