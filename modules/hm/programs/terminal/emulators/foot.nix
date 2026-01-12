# ════════════════════════════════════════════════════════════════════════════
# Foot - Terminal ligera para Wayland
# Terminal minimalista y rápida escrita en C
# Basado en: https://github.com/linuxmobile/kaku
# Documentación: https://codeberg.org/dnkl/foot
# ════════════════════════════════════════════════════════════════════════════
#
# Foot es una terminal Wayland-native extremadamente ligera y rápida.
# Características:
# - Muy bajo uso de recursos
# - Soporte para Sixel (imágenes en terminal)
# - Configuración simple via archivo INI
# - Scrollback configurable
#
# Uso:
#   foot              # Abrir terminal
#   foot -e comando   # Ejecutar comando
# ════════════════════════════════════════════════════════════════════════════
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.terminal.emulators.foot;
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.terminal.emulators.foot = {
    enable = mkEnableOption "Foot terminal emulator";

    font = mkOption {
      type = types.str;
      default = "JetBrainsMono Nerd Font:size=11";
      description = "Fuente principal para Foot";
      example = "Cozette:size=10";
    };

    fontSize = mkOption {
      type = types.int;
      default = 11;
      description = "Tamaño de fuente";
    };

    padding = mkOption {
      type = types.str;
      default = "10x10";
      description = "Padding interno (horizontalxvertical)";
      example = "15x6center";
    };

    cursorStyle = mkOption {
      type = types.enum ["block" "beam" "underline"];
      default = "beam";
      description = "Estilo del cursor";
    };

    cursorThickness = mkOption {
      type = types.str;
      default = "2";
      description = "Grosor del cursor (para beam/underline)";
    };

    scrollbackLines = mkOption {
      type = types.int;
      default = 10000;
      description = "Líneas de historial";
    };

    alpha = mkOption {
      type = types.float;
      default = 0.95;
      description = "Transparencia del fondo (0.0 - 1.0)";
      example = 1.0;
    };

    enableSixel = mkOption {
      type = types.bool;
      default = true;
      description = "Habilitar soporte para imágenes Sixel";
    };

    # ══════════════════════════════════════════════════════════════════════
    # Colores - Esquema de colores personalizable
    # ══════════════════════════════════════════════════════════════════════
    colors = {
      foreground = mkOption {
        type = types.str;
        default = "cdd6f4";
        description = "Color de texto (hex sin #)";
      };
      background = mkOption {
        type = types.str;
        default = "1e1e2e";
        description = "Color de fondo (hex sin #)";
      };
      # Colores normales (0-7)
      regular0 = mkOption { type = types.str; default = "45475a"; description = "Negro"; };
      regular1 = mkOption { type = types.str; default = "f38ba8"; description = "Rojo"; };
      regular2 = mkOption { type = types.str; default = "a6e3a1"; description = "Verde"; };
      regular3 = mkOption { type = types.str; default = "f9e2af"; description = "Amarillo"; };
      regular4 = mkOption { type = types.str; default = "89b4fa"; description = "Azul"; };
      regular5 = mkOption { type = types.str; default = "f5c2e7"; description = "Magenta"; };
      regular6 = mkOption { type = types.str; default = "94e2d5"; description = "Cyan"; };
      regular7 = mkOption { type = types.str; default = "bac2de"; description = "Blanco"; };
      # Colores brillantes (8-15)
      bright0 = mkOption { type = types.str; default = "585b70"; description = "Negro brillante"; };
      bright1 = mkOption { type = types.str; default = "f38ba8"; description = "Rojo brillante"; };
      bright2 = mkOption { type = types.str; default = "a6e3a1"; description = "Verde brillante"; };
      bright3 = mkOption { type = types.str; default = "f9e2af"; description = "Amarillo brillante"; };
      bright4 = mkOption { type = types.str; default = "89b4fa"; description = "Azul brillante"; };
      bright5 = mkOption { type = types.str; default = "f5c2e7"; description = "Magenta brillante"; };
      bright6 = mkOption { type = types.str; default = "94e2d5"; description = "Cyan brillante"; };
      bright7 = mkOption { type = types.str; default = "a6adc8"; description = "Blanco brillante"; };
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable {
    # Instalar Foot y dependencias
    home.packages = with pkgs; [
      foot
      libsixel  # Para soporte de imágenes Sixel
    ];

    # Configuración de Foot
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = cfg.font;
          pad = cfg.padding;
          term = "xterm-256color";
          selection-target = "both";
        };

        bell = {
          command = "${lib.getExe pkgs.libnotify} 'Terminal Bell'";
          command-focused = "no";
          notify = "yes";
          urgent = "yes";
        };

        desktop-notifications = {
          command = "${lib.getExe pkgs.libnotify} -a \${app-id} -i \${app-id} \${title} \${body}";
        };

        scrollback = {
          lines = cfg.scrollbackLines;
          multiplier = 3;
          indicator-position = "relative";
          indicator-format = "line";
        };

        url = {
          launch = "${pkgs.xdg-utils}/bin/xdg-open \${url}";
          label-letters = "sadfjklewcmpgh";
          osc8-underline = "url-mode";
        };

        cursor = {
          style = cfg.cursorStyle;
          beam-thickness = cfg.cursorThickness;
        };

        tweak = {
          font-monospace-warn = "no";
          sixel = if cfg.enableSixel then "yes" else "no";
        };

        colors = {
          alpha = cfg.alpha;
          foreground = cfg.colors.foreground;
          background = cfg.colors.background;
          # Colores normales
          regular0 = cfg.colors.regular0;
          regular1 = cfg.colors.regular1;
          regular2 = cfg.colors.regular2;
          regular3 = cfg.colors.regular3;
          regular4 = cfg.colors.regular4;
          regular5 = cfg.colors.regular5;
          regular6 = cfg.colors.regular6;
          regular7 = cfg.colors.regular7;
          # Colores brillantes
          bright0 = cfg.colors.bright0;
          bright1 = cfg.colors.bright1;
          bright2 = cfg.colors.bright2;
          bright3 = cfg.colors.bright3;
          bright4 = cfg.colors.bright4;
          bright5 = cfg.colors.bright5;
          bright6 = cfg.colors.bright6;
          bright7 = cfg.colors.bright7;
        };
      };
    };
  };
}
