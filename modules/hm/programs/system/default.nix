# modules/hm/programs/system/default.nix
# System utilities and services
{ ... }:

{
  imports = [
    ./gammastep.nix  # Color temperature adjustment for better eye health
    # Future imports:
    # ./dunst.nix      # Notification daemon
    # ./clipboard.nix  # Clipboard manager
  ];
}

