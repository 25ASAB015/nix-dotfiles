# Starship - Prompt para Fish (separado de zsh/Hydenix)
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
  configFile = "starship/fish.toml";
in
{
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

    xdg.configFile = {
      # ══════════════════════════════════════════════════════════════════════
      # Configuración de Starship EXCLUSIVA para Fish
      # ══════════════════════════════════════════════════════════════════════
      "${configFile}".text = ''
        # Starship config for Fish shell
        # Separated from zsh/Hydenix configuration

        add_newline = true
        scan_timeout = 5
        command_timeout = 500

        format = """
        [┌───](bold bright-blue) $hostname $os
        [│](bold bright-blue) $directory$git_branch$git_status$nix_shell
        [└─>](bold bright-blue) $character
        """

        [os]
        format = "on [($name $codename$version $symbol )]($style)"
        style = "bold bright-blue"
        disabled = false

        [hostname]
        ssh_only = false
        format = "[$hostname]($style)"
        style = "bold bright-red"
        disabled = false

        [character]
        format = "$symbol"
        success_symbol = "[❯](bold bright-green) "
        error_symbol = "[✗](bold bright-red) "
        vicmd_symbol = "[](bold yellow) "
        disabled = false

        [nix_shell]
        disabled = false
        heuristic = false
        format = "[   ](fg:bright-blue bold)"
        impure_msg = ""
        pure_msg = ""
        unknown_msg = ""

        [directory]
        format = "[$path]($style)"
        style = "bold bright-cyan"
        truncation_length = 3
        truncation_symbol = "…/"

        [git_branch]
        format = " [$symbol$branch]($style)"
        style = "bold bright-purple"
        symbol = " "

        [git_status]
        format = "[$all_status$ahead_behind]($style) "
        style = "bold bright-yellow"

        # Disabled modules for performance
        [aws]
        disabled = true

        [gcloud]
        disabled = true

        [nodejs]
        disabled = true

        [ruby]
        disabled = true

        [python]
        disabled = true

        [rust]
        disabled = true

        [golang]
        disabled = true

        [java]
        disabled = true

        [kotlin]
        disabled = true

        [lua]
        disabled = true

        [perl]
        disabled = true

        [php]
        disabled = true

        [swift]
        disabled = true

        [terraform]
        disabled = true

        [zig]
        disabled = true

        [package]
        disabled = true

        [conda]
        disabled = true

        [docker_context]
        disabled = true

        [kubernetes]
        disabled = true

        [helm]
        disabled = true

        [battery]
        disabled = true

        [time]
        disabled = true

        [cmd_duration]
        disabled = true
      '';

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
    };
  };
}
