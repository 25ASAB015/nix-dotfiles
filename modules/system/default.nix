{ config, lib, pkgs, ... }:

{
  imports = [
    # ./example.nix - add your modules here
  ];

  environment.systemPackages = [
    pkgs.vlc
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];
}
