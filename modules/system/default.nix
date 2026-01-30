{ config, lib, pkgs, ... }:

{
  imports = [
    ./packages.nix              # System-level packages (VLC, etc.)
    ./ai-tools-unrestricted.nix # Sin restricciones para Cursor, VSCode, Antigravity, OpenCode
    ./flatpak.nix               # Flatpak system service and XDG portals
    ./editor-overlays.nix       # Overlay para actualizar Cursor y Antigravity desde unstable
    ./android.nix               # Configuración de Android y udev rules
    ./databases.nix             # PostgreSQL y bases de datos
    # Future modular system configurations:
    # ./audio.nix       # Audio configuration (pipewire, pulseaudio)
    # ./boot.nix        # Boot loader configuration
    # ./networking.nix  # Network configuration
    # ./security.nix    # Security settings (firewall, etc.)
  ];

  # Additional system-wide configuration can go here
}
