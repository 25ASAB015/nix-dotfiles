# Zoxide - Navegación inteligente de directorios
# Un smarter cd command que aprende tus hábitos
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://github.com/ajeetdsouza/zoxide
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.software.zoxide;
in
{
  options.modules.terminal.software.zoxide = {
    enable = lib.mkEnableOption "Zoxide - smarter cd command";
    
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zoxide
    ];

    # Integración con Fish shell
    xdg.configFile."fish/conf.d/zoxide.fish" = lib.mkIf cfg.enableFishIntegration {
      source = pkgs.runCommand "zoxide-fish-init" {} ''
        ${pkgs.zoxide}/bin/zoxide init fish > $out
      '';
    };
  };
}
