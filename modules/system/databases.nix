# Documentation: docs/src/content/docs/databases.mdx (Future)
# PostgreSQL configuration for development
{ config, pkgs, lib, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16; # O la versión que prefieras
    
    # Configuración de autenticación local simplificada para desarrollo
    authentication = pkgs.lib.mkForce ''
      # TYPE  DATABASE        USER            ADDRESS                 METHOD
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust
    '';

    # Crear base de datos inicial para el usuario
    ensureDatabases = [ "ravn" "dev_db" ];
    ensureUsers = [
      {
        name = "ravn";
        ensureClauses.superuser = true;
      }
    ];

    # Variables de entorno para PostgreSQL
    settings = {
      log_connections = true;
      log_statement = "all";
    };
  };

  # Abrir puerto en el firewall si es necesario (solo local por defecto)
  # networking.firewall.allowedTCPPorts = [ 5432 ];
}
