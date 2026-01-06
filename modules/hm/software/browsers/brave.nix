{ pkgs, ... }:
let
  chromiumFlags = import ./chromium-flags.nix { inherit pkgs; };
in {
  home.packages = [ pkgs.brave ];
  home.sessionVariables = chromiumFlags.sessionVariables;
}
