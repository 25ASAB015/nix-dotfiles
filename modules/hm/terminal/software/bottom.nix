# Bottom - Monitor de sistema moderno
# Reemplazo de htop/btop con soporte para GPU
# Documentación: https://clementtsang.github.io/bottom/
# Uso: btm, btm -b (básico), btop (alias), htop (alias básico)
{ config, lib, pkgs, ... }:

let
  cfg = config.modules.terminal.software.bottom;
in
{
  options.modules.terminal.software.bottom = {
    enable = lib.mkEnableOption "bottom - graphical system monitor";

    enableGpu = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable GPU monitoring (requires GPU drivers)";
    };

    groupProcesses = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Group processes with the same name";
    };

    createAliases = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create btop and htop aliases pointing to bottom";
    };
  };

  config = lib.mkIf cfg.enable {
    # Aliases para reemplazar btop/htop con bottom
    home.packages = lib.mkIf cfg.createAliases (with pkgs; [
      (writeScriptBin "btop" ''exec btm'')
      (writeScriptBin "htop" ''exec btm -b'')
    ]);

    programs.bottom = {
      enable = true;
      settings = {
        enable_gpu = cfg.enableGpu;
        flags.group_processes = cfg.groupProcesses;
        row = [
          {
            ratio = 2;
            child = [
              { type = "cpu"; }
              { type = "mem"; }
            ];
          }
          {
            ratio = 3;
            child = [
              {
                type = "proc";
                ratio = 1;
                default = true;
              }
            ];
          }
        ];
      };
    };
  };
}
