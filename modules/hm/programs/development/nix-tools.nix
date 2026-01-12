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
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Formatter (según elección del usuario)
      (if cfg.formatter == "alejandra" then alejandra else nixpkgs-fmt)
      
      # Linter (opcional)
    ] ++ optionals cfg.installLinter [
      pkgs.statix
    ];
    
    # Mensaje informativo en la activación
    home.activation.nixToolsInfo = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
      $DRY_RUN_CMD echo "✅ Nix Development Tools instaladas:"
      $DRY_RUN_CMD echo "   📝 Formatter: ${cfg.formatter}"
      ${if cfg.installLinter then ''
        $DRY_RUN_CMD echo "   🔍 Linter: statix"
      '' else ""}
      $DRY_RUN_CMD echo ""
      $DRY_RUN_CMD echo "   Comandos disponibles:"
      $DRY_RUN_CMD echo "   - make format  (usa ${cfg.formatter})"
      ${if cfg.installLinter then ''
        $DRY_RUN_CMD echo "   - make lint    (usa statix)"
      '' else ""}
      $DRY_RUN_CMD echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    '';
  };
}

