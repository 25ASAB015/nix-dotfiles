# Gammastep - Ajuste automático de temperatura de color de pantalla
# Reduce luz azul en la noche para mejor salud visual y sueño
# Wayland alternative to Redshift
{ config, lib, ... }:

with lib; let
  cfg = config.modules.system.gammastep;
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.system.gammastep = {
    enable = mkEnableOption "Gammastep (color temperature adjustment)";
    
    latitude = mkOption {
      type = types.str;
      default = "13.6929";  # San Salvador, El Salvador
      description = "Latitud de tu ubicación";
    };
    
    longitude = mkOption {
      type = types.str;
      default = "-89.2182";  # San Salvador, El Salvador
      description = "Longitud de tu ubicación";
    };
    
    dayTemp = mkOption {
      type = types.int;
      default = 5700;
      description = "Temperatura de color durante el día (Kelvin)";
    };
    
    nightTemp = mkOption {
      type = types.int;
      default = 3500;
      description = "Temperatura de color durante la noche (Kelvin)";
    };
    
    tray = mkOption {
      type = types.bool;
      default = true;
      description = "Mostrar icono en la bandeja del sistema";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable {
    services.gammastep = {
      enable = true;
      
      # Temperatura de color
      temperature = {
        day = cfg.dayTemp;
        night = cfg.nightTemp;
      };
      
      # Ubicación (San Salvador, El Salvador)
      latitude = cfg.latitude;
      longitude = cfg.longitude;
      
      # Mostrar en system tray
      tray = cfg.tray;
      
      # Configuración adicional
      settings = {
        general = {
          # Ajuste gradual de temperatura
          adjustment-method = "wayland";
          
          # Elevación del sol para considerar día/noche
          # dawn: cuando sale el sol, dusk: cuando se pone
          dawn-time = "6:00";
          dusk-time = "18:00";
        };
      };
    };
    
    # Mensaje informativo en la activación
    home.activation.gammastepInfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo "✅ Gammastep configurado"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   📍 Ubicación: El Salvador"
      $DRY_RUN_CMD echo "   🌅 Día: ${toString cfg.dayTemp}K"
      $DRY_RUN_CMD echo "   🌙 Noche: ${toString cfg.nightTemp}K"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Ajusta automáticamente la temperatura de color"
      $DRY_RUN_CMD echo "   de tu pantalla según la hora del día."
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Beneficios:"
      $DRY_RUN_CMD echo "   - Reduce fatiga ocular"
      $DRY_RUN_CMD echo "   - Mejora calidad del sueño"
      $DRY_RUN_CMD echo "   - Menos luz azul en la noche"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}

