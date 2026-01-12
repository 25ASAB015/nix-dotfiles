# hosts/vm/configuration.nix
# VM host configuration (template)
# Copy this template and customize for your VM
{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ../default.nix # Shared configuration for all hosts
    ./hardware-configuration.nix # VM hardware config
    ./user.nix # VM user configuration

    # Hardware Configuration - VM-specific
    inputs.nixos-hardware.nixosModules.common-cpu-intel # Adjust based on VM host CPU
  ];

  # Hydenix Configuration - VM-specific
  hydenix = {
    hostname = "hydenix-vm"; # Change this for your VM
    timezone = "America/El_Salvador"; # Adjust as needed
    locale = "en_US.UTF-8";
  };

  # VM-specific settings
  services.qemuGuest.enable = true; # Enable QEMU guest additions
  services.spice-vdagentd.enable = true; # For better VM integration

  # Reduced resource usage for VM
  hydenix.gaming.enable = false; # Disable gaming optimizations in VM
  
  # System Version
  system.stateVersion = "25.05";
}

