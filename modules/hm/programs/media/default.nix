# modules/hm/programs/media/default.nix
# Media applications and recording tools
{ ... }:

{
  imports = [
    ./obs.nix  # OBS Studio with Wayland/Hyprland plugins
    # Future imports:
    # ./vlc.nix      # Media player
    # ./mpv.nix      # Video player
    # ./spotify.nix  # Music streaming
  ];
}

