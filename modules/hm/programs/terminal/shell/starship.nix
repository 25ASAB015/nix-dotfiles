# Starship - Prompt para Fish (separado de zsh/Hydenix)
# IMPORTANTE: Esta configuración es EXCLUSIVA para Fish shell.
# No afecta la configuración de Starship de zsh/Hydenix.
# Basado en omarchy: /home/ludus/Work/omarchy/config/starship.toml
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.terminal.shell.starship;
  configFile = "starship/fish.toml";  # Archivo separado para Fish (zsh usa starship.toml de Hydenix)
in {
  options.modules.terminal.shell.starship = {
    enable = lib.mkEnableOption "Starship prompt para Fish (separado de zsh)";

    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración automática con Fish";
    };
  };

  config = lib.mkIf cfg.enable {
    # Starship ya está instalado por Hydenix, no necesitamos instalarlo
    # NOTA: No usamos home.sessionVariables porque afectaría a zsh también
    # En su lugar, configuramos STARSHIP_CONFIG solo en fish/conf.d/starship.fish

    xdg.configFile = {
      # ══════════════════════════════════════════════════════════════════════
      # Configuración de Starship EXCLUSIVA para Fish (copiada de omarchy)
      # ══════════════════════════════════════════════════════════════════════
      "${configFile}".source = ../../../../../resources/config/fish-starship.toml;

      # ══════════════════════════════════════════════════════════════════════
      # Integración con Fish (usa config separada de zsh)
      # ══════════════════════════════════════════════════════════════════════
      "fish/conf.d/starship.fish" = lib.mkIf cfg.enableFishIntegration {
        text = ''
          # Inicializar Starship prompt
          # Las variables de entorno (STARSHIP_CONFIG, etc.) se configuran en shellInit
          # para asegurar que estén disponibles antes de inicializar
          if type -q starship
            starship init fish | source
          end
        '';
      };

      "fish/completions/starship.fish".source = "${pkgs.starship}/share/fish/vendor_completions.d/starship.fish";
    };
  };
}
