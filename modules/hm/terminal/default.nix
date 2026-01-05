# Terminal - Configuraciones de terminal
# Módulo principal que agrupa emuladores, shell y software
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./emulators  # Emuladores de terminal (foot, ghostty)
    ./software   # Herramientas CLI (gh, git, lazygit, etc.)
    ./shell      # Shells (fish, starship, carapace)
  ];
}
