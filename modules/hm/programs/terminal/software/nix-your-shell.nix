# nix-your-shell - Integración de shell con Nix
# Integrado desde kaku: /home/ludus/Work/kaku/home/terminal/software/nix-your-shell.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.terminal.software.nix-your-shell = {
    enable = lib.mkEnableOption "nix-your-shell - integración de shell con Nix";

    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };
  };

  config = lib.mkIf config.modules.terminal.software.nix-your-shell.enable {
    home.packages = with pkgs; [
      nix-your-shell
    ];

    xdg.configFile."fish/conf.d/nix-your-shell.fish" = lib.mkIf config.modules.terminal.software.nix-your-shell.enableFishIntegration {
      source = pkgs.runCommand "nix-your-shell-init" {} ''
        ${pkgs.nix-your-shell}/bin/nix-your-shell fish > $out
      '';
    };
  };
}

