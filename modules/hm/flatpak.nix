# modules/hm/flatpak.nix
# Flatpak home-manager configuration
# Simple and direct like gitm3-hydenix
{ lib, ... }:

{
  # Configuración directa de flatpak (sin módulo wrapper)
  # Gestionado por nix-flatpak homeManagerModule
  services.flatpak = {
    # Actualizaciones automáticas
    update.auto.enable = false;
    
    # No desinstalar apps no declaradas (permite instalación manual)
    uninstallUnmanaged = false;
    
    # Lista de aplicaciones a instalar
    packages = [
      # Bottles - Ejecutar aplicaciones Windows en Linux
      # Alternativa gráfica a Wine con gestión de prefijos
      {
        appId = "com.usebottles.bottles";
        origin = "flathub";
      }
      
      # Stretchly - Recordatorios de descanso para salud postural
      # Útil para prevenir fatiga ocular y problemas de espalda
      {
        appId = "net.hovancik.Stretchly";
        origin = "flathub";
      }
    ];
    
    # Overrides de permisos específicos por app
    overrides = {
      # Bottles necesita acceso a PipeWire para audio
      "com.usebottles.bottles".Context = {
        filesystems = [
          "xdg-run/pipewire-0"
        ];
      };
    };
  };
}

