# modules/system/flatpak.nix
# Flatpak system-level configuration (simple como gitm3-hydenix)
{ ... }:

{
  # Habilitar Flatpak a nivel del sistema
  # nix-flatpak maneja el resto automáticamente
  services.flatpak.enable = true;
}

