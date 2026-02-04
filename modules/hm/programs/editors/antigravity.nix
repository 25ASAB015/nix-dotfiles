{ config, lib, pkgs, ... }:

{
  # AntiGravity - Editor de código por Google
  # Instalado como paquete en home.packages
  # La configuración se gestiona con symlinks en files.nix
  home.packages = with pkgs; [
    antigravity-fhs  # AntiGravity by Google (versión FHS)
  ];
}

