# modules/hm/programs/development/nix-tools.nix
# Herramientas de desarrollo para Nix
# Incluye linters y formatters para trabajar con archivos .nix
{ config, lib, pkgs, ... }:

with lib; let
  cfg = config.modules.development.nix-tools;
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.development.nix-tools = {
    enable = mkEnableOption "Nix development tools (linters and formatters)";
    
    formatter = mkOption {
      type = types.enum ["nixpkgs-fmt" "alejandra"];
      default = "nixpkgs-fmt";
      description = "Formatter a utilizar para archivos .nix";
      example = "alejandra";
    };
    
    installLinter = mkOption {
      type = types.bool;
      default = true;
      description = "Instalar statix (linter para Nix)";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable { };
}

