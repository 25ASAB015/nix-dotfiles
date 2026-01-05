# Terminal - Configuraciones de terminal
# Módulo principal que agrupa emuladores, shell y software
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./software  # Herramientas CLI (gh, git, lazygit, etc.)
    ./shell     # Shells (fish, starship, carapace)
    # Futuros módulos:
    # ./emulators  # Emuladores de terminal (kitty, foot, etc.)
  ];
}
