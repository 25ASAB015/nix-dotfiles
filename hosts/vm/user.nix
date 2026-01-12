# hosts/vm/user.nix
# User configuration for VM
# Customize username and settings for your VM
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
    users."vm-user" = { ... }: {
      imports = [
        inputs.hydenix.homeModules.default
        ../../modules/hm # Custom home-manager modules
      ];
    };
  };

  # User Account Setup - CHANGE THIS USERNAME (must match above)
  users.users.vm-user = {
    isNormalUser = true;
    initialPassword = "vm"; # SECURITY: Change this password after first login
    extraGroups = [
      "wheel"           # Sudo access
      "networkmanager"  # Network management
      "video"           # Display/graphics access
    ];
    shell = pkgs.zsh; # Default shell
  };
}

