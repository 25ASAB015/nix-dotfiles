# Terminal Software - Herramientas CLI
# Este módulo agrupa todas las herramientas de terminal
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./atuin.nix    # Historial de shell mejorado
    ./cli.nix      # Colección de herramientas CLI (eza, fzf, ripgrep, etc.)
    ./gh.nix       # GitHub CLI
    ./git.nix      # Git con configuración avanzada
    ./lazygit.nix  # TUI para Git
    ./yazi         # File manager moderno (carpeta con subconfiguraciones)
    ./zoxide.nix   # Navegación inteligente de directorios
  ];
}
