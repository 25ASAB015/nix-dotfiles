# Kitty - Terminal con GPU rendering
# Integrado desde Hydenix: /home/ludus/Work/hydenix/hydenix/modules/hm/terminals.nix
# Kitty es un terminal moderno con renderizado GPU y excelente soporte de fuentes
# Documentación: https://sw.kovidgoyal.net/kitty/
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.terminal.emulators.kitty;
in {
  options.modules.terminal.emulators.kitty = {
    enable = lib.mkEnableOption "Kitty terminal emulator";

    configText = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Kitty config multiline text, use this to extend kitty settings";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      kitty
    ];

    home.file = {
      # Configuración de xdg-terminals.list (para xdg-terminal-exec)
      ".config/xdg-terminals.list" = {
        source = "${pkgs.hyde}/Configs/.config/xdg-terminals.list";
      };

      # Configuración base de Hydenix para Kitty
      ".config/kitty/hyde.conf" = {
        source = "${pkgs.hyde}/Configs/.config/kitty/hyde.conf";
      };

      # Configuración principal de Kitty (incluye hyde.conf)
      ".config/kitty/kitty.conf" = {
        text = ''
          include hyde.conf

          # Add your custom configurations here
          ${cfg.configText}
        '';
        force = true;
        mutable = true;
      };

      # Tema de Kitty (stateful file para wallbash)
      ".config/kitty/theme.conf" = {
        source = "${pkgs.hyde}/Configs/.config/kitty/theme.conf";
        force = true;
        mutable = true;
      };
    };
  };
}

