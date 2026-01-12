# modules/hm/programs/apps/default.nix
# Apps - Application management (flatpak, appimage, etc.)
{ ... }:

{
  imports = [
    ./flatpak.nix  # Flatpak application management
    # Future imports:
    # ./appimage.nix  # AppImage applications
    # ./snap.nix      # Snap packages (if needed)
  ];
}

