# Direnv - Carga variables de entorno automáticamente por directorio
# Documentación: https://direnv.net/
# Uso: Crea un archivo .envrc en tu proyecto con: use nix
{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.modules.development.direnv;
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.development.direnv = {
    enable = mkEnableOption "Direnv con nix-direnv integration";
    
    enableFishIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };
    
    enableZshIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Habilitar integración con Zsh shell";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      
      # nix-direnv: cachea nix shells para mejor rendimiento
      # Sin esto, direnv reconstruye el entorno cada vez
      nix-direnv.enable = true;
      
      # Integración con shells
      enableFishIntegration = cfg.enableFishIntegration && config.programs.fish.enable;
      enableZshIntegration = cfg.enableZshIntegration;
      
      # Configuración adicional
      config = {
        global = {
          # Warn si .envrc no está permitido
          warn_timeout = "5m";
          
          # Carga automática más rápida
          load_dotenv = true;
        };
      };
    };
    
    # Mensaje informativo en la activación
    home.activation.direnvInfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo "✅ Direnv instalado y configurado"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Integración habilitada:"
      ${if cfg.enableFishIntegration && config.programs.fish.enable then ''
        $DRY_RUN_CMD echo "   - 🐟 Fish shell"
      '' else ""}
      ${if cfg.enableZshIntegration then ''
        $DRY_RUN_CMD echo "   - 🐚 Zsh shell"
      '' else ""}
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Uso:"
      $DRY_RUN_CMD echo "   1. En tu proyecto: echo 'use nix' > .envrc"
      $DRY_RUN_CMD echo "   2. Permitir: direnv allow"
      $DRY_RUN_CMD echo "   3. Entrar al directorio → carga automática"
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Más info: https://direnv.net/"
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}

