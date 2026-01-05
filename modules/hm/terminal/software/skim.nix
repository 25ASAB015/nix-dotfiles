# ════════════════════════════════════════════════════════════════════════════
# Skim - Fuzzy Finder escrito en Rust
# Alternativa a fzf con mejor rendimiento
# Basado en: https://github.com/linuxmobile/kaku
# Documentación: https://github.com/lotabout/skim
# ════════════════════════════════════════════════════════════════════════════
#
# Skim es un buscador fuzzy de línea de comandos escrito en Rust.
# Similar a fzf pero con algunas mejoras de rendimiento.
#
# Uso:
#   sk                    # Buscar archivos
#   sk --preview "cat {}" # Con preview
#   Ctrl+T                # Buscar archivos (Fish integration)
#   Ctrl+R                # Buscar en historial (Fish integration)
#   Alt+C                 # Cambiar directorio (Fish integration)
# ════════════════════════════════════════════════════════════════════════════
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.terminal.software.skim;
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.terminal.software.skim = {
    enable = mkEnableOption "Skim fuzzy finder";

    enableFishIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Habilitar integración con Fish shell (Ctrl+T, Ctrl+R, Alt+C)";
    };

    enableBashIntegration = mkOption {
      type = types.bool;
      default = false;
      description = "Habilitar integración con Bash";
    };

    enableZshIntegration = mkOption {
      type = types.bool;
      default = false;
      description = "Habilitar integración con Zsh";
    };

    defaultCommand = mkOption {
      type = types.str;
      default = "rg --files --hidden";
      description = "Comando por defecto para listar archivos";
      example = "fd --type f --hidden --follow --exclude .git";
    };

    defaultOptions = mkOption {
      type = types.listOf types.str;
      default = [
        "--height 40%"
        "--layout=reverse"
        "--border"
      ];
      description = "Opciones por defecto de skim";
    };

    fileWidgetCommand = mkOption {
      type = types.nullOr types.str;
      default = "rg --files --hidden";
      description = "Comando para el widget de archivos (Ctrl+T)";
    };

    fileWidgetOptions = mkOption {
      type = types.listOf types.str;
      default = [
        "--preview 'bat --color=always --style=numbers --line-range=:500 {} 2>/dev/null || cat {}'"
      ];
      description = "Opciones para el widget de archivos";
    };

    changeDirWidgetCommand = mkOption {
      type = types.nullOr types.str;
      default = "fd --type d --hidden --follow --exclude .git";
      description = "Comando para el widget de directorios (Alt+C)";
    };

    changeDirWidgetOptions = mkOption {
      type = types.listOf types.str;
      default = [
        "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
      description = "Opciones para el widget de directorios";
    };

    historyWidgetOptions = mkOption {
      type = types.listOf types.str;
      default = [
        "--tac"
        "--exact"
      ];
      description = "Opciones para el widget de historial (Ctrl+R)";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable {
    # Dependencias recomendadas para mejor experiencia
    home.packages = with pkgs; [
      ripgrep  # Para defaultCommand
      fd       # Para changeDirWidgetCommand
      eza      # Para preview de directorios
      bat      # Para preview de archivos
    ];

    programs.skim = {
      enable = true;
      enableFishIntegration = cfg.enableFishIntegration;
      enableBashIntegration = cfg.enableBashIntegration;
      enableZshIntegration = cfg.enableZshIntegration;
      defaultCommand = cfg.defaultCommand;
      defaultOptions = cfg.defaultOptions;
      fileWidgetCommand = cfg.fileWidgetCommand;
      fileWidgetOptions = cfg.fileWidgetOptions;
      changeDirWidgetCommand = cfg.changeDirWidgetCommand;
      changeDirWidgetOptions = cfg.changeDirWidgetOptions;
      historyWidgetOptions = cfg.historyWidgetOptions;
    };
  };
}
