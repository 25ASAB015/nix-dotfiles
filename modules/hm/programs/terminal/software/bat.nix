# Bat - Un 'cat' con superpoderes
# Sintaxis highlighting, integración con git, y paginación
# Documentación: https://github.com/sharkdp/bat
# Uso: bat archivo.txt, bat -p (plain), bat --list-themes
{ config, lib, ... }:

let
  cfg = config.modules.terminal.software.bat;
in
{
  options.modules.terminal.software.bat = {
    enable = lib.mkEnableOption "bat - cat clone with wings";

    pager = lib.mkOption {
      type = lib.types.str;
      default = "less -FR";
      description = "Pager to use for output";
    };

    style = lib.mkOption {
      type = lib.types.str;
      default = "plain";
      description = "Output style (full, auto, plain, changes, header, grid, etc.)";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "base16";
      description = "Syntax highlighting theme";
    };

    useAsManPager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use bat as man pager for colorized man pages";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        pager = cfg.pager;
        style = cfg.style;
        theme = cfg.theme;
      };
    };

    # Usar bat como pager para man pages (colores en manuales)
    home.sessionVariables = lib.mkIf cfg.useAsManPager {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
    };
  };
}
