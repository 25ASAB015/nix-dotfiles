# modules/system/packages.nix
# System-level packages available to all users
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ════════════════════════════════════════════════════════════════════════════
    # MEDIA
    # ════════════════════════════════════════════════════════════════════════════
    vlc              # Media player
    
    # ════════════════════════════════════════════════════════════════════════════
    # FUTURE PACKAGES
    # ════════════════════════════════════════════════════════════════════════════
    # Add more system-level packages here as needed
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];
}

