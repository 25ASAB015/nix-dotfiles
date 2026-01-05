# Terminal Software - Herramientas CLI
# Este módulo agrupa todas las herramientas de terminal
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./gh.nix       # GitHub CLI
    ./lazygit.nix  # TUI para Git
    # Futuros módulos:
    # ./git.nix
    # ./bat.nix
    # ./fzf.nix
    # ./zoxide.nix
  ];
}
