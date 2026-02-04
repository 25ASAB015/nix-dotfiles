# modules/hm/programs/media/spicetify.nix
# Spicetify configuration
{ pkgs, config, lib, inputs, ... }:

let
  cfg = config.modules.media.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  options.modules.media.spicetify = {
    enable = lib.mkEnableOption "Spicetify with marketplace and adblock";
  };

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      # theme = spicePkgs.themes.marketplace;
      # colorScheme = "nix";
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        popupLyrics
      ];
    };
  };
}
