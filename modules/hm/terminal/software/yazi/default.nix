# Yazi - File Manager moderno para terminal
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://yazi-rs.github.io/docs/
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.software.yazi;
in
{
  imports = [
    ./theme/icons.nix
    ./theme/manager.nix
    ./theme/status.nix
  ];

  # Opciones configurables del módulo
  options.modules.terminal.software.yazi = {
    enable = lib.mkEnableOption "Yazi file manager";

    # Integración con Fish shell
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };

    # Mostrar archivos ocultos por defecto
    showHidden = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Mostrar archivos ocultos por defecto";
    };

    # Layout: proporciones [izq medio der]
    layout = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ 1 4 3 ];
      description = "Proporciones del layout [izquierda medio derecha]";
      example = [ 1 3 4 ];
    };

    # Ordenar directorios primero
    sortDirFirst = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Mostrar directorios antes que archivos";
    };

    # Tema oscuro (flavor)
    darkFlavor = lib.mkOption {
      type = lib.types.str;
      default = "noctalia";
      description = "Nombre del flavor/tema oscuro a usar";
      example = "catppuccin-mocha";
    };
  };

  config = lib.mkIf cfg.enable {
    # Paquetes adicionales para mejor experiencia
    # exiftool: información de archivos (metadata EXIF)
    home.packages = with pkgs; [
      exiftool
    ];

    # Configuración principal de Yazi
    programs.yazi = {
      enable = true;

      # Integración con Fish (permite usar `y` para navegar)
      enableFishIntegration = cfg.enableFishIntegration && config.programs.fish.enable;

      settings = {
        mgr = {
          layout = cfg.layout;
          sort_by = "alphabetical";
          sort_sensitive = true;
          sort_reverse = false;
          sort_dir_first = cfg.sortDirFirst;
          linemode = "none";
          show_hidden = cfg.showHidden;
          show_symlink = true;
        };

        preview = {
          tab_size = 2;
          max_width = 600;
          max_height = 900;
          cache_dir = "${config.xdg.cacheHome}";
        };

        flavor = {
          dark = cfg.darkFlavor;
        };
      };
    };
  };
}
