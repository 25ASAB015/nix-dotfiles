# Terminal Software - Herramientas CLI
# Este módulo agrupa todas las herramientas de terminal
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./atuin.nix    # Historial de shell mejorado
    ./bat.nix      # cat con syntax highlighting
    ./bottom.nix   # Monitor de sistema (reemplazo de htop/btop)
    ./cli.nix      # Colección de herramientas CLI (eza, fzf, ripgrep, etc.)
    ./gh.nix       # GitHub CLI
    ./git.nix      # Git con configuración avanzada
    ./lazygit.nix  # TUI para Git
    # ./opencode   # OpenCode movido a modules/hm/programs/ai-assistants/
    ./skim.nix     # Skim - Fuzzy finder escrito en Rust (alternativa a fzf)
    ./yazi         # File manager moderno (carpeta con subconfiguraciones)
    ./zoxide.nix   # Navegación inteligente de directorios
  ];
}
