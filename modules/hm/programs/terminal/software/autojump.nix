# Autojump - Navegación rápida a directorios frecuentes
# Integrado desde kaku: /home/ravn/Work/kaku/home/terminal/software/autojump.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.terminal.software.autojump = {
    enable = lib.mkEnableOption "Autojump - navegación rápida a directorios frecuentes";

    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };
  };

  config = lib.mkIf config.modules.terminal.software.autojump.enable {
    home.packages = with pkgs; [
      autojump
    ];

    xdg.configFile."fish/conf.d/autojump.fish" = lib.mkIf config.modules.terminal.software.autojump.enableFishIntegration {
      source = "${pkgs.autojump}/share/autojump/autojump.fish";
    };
  };
}

