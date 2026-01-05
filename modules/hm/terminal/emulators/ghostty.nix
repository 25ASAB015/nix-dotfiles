# ════════════════════════════════════════════════════════════════════════════
# Ghostty - Terminal moderna y rápida
# Emulador de terminal escrito en Zig con GPU rendering
# Basado en: https://github.com/linuxmobile/kaku
# Documentación: https://ghostty.org/docs
# ════════════════════════════════════════════════════════════════════════════
#
# Ghostty es una terminal moderna con renderizado GPU y excelente rendimiento.
# Características:
# - Renderizado GPU para rendimiento suave
# - Splits nativos y tabs
# - Ligatures y font features
# - Altamente configurable
#
# Uso:
#   ghostty           # Abrir terminal
#   Ctrl+Shift+V      # Nueva split vertical
#   Ctrl+Shift+S      # Nueva split horizontal
#   Alt+N             # Nueva tab
# ════════════════════════════════════════════════════════════════════════════
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.terminal.emulators.ghostty;
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.terminal.emulators.ghostty = {
    enable = mkEnableOption "Ghostty terminal emulator";

    font = mkOption {
      type = types.str;
      default = "JetBrainsMono Nerd Font";
      description = "Familia de fuente";
      example = "Cozette";
    };

    fontSize = mkOption {
      type = types.int;
      default = 12;
      description = "Tamaño de fuente";
    };

    fontFeatures = mkOption {
      type = types.str;
      default = "calt,liga";
      description = "Features de fuente (ligatures, etc.)";
      example = "calt,dlig,fina,ss13,ss15";
    };

    cursorStyle = mkOption {
      type = types.enum ["block" "bar" "underline"];
      default = "bar";
      description = "Estilo del cursor";
    };

    cursorBlink = mkOption {
      type = types.bool;
      default = true;
      description = "Cursor parpadeante";
    };

    paddingX = mkOption {
      type = types.int;
      default = 10;
      description = "Padding horizontal";
    };

    paddingY = mkOption {
      type = types.int;
      default = 6;
      description = "Padding vertical";
    };

    scrollbackLimit = mkOption {
      type = types.int;
      default = 10000;
      description = "Límite de líneas en scrollback";
    };

    windowDecoration = mkOption {
      type = types.bool;
      default = false;
      description = "Mostrar decoraciones de ventana";
    };

    enableFishIntegration = mkOption {
      type = types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };

    # ══════════════════════════════════════════════════════════════════════
    # Tema - Puedes usar un tema integrado o definir colores personalizados
    # ══════════════════════════════════════════════════════════════════════
    theme = mkOption {
      type = types.nullOr types.str;
      default = "catppuccin-mocha";
      description = ''
        Tema de Ghostty. Algunos temas incluidos:
        - catppuccin-mocha, catppuccin-latte, catppuccin-frappe, catppuccin-macchiato
        - dracula, nord, gruvbox-dark, one-dark
        - Usa null para definir colores personalizados
      '';
      example = "dracula";
    };

    # Colores personalizados (solo si theme = null)
    colors = {
      foreground = mkOption {
        type = types.str;
        default = "#cdd6f4";
        description = "Color de texto";
      };
      background = mkOption {
        type = types.str;
        default = "#1e1e2e";
        description = "Color de fondo";
      };
    };

    # ══════════════════════════════════════════════════════════════════════
    # Keybindings personalizados
    # ══════════════════════════════════════════════════════════════════════
    keybindings = mkOption {
      type = types.listOf types.str;
      default = [
        "ctrl+shift+i=inspector:toggle"
        "ctrl+shift+p=toggle_command_palette"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
        "ctrl+shift+minus=decrease_font_size:1"
        "ctrl+shift+plus=increase_font_size:1"
        "ctrl+shift+0=reset_font_size"
        "ctrl+shift+r=reload_config"
        "alt+v=new_split:right"
        "alt+s=new_split:down"
        "alt+h=goto_split:left"
        "alt+l=goto_split:right"
        "alt+j=goto_split:bottom"
        "alt+k=goto_split:top"
        "alt+n=new_tab"
        "ctrl++=increase_font_size:1"
        "ctrl+-=decrease_font_size:1"
      ];
      description = "Lista de keybindings personalizados";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable {
    # Instalar Ghostty
    home.packages = [pkgs.ghostty];

    # Configuración de Ghostty via programs.ghostty
    programs.ghostty = {
      enable = true;
      enableFishIntegration = cfg.enableFishIntegration;
      clearDefaultKeybinds = true;
      settings = {
        # Tema
        theme = mkIf (cfg.theme != null) cfg.theme;
        
        # Fuente
        font-family = cfg.font;
        font-size = cfg.fontSize;
        font-feature = cfg.fontFeatures;
        
        # Cursor
        cursor-style = cfg.cursorStyle;
        cursor-style-blink = cfg.cursorBlink;
        
        # Ventana
        window-padding-x = cfg.paddingX;
        window-padding-y = cfg.paddingY;
        window-decoration = if cfg.windowDecoration then "auto" else "none";
        
        # Comportamiento
        scrollback-limit = cfg.scrollbackLimit;
        desktop-notifications = true;
        resize-overlay = "never";
        bell-features = "audio";
        window-inherit-working-directory = true;
        confirm-close-surface = false;
        gtk-single-instance = true;
        quit-after-last-window-closed = false;
        
        # Ajustes de cursor
        adjust-cursor-height = "40%";
        adjust-cursor-thickness = "100%";
        adjust-box-thickness = "100%";
        adjust-underline-thickness = "100%";
        adjust-underline-position = "110%";
        
        # Keybindings
        keybind = cfg.keybindings;
      } // (optionalAttrs (cfg.theme == null) {
        # Colores personalizados solo si no hay tema
        foreground = cfg.colors.foreground;
        background = cfg.colors.background;
      });
    };
  };
}
