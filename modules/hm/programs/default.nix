# modules/hm/programs/default.nix
# Programs - All user applications and tools
{ ... }:

{
  imports = [
    ./terminal         # Terminal: emulators, shell, CLI tools
    ./browsers         # Web browsers
    ./development      # Development tools and languages
    ./system           # System utilities (gammastep, notifications, etc.)
    ./document-viewers # Document viewers (Zathura for PDF/LaTeX)
    ./editors           # Editors (vscode, cursor, antigravity)
    ./ai-assistants     # AI Assistants (opencode)
    ./media             # Media apps (OBS Studio, vlc, mpv, spotify)
  ];
}

