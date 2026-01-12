# Flatpak - Gestor de aplicaciones en sandbox
# Documentación: https://flatpak.org/
# Integrado desde gitm3-hydenix
{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.modules.apps.flatpak;
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.apps.flatpak = {
    enable = mkEnableOption "Flatpak application management";
    
    autoUpdate = mkOption {
      type = types.bool;
      default = false;
      description = "Habilitar actualizaciones automáticas de flatpaks";
    };
    
    uninstallUnmanaged = mkOption {
      type = types.bool;
      default = false;
      description = "Desinstalar flatpaks no declarados en la configuración";
    };
    
    packages = mkOption {
      type = types.listOf (types.submodule {
        options = {
          appId = mkOption {
            type = types.str;
            description = "Application ID from Flathub";
          };
          origin = mkOption {
            type = types.str;
            default = "flathub";
            description = "Remote origin (usually flathub)";
          };
        };
      });
      default = [];
      description = "Lista de aplicaciones flatpak a instalar";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable {
    services.flatpak = {
      # Auto-actualización de flatpaks
      update.auto.enable = cfg.autoUpdate;
      
      # Desinstalar flatpaks no declarados (limpieza automática)
      uninstallUnmanaged = cfg.uninstallUnmanaged;
      
      # Lista de paquetes a instalar
      packages = cfg.packages;
      
      # Overrides para permisos específicos por app
      # Ejemplo: dar acceso a PipeWire para audio
      overrides = {
        # Bottles: Windows app runner
        "com.com.usebottles.bottles".Context = mkIf 
          (any (pkg: pkg.appId == "com.com.usebottles.bottles") cfg.packages)
          {
            filesystems = [
              "xdg-run/pipewire-0"  # Acceso a audio PipeWire
            ];
          };
      };
    };
    
    # Mensaje informativo en la activación
    home.activation.flatpakInfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo "✅ Flatpak configurado"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Aplicaciones a instalar: ${toString (length cfg.packages)}"
      ${if cfg.autoUpdate then ''
        $DRY_RUN_CMD echo "   Auto-actualización: ✅ Habilitada"
      '' else ''
        $DRY_RUN_CMD echo "   Auto-actualización: ❌ Deshabilitada"
      ''}
      ${if cfg.uninstallUnmanaged then ''
        $DRY_RUN_CMD echo "   Limpieza automática: ✅ Habilitada"
      '' else ''
        $DRY_RUN_CMD echo "   Limpieza automática: ❌ Deshabilitada"
      ''}
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Comandos útiles:"
      $DRY_RUN_CMD echo "   - flatpak list               # Ver instalados"
      $DRY_RUN_CMD echo "   - flatpak search <app>       # Buscar apps"
      $DRY_RUN_CMD echo "   - flatpak update             # Actualizar manualmente"
      $DRY_RUN_CMD echo "   - flatpak run <app-id>       # Ejecutar app"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Más info: https://flatpak.org/"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}

