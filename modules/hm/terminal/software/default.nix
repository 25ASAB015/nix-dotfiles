# Terminal Software - Herramientas CLI
# Este módulo agrupa todas las herramientas de terminal
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./gh.nix  # GitHub CLI
    # Aquí irán futuros módulos de software:
    # ./git.nix
    # ./lazygit.nix
    # ./bat.nix
    # ./fzf.nix
    # ./zoxide.nix
  ];
}
