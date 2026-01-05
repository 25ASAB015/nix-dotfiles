# Terminal - Configuraciones de terminal
# Módulo principal que agrupa emuladores, shell y software
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./software  # Herramientas CLI (gh, git, lazygit, etc.)
    # Futuros módulos:
    # ./emulators  # Emuladores de terminal (kitty, foot, etc.)
    # ./shell      # Configuraciones de shell (fish, zsh, nushell)
  ];
}
