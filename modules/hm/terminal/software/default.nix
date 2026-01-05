# Terminal Software - Herramientas CLI
# Este módulo agrupa todas las herramientas de terminal
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./atuin.nix    # Historial de shell mejorado
    ./gh.nix       # GitHub CLI
    ./git.nix      # Git con configuración avanzada
    ./lazygit.nix  # TUI para Git
    ./zoxide.nix   # Navegación inteligente de directorios
    # Futuros módulos:
    # ./bat.nix
    # ./fzf.nix
  ];
}
