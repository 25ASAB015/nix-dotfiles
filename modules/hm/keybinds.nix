{
  lib,
  pkgs,
  ...
}: let
  fcitx-skin = pkgs.fetchFromGitHub {
    owner = "Yucklys";
    repo = "fcitx-nord-skin";
    rev = "4ae8525024be78d5fb9b9589bac7ff78ab9c4b34";
    sha256 = "sha256-K6qy09XqnotglMRdd4H2Na6D8QgikY11/PsZKb41dVI=";
  };
in {
  home.file = {
    ".config/fcitx/skin".source = fcitx-skin;
    # ".config/hyde/themes/Decay Green/wallpapers/cat.png" = {
    #   source = ../../resources/wallpapers/cat.png;
    # };
  };
  home.activation.copyWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    rm -f "$HOME/.config/hyde/themes/Decay Green/wallpapers/cat.png"
    rm -f "$HOME/.config/hyde/themes/Decay Green/wallpapers/focus.png"
    cp ${../../resources/wallpapers/cat.png} "$HOME/.config/hyde/themes/Decay Green/wallpapers/cat.png"
    cp ${../../resources/wallpapers/focus.png} "$HOME/.config/hyde/themes/Decay Green/wallpapers/focus.png"
  '';
}
