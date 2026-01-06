{ pkgs, inputs, ... }:
{
  home.packages = [
    inputs.zen-browser-flake.packages.${pkgs.system}.zen-browser
  ];
}
