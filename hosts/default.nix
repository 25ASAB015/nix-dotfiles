# hosts/default.nix
# Shared configuration for all hosts
# This file contains common settings that apply to every machine
{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # Common imports for all hosts
  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    inputs.hydenix.nixosModules.default
    ../modules/system # Custom system modules
  ];

  # Common Hydenix settings
  hydenix = {
    enable = true;
    # Common locale (can be overridden per-host)
    locale = lib.mkDefault "en_US.UTF-8";
  };

  # Common system packages (available on all hosts)
  environment.systemPackages = with pkgs; [
    # Essential tools
    git
    wget
    curl
    vim
    
    # System tools
    htop
    btop
    
    # Network tools
    networkmanagerapplet
  ];

  # Common Nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
    
    # Garbage collection (can be overridden per-host)
    gc = {
      automatic = lib.mkDefault false; # Disabled by default, enable per-host
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };

  # Common networking
  networking = {
    networkmanager.enable = true;
  };

  # System version
  system.stateVersion = lib.mkDefault "25.05";
}

