{ config, lib, pkgs, ... }:

{
  # Cursor - Editor de código con IA
  # Instalado como paquetes en home.packages
  # La configuración se gestiona con symlinks en files.nix
  home.packages = with pkgs; [
    code-cursor-fhs  # Cursor AI (versión FHS para mejor compatibilidad)
    cursor-cli        # Cursor CLI
  ];
}

