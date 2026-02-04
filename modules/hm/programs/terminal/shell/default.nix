# Shell - Configuraciones de shells y prompts
# Módulo principal que agrupa shells y herramientas relacionadas
# Estructura basada en: /home/ravn/Downloads/kakunew/home/terminal/shell/
{ ... }:

{
  imports = [
    ./carapace.nix   # Carapace - autocompletado multi-shell
    ./fish.nix       # Fish shell con plugins
    ./starship.nix   # Prompt para Fish (separado de zsh)
    # Futuros módulos:
    # ./nushell.nix  # Shell moderno con datos estructurados
  ];
}
