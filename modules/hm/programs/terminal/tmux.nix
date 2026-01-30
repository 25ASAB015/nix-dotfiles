# modules/hm/programs/terminal/tmux.nix
# Tmux configuration using Oh my tmux! framework
{ config, pkgs, ... }:

{
  # Symlink Oh my tmux! main configuration
  home.file.".config/tmux/tmux.conf" = {
    source = ./oh-my-tmux.conf;
  };

  # Symlink our custom local configuration
  home.file.".config/tmux/tmux.conf.local" = {
    source = ./tmux.conf.local;
  };

  # Create tmux config directory if it doesn't exist
  home.file.".config/tmux/.keep".text = "";

  # Session variables for better tmux integration
  home.sessionVariables = {
    # Ensure proper terminal colors
    TERM = "xterm-256color";
  };
}
