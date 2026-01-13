# GitHub CLI (gh) - Herramienta oficial de GitHub para la terminal
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://cli.github.com/manual/
#
# NOTA: Este módulo NO gestiona config.yml para permitir autenticación con `gh auth login`
# La configuración se maneja con variables de entorno y aliases
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Configuración personalizable
  cfg = config.modules.terminal.software.gh;
in
{
  # Opciones configurables del módulo
  options.modules.terminal.software.gh = {
    enable = lib.mkEnableOption "GitHub CLI (gh)";
    
    # Editor para abrir archivos (ej: al editar PRs)
    editor = lib.mkOption {
      type = lib.types.str;
      default = "nano"; # Por defecto algo seguro
      description = "Editor por defecto para gh";
      example = "nvim";
    };
    
    # Navegador para abrir enlaces
    browser = lib.mkOption {
      type = lib.types.str;
      default = ""; # Usar el por defecto del sistema
      description = "Navegador para abrir enlaces de GitHub";
      example = "firefox";
    };
    
    # Nombre de usuario de GitHub
    username = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Tu nombre de usuario de GitHub";
      example = "linuxmobile";
    };
    
    # Protocolo Git (https o ssh)
    gitProtocol = lib.mkOption {
      type = lib.types.enum [ "https" "ssh" ];
      default = "https";
      description = "Protocolo para operaciones Git";
    };
  };

  config = lib.mkIf cfg.enable {
    # Instalar el paquete gh
    home.packages = with pkgs; [
      gh
    ];

    # Variables de entorno para configuración de gh
    # (en lugar de archivo config.yml que bloquea autenticación)
    home.sessionVariables = {
      GH_EDITOR = cfg.editor;
      GH_PAGER = "less -FR";
    } // lib.optionalAttrs (cfg.browser != "") {
      GH_BROWSER = cfg.browser;
    };

    # Aliases útiles para gh (funciona en todos los shells: fish, zsh, bash)
    home.shellAliases = {
      ghco = "gh pr checkout";     # ghco <pr-number> - checkout de un PR
      ghpv = "gh pr view";         # ghpv - ver PR actual
      ghrv = "gh repo view";       # ghrv - ver repo actual
      ghis = "gh issue status";    # ghis - estado de issues
    };
  };
}
