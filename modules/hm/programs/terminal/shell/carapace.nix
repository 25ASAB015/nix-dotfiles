# Carapace - Autocompletado multi-shell
# Integrado desde kaku: /home/ludus/Work/kaku/home/terminal/shell/carapace.nix
# Carapace proporciona autocompletado inteligente para múltiples shells
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.terminal.shell.carapace = {
    enable = lib.mkEnableOption "Carapace - autocompletado multi-shell";
  };

  config = lib.mkIf config.modules.terminal.shell.carapace.enable {
    home.packages = with pkgs; [
      carapace
      carapace-bridge
      inshellisense
    ];

    home.sessionVariables = {
      CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense";
      CARAPACE_CACHE_DIR = "${config.xdg.cacheHome}/carapace";
    };

    xdg.configFile = {
      "carapace/carapace.toml".text = ''
        [integrations.fish]
        enabled = true
      '';

      "fish/completions/carapace.fish".source = pkgs.runCommand "carapace-fish-init" {} ''
        ${pkgs.carapace}/bin/carapace _carapace fish > $out
      '';
    };
  };
}

