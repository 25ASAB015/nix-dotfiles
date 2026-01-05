# Terminal Software - Herramientas CLI
# Este módulo agrupa todas las herramientas de terminal
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./gh.nix       # GitHub CLI
    ./git.nix      # Git con configuración avanzada
    ./lazygit.nix  # TUI para Git
    # Futuros módulos:
    # ./bat.nix
    # ./fzf.nix
    # ./zoxide.nix
  ];
}
