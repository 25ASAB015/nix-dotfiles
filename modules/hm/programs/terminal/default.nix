# modules/hm/programs/terminal/default.nix
# Terminal - All terminal-related configurations
{ ... }:

{
  imports = [
    ./emulators  # Terminal emulators (foot, ghostty)
    ./shell      # Shell configurations (fish, starship)
    ./software   # CLI tools (git, gh, lazygit, etc.)
    ./tmux.nix   # Tmux configuration (Oh my tmux!)
  ];
}

