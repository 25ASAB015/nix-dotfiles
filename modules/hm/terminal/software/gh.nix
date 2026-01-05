# GitHub CLI (gh) - Herramienta oficial de GitHub para la terminal
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://cli.github.com/manual/
{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Configuración personalizable
  cfg = config.modules.terminal.software.gh;
  
  # Helper para generar archivos YAML
  toYAML = (pkgs.formats.yaml {}).generate;
  
  # Rutas de configuración XDG
  configFile = "gh/config.yml";
  hostsFile = "gh/hosts.yml";
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

    # Archivo de configuración principal de gh
    xdg.configFile."${configFile}".source = toYAML "config.yml" {
      version = 1;
      git_protocol = cfg.gitProtocol;
      editor = cfg.editor;
      prompt = "enabled";
      prefer_editor_prompt = "disabled";
      pager = "less -FR";
      aliases = {
        co = "pr checkout";     # gh co <pr-number> - checkout de un PR
        pv = "pr view";         # gh pv - ver PR actual
        rv = "repo view";       # gh rv - ver repo actual
        is = "issue status";    # gh is - estado de issues
      };
      http_unix_socket = "";
      browser = cfg.browser;
    };

    # Archivo de hosts (conexiones a GitHub)
    xdg.configFile."${hostsFile}".text = lib.mkIf (cfg.username != "") ''
      github.com:
        git_protocol: ${cfg.gitProtocol}
        user: ${cfg.username}
    '';
  };
}
