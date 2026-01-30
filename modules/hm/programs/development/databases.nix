# Documentation: docs/src/content/docs/databases.mdx (Future)
# Database clients module
{ config, pkgs, lib, ... }:

with lib; let
  cfg = config.modules.development.databases;
in {
  options.modules.development.databases = {
    enable = mkEnableOption "Herramientas y clientes de bases de datos";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      postgresql # Cliente psql
      # pgadmin4 # Si se prefiere interfaz gráfica
      # dbeaver-bin # Otra alternativa gráfica potente
    ];
  };
}
