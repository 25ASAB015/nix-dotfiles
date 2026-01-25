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
  toTOML = (pkgs.formats.toml {}).generate;
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
      # Configuración de Starship EXCLUSIVA para Fish (basada en omarchy)
      # ══════════════════════════════════════════════════════════════════════
      "${configFile}".source = toTOML "starship.toml" {
        add_newline = true;
        command_timeout = 200;

        format = "[$directory$git_branch$git_status]($style)$character";

        character = {
          error_symbol = "[✗](bold cyan)";
          success_symbol = "[❯](bold cyan)";
        };

        directory = {
          truncation_length = 2;
          truncation_symbol = "…/";
          repo_root_style = "bold cyan";
          repo_root_format = "[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) ";
        };

        git_branch = {
          format = "[$branch]($style) ";
          style = "italic cyan";
        };

        git_status = {
          format = "[$all_status]($style)";
          style = "cyan";
          ahead = "⇡${count} ";
          diverged = "⇕⇡${ahead_count}⇣${behind_count} ";
          behind = "⇣${count} ";
          conflicted = " ";
          up_to_date = " ";
          untracked = "? ";
          modified = " ";
          stashed = "";
          staged = "";
          renamed = "";
          deleted = "";
        };
      };

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
