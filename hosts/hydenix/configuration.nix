# hosts/hydenix/configuration.nix
# Main configuration for hydenix host (desktop PC)
{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../default.nix # Shared configuration for all hosts
    ../../hardware-configuration.nix # Auto-generated hardware config
    ./user.nix # User configuration for ludus

    # Hardware Configuration - Specific to this machine
    # Run `lshw -short` or `lspci` to identify your hardware

    # CPU Configuration
    inputs.nixos-hardware.nixosModules.common-cpu-intel # Intel CPUs

    # Additional Hardware Modules
    inputs.nixos-hardware.nixosModules.common-pc-ssd # SSD storage
  ];

  # If enabling NVIDIA in the future, configure here:
  # hardware.nvidia = {
  #   open = true; # For newer cards, you may want open drivers
  #   prime = { # For hybrid graphics (laptops), configure PRIME:
  #     amdBusId = "PCI:0:2:0"; # Run `lspci | grep VGA` to get correct bus IDs
  #     intelBusId = "PCI:0:2:0"; # if you have intel graphics
  #     nvidiaBusId = "PCI:1:0:0";
  #     offload.enable = false; # Or disable PRIME offloading if you don't care
  #   };
  # };

  # Hydenix Configuration - Specific to this host
  hydenix = {
    # Basic System Settings
    hostname = "hydenix"; # Computer's network name
    timezone = "America/El_Salvador"; # Timezone
    locale = "en_US.UTF-8"; # Locale/language
    
    # For more configuration options, see: ../../docs/options.md
  };

  # System Version
  system.stateVersion = "25.05";
}

