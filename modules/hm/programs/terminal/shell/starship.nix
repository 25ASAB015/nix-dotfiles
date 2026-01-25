# Starship - Prompt para Fish (separado de zsh/Hydenix)
# IMPORTANTE: Esta configuración es EXCLUSIVA para Fish shell.
# No afecta la configuración de Starship de zsh/Hydenix.
# Basado en kaku: /home/ludus/Work/kaku/home/terminal/shell/starship.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.terminal.shell.starship;
  configFile = "starship/fish.toml";  # Archivo separado para Fish (zsh usa starship.toml de Hydenix)
  toTOML = (pkgs.formats.toml {}).generate;
in {
  options.modules.terminal.shell.starship = {
    enable = lib.mkEnableOption "Starship prompt para Fish (separado de zsh)";

    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración automática con Fish";
    };
  };

  config = lib.mkIf cfg.enable {
    # Starship ya está instalado por Hydenix, no necesitamos instalarlo
    # NOTA: No usamos home.sessionVariables porque afectaría a zsh también
    # En su lugar, configuramos STARSHIP_CONFIG solo en fish/conf.d/starship.fish

    xdg.configFile = {
      # ══════════════════════════════════════════════════════════════════════
      # Configuración de Starship EXCLUSIVA para Fish (formato de kaku)
      # ══════════════════════════════════════════════════════════════════════
      "${configFile}".source = toTOML "starship.toml" {
        add_newline = true;
        scan_timeout = 5;
        command_timeout = 500;

        format = ''
          $status$username$hostname$directory$git_branch$git_status$cmd_duration$nix_shell
          $character'';

        status = {
          disabled = false;
          format = "[$symbol](bold $style) ";
          symbol = "│";
          success_symbol = "[│](bold white)";
          style = "red";
          map_symbol = false;
          recognize_signal_code = false;
          pipestatus = false;
        };

        character = {
          format = "$symbol";
          success_symbol = "[│](bold white) ";
          error_symbol = "[│](bold red) ";
          vicmd_symbol = "[│](bold green) ";
        };

        jobs.disabled = true;

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

        directory = {
          format = "[$path]($style)";
          style = "cyan";
          truncation_length = 1;
          truncation_symbol = "";
          home_symbol = "~";
          repo_root_format = "[$repo_root]($repo_root_style)";
          repo_root_style = "bold white";
        };

        git_branch = {
          format = " [$branch]($style)";
          style = "green";
          symbol = "";
        };

        git_status = {
          format = " [$all_status$ahead_behind]($style)";
          style = "yellow";
          untracked = "[?]";
          modified = "[!]";
          staged = "[+]";
          deleted = "[x]";
          renamed = "[»]";
          stashed = "";
          ahead = "[↑]";
          behind = "[↓]";
          diverged = "[↕]";
          conflicted = "[~]";
          up_to_date = "";
          behind_count = true;
          ahead_count = true;
        };

        cmd_duration = {
          format = " [$duration]($style)";
          style = "yellow";
          min_time = 2000;
          show_milliseconds = true;
        };

        nix_shell = {
          disabled = false;
          heuristic = false;
          format = " [nix]($style)";
          style = "bold blue";
          impure_msg = "";
          pure_msg = "";
          unknown_msg = "";
        };

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
          # Inicializar Starship prompt
          # Las variables de entorno (STARSHIP_CONFIG, etc.) se configuran en shellInit
          # para asegurar que estén disponibles antes de inicializar
          if type -q starship
            starship init fish | source
          end
        '';
      };

      "fish/completions/starship.fish".source = "${pkgs.starship}/share/fish/vendor_completions.d/starship.fish";
    };
  };
}
