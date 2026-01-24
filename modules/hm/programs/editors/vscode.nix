{ config, lib, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;  # Versión FHS para mejor compatibilidad
    
    # Permitir instalación manual de extensiones adicionales
    mutableExtensionsDir = true;
    
    # Comenzamos sin extensiones declarativas
    # Las instalaremos manualmente y luego las declararemos
    # Usar la nueva sintaxis con profiles.default.extensions
    profiles.default = {
      extensions = [ ];
    };
  };
}

