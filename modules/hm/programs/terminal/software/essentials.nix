# Essentials - Herramientas CLI básicas
# Adaptado de configuración sistema a Home Manager
# Paquetes esenciales del sistema original
{
  config,
  lib,
  pkgs,
  ...
}: {
  # Paquetes esenciales (adaptado de environment.systemPackages del archivo fuente)
  # Nota: git y gh removidos para evitar duplicados (ya en git.nix y gh.nix)
  # Nota: Cursor y AntiGravity movidos a modules/hm/programs/editors/
  home.packages = with pkgs; [
    # Git tools
    gitkraken # GitKraken GUI
    gk-cli # GitKraken CLI
    
    # Other
    dropbox # Dropbox
    meld # Visual diff and merge tool
    unzip # Unzip utility
  ];

  # Configuración Nix - NO aplicable en Home Manager
  # El archivo fuente tenía configuración de Nix a nivel sistema
  # (experimental-features, settings, etc.) que no se puede mover a HM
  # Se mantiene solo lo relevante: paquetes esenciales
}