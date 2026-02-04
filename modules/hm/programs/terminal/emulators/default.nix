# Terminal Emulators
# Este módulo agrupa los emuladores de terminal
# Estructura inspirada en Kaku: https://github.com/linuxmobile/kaku
{ ... }:

{
  imports = [
    ./foot.nix      # Foot - Terminal ligera para Wayland
    ./ghostty.nix   # Ghostty - Terminal moderna y rápida
    ./kitty.nix     # Kitty - Terminal con GPU rendering (desde Hydenix)
  ];
}
