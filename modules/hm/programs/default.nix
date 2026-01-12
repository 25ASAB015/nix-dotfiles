# modules/hm/programs/default.nix
# Programs - All user applications and tools
{ ... }:

{
  imports = [
    ./terminal      # Terminal: emulators, shell, CLI tools
    ./browsers      # Web browsers
    ./development   # Development tools and languages
    ./apps          # Application management (flatpak, appimage)
    # ./editors    # Future: Editors (neovim, vscode, helix)
    # ./media      # Future: Media apps (vlc, mpv, spotify)
  ];
}

