# hosts/laptop/user.nix
# User configuration for laptop
# Customize username and settings for your laptop
{
  inputs,
  pkgs,
  ...
}:

{
  # Home Manager Configuration
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    
    # User Configuration - CHANGE THIS USERNAME
    users."ravn" = { ... }: {
      imports = [
        inputs.hydenix.homeModules.default
        ../../modules/hm # Custom home-manager modules
      ];
    };
  };

  # User Account Setup - CHANGE THIS USERNAME (must match above)
  users.users.ravn = {
    isNormalUser = true;
    initialPassword = "laptop"; # SECURITY: Change this password after first login
    extraGroups = [
      "wheel"           # Sudo access
      "networkmanager"  # Network management
      "video"           # Display/graphics access
      "audio"           # Audio access
    ];
    shell = pkgs.zsh; # Default shell
  };
}

