{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];

  # Enable cliphist history
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
