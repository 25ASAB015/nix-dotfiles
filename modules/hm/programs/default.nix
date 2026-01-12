# modules/hm/programs/default.nix
# Programs - All user applications and tools
{ ... }:

{
  imports = [
    ./terminal      # Terminal: emulators, shell, CLI tools
    ./browsers      # Web browsers
    ./development   # Development tools and languages
    ./system        # System utilities (gammastep, notifications, etc.)
    # ./editors    # Future: Editors (neovim, vscode, helix)
    # ./media      # Future: Media apps (vlc, mpv, spotify)
  ];
}

