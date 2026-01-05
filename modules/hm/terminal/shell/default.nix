# Shell - Configuraciones de shells y prompts
# Módulo principal que agrupa shells y herramientas relacionadas
# Estructura basada en: /home/ludus/Downloads/kakunew/home/terminal/shell/
{ ... }:

{
  imports = [
    ./fish.nix       # Fish shell con plugins (incluye carapace)
    ./starship.nix   # Prompt para Fish (separado de zsh)
    # Futuros módulos:
    # ./nushell.nix  # Shell moderno con datos estructurados
  ];
}
