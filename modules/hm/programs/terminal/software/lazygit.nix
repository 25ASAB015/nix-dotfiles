# Lazygit - Interfaz TUI para Git
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://github.com/jesseduffield/lazygit
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.software.lazygit;
  toYAML = (pkgs.formats.yaml {}).generate;
  configFile = "lazygit/config.yml";
in
{
  options.modules.terminal.software.lazygit = {
    enable = lib.mkEnableOption "Lazygit - TUI para Git";

    # Firmar commits automáticamente
    signOffCommits = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Agregar 'Signed-off-by' a los commits";
    };

    # Versión de Nerd Fonts para iconos
    nerdFontsVersion = lib.mkOption {
      type = lib.types.str;
      default = "3";
      description = "Versión de Nerd Fonts (3 para v3.x)";
    };

    # Colores del tema
    theme = {
      activeBorderColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "magenta" "bold" ];
        description = "Color del borde activo";
      };
      inactiveBorderColor = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "black" ];
        description = "Color del borde inactivo";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.lazygit ];

    xdg.configFile."${configFile}".source = toYAML "config.yml" {
      # Desactivar popups molestos al iniciar
      disableStartupPopups = true;
      
      git = {
        commit = {
          signOff = cfg.signOffCommits;
        };
        parseEmoji = true;  # Parsear emojis en commits
      };
      
      gui = {
        nerdFontsVersion = cfg.nerdFontsVersion;
        showBottomLine = false;      # Ocultar línea inferior
        showCommandLog = false;      # Ocultar log de comandos
        showListFooter = false;      # Ocultar footer de listas
        showRandomTip = false;       # Sin tips aleatorios
        theme = {
          activeBorderColor = cfg.theme.activeBorderColor;
          inactiveBorderColor = cfg.theme.inactiveBorderColor;
        };
      };
      
      # Si no estamos en un repo, saltar sin error
      notARepository = "skip";
      
      # No preguntar al volver de subprocesos
      promptToReturnFromSubprocess = false;
      
      # No buscar actualizaciones (Nix maneja esto)
      update = {
        method = "never";
      };
    };
  };
}
