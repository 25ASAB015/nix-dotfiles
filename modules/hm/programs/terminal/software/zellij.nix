# Zellij - Terminal multiplexer moderno
# Integrado desde kaku: /home/ravn/Work/kaku/home/terminal/emulators/foot.nix
# Zellij es un terminal multiplexer escrito en Rust, similar a tmux pero más moderno
# Documentación: https://zellij.dev/
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.modules.terminal.software.zellij = {
    enable = lib.mkEnableOption "Zellij - terminal multiplexer";
  };

  config = lib.mkIf config.modules.terminal.software.zellij.enable {
    home.packages = with pkgs; [
      zellij
    ];
  };
}

