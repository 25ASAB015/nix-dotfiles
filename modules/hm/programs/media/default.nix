# modules/hm/programs/media/default.nix
# Media applications and recording tools
{ ... }:

{
  imports = [
    ./obs.nix  # OBS Studio with Wayland/Hyprland plugins
    ./spicetify.nix  # Spotify with custom themes and extensions
    # Future imports:
    # ./vlc.nix      # Media player
    # ./mpv.nix      # Video player
  ];
}

