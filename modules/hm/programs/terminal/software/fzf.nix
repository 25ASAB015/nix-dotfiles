# fzf - Fuzzy finder para línea de comandos
# Integrado desde kaku: /home/ludus/Work/kaku/home/terminal/software/fzf.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.terminal.software.fzf = {
    enable = lib.mkEnableOption "fzf - fuzzy finder";

    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };
  };

  config = lib.mkIf config.modules.terminal.software.fzf.enable {
    let
      cfg = config.modules.terminal.software.fzf;
    in {
      home.packages = with pkgs; [
        fzf
      ];

      xdg.configFile = lib.mkIf cfg.enableFishIntegration {
      "fish/conf.d/fzf.fish".source = "${pkgs.fzf}/share/fzf/key-bindings.fish";

      "fish/conf.d/fzf-extra.fish".text = ''
        set -gx FZF_DEFAULT_OPTS "--reverse --height 40% --border"
      '';
      };
    };
  };
}

