# command-not-found - Handler para comandos no encontrados
# Integrado desde kaku: /home/ravn/Work/kaku/home/terminal/software/command-not-found.nix
{
  config,
  lib,
  ...
}: {
  options.modules.terminal.software.command-not-found = {
    enable = lib.mkEnableOption "command-not-found handler para Fish";
  };

  config = lib.mkIf config.modules.terminal.software.command-not-found.enable {
    xdg.configFile."fish/functions/__fish_command_not_found_handler.fish".text = ''
      function __fish_command_not_found_handler --on-event fish_command_not_found
          /run/current-system/sw/bin/command-not-found $argv
      end
    '';
  };
}

