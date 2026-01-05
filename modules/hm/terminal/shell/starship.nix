# Starship - Prompt minimalista, rápido e inteligente (para Fish)
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://starship.rs/
#
# IMPORTANTE: Esta configuración es EXCLUSIVA para Fish shell.
# No afecta la configuración de Starship de zsh/Hydenix.
# Usa un archivo separado: ~/.config/starship/fish.toml
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.shell.starship;
  toTOML = (pkgs.formats.toml {}).generate;
  # Archivo SEPARADO para no conflictuar con Hydenix/zsh
  configFile = "starship/fish.toml";
in
{
  options.modules.terminal.shell.starship = {
    enable = lib.mkEnableOption "Starship prompt para Fish (separado de zsh)";

    # ════════════════════════════════════════════════════════════════════════
    # Integración con Fish
    # ════════════════════════════════════════════════════════════════════════
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración automática con Fish";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Estilo del prompt
    # ════════════════════════════════════════════════════════════════════════
    style = {
      # Símbolo para indicar status
      successSymbol = lib.mkOption {
        type = lib.types.str;
        default = "[│](bold white)";
        description = "Símbolo cuando el comando fue exitoso";
      };

      errorSymbol = lib.mkOption {
        type = lib.types.str;
        default = "[│](bold red)";
        description = "Símbolo cuando el comando falló";
      };

      viCmdSymbol = lib.mkOption {
        type = lib.types.str;
        default = "[│](bold green)";
        description = "Símbolo en modo Vi normal";
      };

      # Colores del prompt
      directoryColor = lib.mkOption {
        type = lib.types.str;
        default = "cyan";
        description = "Color del directorio actual";
      };

      gitBranchColor = lib.mkOption {
        type = lib.types.str;
        default = "green";
        description = "Color de la rama git";
      };

      gitStatusColor = lib.mkOption {
        type = lib.types.str;
        default = "yellow";
        description = "Color del estado git";
      };
    };

    # ════════════════════════════════════════════════════════════════════════
    # Tiempo mínimo para mostrar duración
    # ════════════════════════════════════════════════════════════════════════
    minCmdDuration = lib.mkOption {
      type = lib.types.int;
      default = 2000;
      description = "Tiempo mínimo (ms) para mostrar duración del comando";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Truncación del directorio
    # ════════════════════════════════════════════════════════════════════════
    directoryTruncation = lib.mkOption {
      type = lib.types.int;
      default = 1;
      description = "Cuántos niveles de directorio mostrar";
    };
  };

  config = lib.mkIf cfg.enable {
    # NO instalamos starship aquí - ya lo provee Hydenix
    # home.packages = [ pkgs.starship ];

    # NO usamos home.sessionVariables - afectaría zsh
    # La variable STARSHIP_CONFIG se configura SOLO en fish/conf.d/starship.fish

    xdg.configFile = {
      # ══════════════════════════════════════════════════════════════════════
      # Configuración de Starship EXCLUSIVA para Fish
      # Archivo separado: ~/.config/starship/fish.toml
      # ══════════════════════════════════════════════════════════════════════
      "${configFile}".source = toTOML "fish.toml" {
        add_newline = true;
        scan_timeout = 5;
        command_timeout = 500;

        # Formato del prompt en DOS líneas:
        # Línea 1: │ directorio git_branch git_status
        # Línea 2: │ (cursor aquí)
        format = "$status$username$hostname$directory$git_branch$git_status$cmd_duration$nix_shell\n$character";

        # ════════════════════════════════════════════════════════════════════
        # Status del último comando (línea 1, al inicio)
        # ════════════════════════════════════════════════════════════════════
        status = {
          disabled = false;
          format = "[$symbol](bold $style) ";
          symbol = "│";
          success_symbol = "[│](bold white) ";
          style = "red";
          map_symbol = false;
          recognize_signal_code = false;
          pipestatus = false;
        };

        # ════════════════════════════════════════════════════════════════════
        # Carácter del prompt (línea 2)
        # ════════════════════════════════════════════════════════════════════
        character = {
          format = "$symbol";
          success_symbol = "[│](bold white) ";
          error_symbol = "[│](bold red) ";
          vicmd_symbol = "[│](bold green) ";
        };

        # ════════════════════════════════════════════════════════════════════
        # Usuario y hostname (solo en SSH)
        # ════════════════════════════════════════════════════════════════════
        username = {
          format = "[$user]($style)@";
          style_user = "bold yellow";
          style_root = "bold red";
          show_always = false;
        };

        hostname = {
          format = "[$hostname]($style) ";
          style = "bold yellow";
          ssh_only = true;
        };

        # ════════════════════════════════════════════════════════════════════
        # Directorio actual
        # ════════════════════════════════════════════════════════════════════
        directory = {
          format = "[$path]($style)";
          style = cfg.style.directoryColor;
          truncation_length = cfg.directoryTruncation;
          truncation_symbol = "";
          home_symbol = "~";
          repo_root_format = "[$repo_root]($repo_root_style)";
          repo_root_style = "bold white";
        };

        # ════════════════════════════════════════════════════════════════════
        # Git branch y status
        # ════════════════════════════════════════════════════════════════════
        git_branch = {
          format = " [$branch]($style)";
          style = cfg.style.gitBranchColor;
          symbol = "";
        };

        git_status = {
          format = " [$all_status$ahead_behind]($style)";
          style = cfg.style.gitStatusColor;
          untracked = "[?]";
          modified = "[!]";
          staged = "[+]";
          deleted = "[x]";
          renamed = "[»]";
          stashed = "";
          ahead = "[↑]";
          behind = "[↓]";
          diverged = "[↕]";
        };

        # ════════════════════════════════════════════════════════════════════
        # Duración del comando
        # ════════════════════════════════════════════════════════════════════
        cmd_duration = {
          format = " [$duration]($style)";
          style = "yellow";
          min_time = cfg.minCmdDuration;
          show_milliseconds = true;
        };

        # ════════════════════════════════════════════════════════════════════
        # Indicador de Nix shell
        # ════════════════════════════════════════════════════════════════════
        nix_shell = {
          disabled = false;
          heuristic = false;
          format = " [nix]($style)";
          style = "bold blue";
          impure_msg = "";
          pure_msg = "";
          unknown_msg = "";
        };

        # ════════════════════════════════════════════════════════════════════
        # Módulos deshabilitados (rendimiento)
        # ════════════════════════════════════════════════════════════════════
        jobs.disabled = true;
        aws.disabled = true;
        gcloud.disabled = true;
        nodejs.disabled = true;
        ruby.disabled = true;
        python.disabled = true;
        rust.disabled = true;
        golang.disabled = true;
        java.disabled = true;
        kotlin.disabled = true;
        lua.disabled = true;
        perl.disabled = true;
        php.disabled = true;
        swift.disabled = true;
        terraform.disabled = true;
        zig.disabled = true;
        package.disabled = true;
        conda.disabled = true;
        docker_context.disabled = true;
        kubernetes.disabled = true;
        helm.disabled = true;
        battery.disabled = true;
        time.disabled = true;
      };

      # ══════════════════════════════════════════════════════════════════════
      # Integración con Fish (usa config separada de zsh)
      # ══════════════════════════════════════════════════════════════════════
      "fish/conf.d/starship.fish" = lib.mkIf cfg.enableFishIntegration {
        text = ''
          # Usar configuración de Starship EXCLUSIVA para Fish
          # Esto NO afecta la configuración de zsh/Hydenix
          set -gx STARSHIP_CONFIG "${config.xdg.configHome}/${configFile}"
          set -gx STARSHIP_LOG "error"
          starship init fish | source
        '';
      };

      # Completions de Starship para Fish
      "fish/completions/starship.fish" = lib.mkIf cfg.enableFishIntegration {
        source = "${pkgs.starship}/share/fish/vendor_completions.d/starship.fish";
      };
    };
  };
}
