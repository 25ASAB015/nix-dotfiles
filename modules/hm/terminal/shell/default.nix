# Shell - Configuraciones de shells y prompts
# Módulo principal que agrupa shells y herramientas relacionadas
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./fish.nix       # Fish shell con configuración completa
    ./starship.nix   # Prompt minimalista y rápido
    ./carapace.nix   # Autocompletado multi-shell
    # Futuros módulos:
    # ./nushell.nix  # Shell moderno con datos estructurados
    # ./zsh.nix      # Zsh como alternativa
  ];
}
