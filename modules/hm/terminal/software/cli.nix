# CLI Tools - Herramientas de línea de comandos
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Colección de utilidades CLI modernas y productivas
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.software.cli;
in
{
  options.modules.terminal.software.cli = {
    enable = lib.mkEnableOption "CLI tools collection";

    # Integración con Fish shell
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };

    # Habilitar herramientas de archivos comprimidos
    archives = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Incluir herramientas para archivos comprimidos (zip, unzip, unrar)";
    };

    # Habilitar utilidades del sistema
    systemUtils = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Incluir utilidades del sistema (dust, duf, fd, etc.)";
    };

    # Habilitar herramientas TUI extra (discord, reddit, etc)
    tuiApps = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Incluir aplicaciones TUI (discordo, reddit-tui, etc.)";
    };

    # Habilitar eza (reemplazo moderno de ls)
    eza = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar eza (ls moderno con iconos y git)";
    };

    # Habilitar fzf (fuzzy finder)
    fzf = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar fzf (buscador fuzzy)";
    };

    # Habilitar ripgrep (grep moderno)
    ripgrep = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar ripgrep (grep ultrarrápido)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; 
      # ════════════════════════════════════════════════════════════════════════
      # ARCHIVES - Herramientas para archivos comprimidos
      # ════════════════════════════════════════════════════════════════════════
      (lib.optionals cfg.archives [
        zip      # Crear archivos .zip
        unzip    # Extraer archivos .zip
        unrar    # Extraer archivos .rar
      ])

      # ════════════════════════════════════════════════════════════════════════
      # MISC - Herramientas misceláneas
      # ════════════════════════════════════════════════════════════════════════
      ++ [
        libnotify   # Enviar notificaciones del sistema
        fontconfig  # Configuración de fuentes
      ]

      # ════════════════════════════════════════════════════════════════════════
      # SYSTEM UTILS - Utilidades modernas del sistema
      # ════════════════════════════════════════════════════════════════════════
      ++ (lib.optionals cfg.systemUtils [
        dust         # du moderno - uso de disco con visualización
        duf          # df moderno - espacio de disco
        fd           # find moderno - búsqueda de archivos
        file         # Identificar tipos de archivo
        jaq          # jq en Rust - procesador JSON
        killall      # Matar procesos por nombre
        jq           # Procesador JSON clásico
        ps_mem       # Memoria por proceso
        glow         # Renderizar Markdown en terminal
        gtt          # Google Translate en terminal
        inshellisense # Autocompletado inteligente para shells
        zfxtop       # Monitor del sistema estilo htop
      ])

      # ════════════════════════════════════════════════════════════════════════
      # TUI APPS - Aplicaciones de interfaz de texto
      # ════════════════════════════════════════════════════════════════════════
      ++ (lib.optionals cfg.tuiApps [
        discordo    # Cliente Discord TUI
        reddit-tui  # Cliente Reddit TUI
        scope-tui   # Visualizador de audio en terminal
      ]);

    programs = {
      # ════════════════════════════════════════════════════════════════════════
      # EZA - Reemplazo moderno de ls
      # ════════════════════════════════════════════════════════════════════════
      eza = lib.mkIf cfg.eza {
        enable = true;
        enableFishIntegration = cfg.enableFishIntegration && config.programs.fish.enable;
        colors = "auto";
        git = true;      # Mostrar estado git
        icons = "auto";  # Iconos Nerd Font
      };

      # ════════════════════════════════════════════════════════════════════════
      # DIRCOLORS - Colores para ls/eza
      # ════════════════════════════════════════════════════════════════════════
      dircolors = {
        enable = true;
        enableFishIntegration = cfg.enableFishIntegration && config.programs.fish.enable;
      };

      # ════════════════════════════════════════════════════════════════════════
      # RIPGREP - Grep ultrarrápido
      # ════════════════════════════════════════════════════════════════════════
      ripgrep = lib.mkIf cfg.ripgrep {
        enable = true;
      };

      # ════════════════════════════════════════════════════════════════════════
      # FZF - Fuzzy Finder
      # ════════════════════════════════════════════════════════════════════════
      fzf = lib.mkIf cfg.fzf {
        enable = true;
        enableFishIntegration = cfg.enableFishIntegration && config.programs.fish.enable;
      };
    };
  };
}
