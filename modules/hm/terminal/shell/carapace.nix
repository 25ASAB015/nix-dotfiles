# Carapace - Autocompletado multi-shell
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://rsteube.github.io/carapace/
#
# Carapace proporciona autocompletado inteligente para cientos de comandos
# Soporta múltiples shells: fish, zsh, bash, nushell, etc.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.shell.carapace;
in
{
  options.modules.terminal.shell.carapace = {
    enable = lib.mkEnableOption "Carapace - autocompletado multi-shell";

    # ════════════════════════════════════════════════════════════════════════
    # Integración con Fish
    # ════════════════════════════════════════════════════════════════════════
    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Bridges (autocompletado heredado de otros shells)
    # ════════════════════════════════════════════════════════════════════════
    bridges = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "fish" "zsh" "bash" ];
      description = "Shells de los que heredar completados";
      example = [ "fish" "zsh" "bash" "inshellisense" ];
    };

    # ════════════════════════════════════════════════════════════════════════
    # Incluir inshellisense (AI completions de Microsoft)
    # ════════════════════════════════════════════════════════════════════════
    enableInshellisense = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Incluir inshellisense en bridges (completados con AI)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      carapace
      zsh          # Necesario para bridges
      bash         # Necesario para bridges
    ] ++ lib.optionals cfg.enableInshellisense [ pkgs.inshellisense ];

    # Variables de entorno para Carapace
    home.sessionVariables = {
      CARAPACE_BRIDGES = lib.concatStringsSep "," (
        cfg.bridges ++ lib.optionals cfg.enableInshellisense [ "inshellisense" ]
      );
      CARAPACE_CACHE_DIR = "${config.xdg.cacheHome}/carapace";
    };

    xdg.configFile = {
      # ══════════════════════════════════════════════════════════════════════
      # Configuración de Carapace
      # ══════════════════════════════════════════════════════════════════════
      "carapace/carapace.toml".text = ''
        [integrations.fish]
        enabled = ${if cfg.enableFishIntegration then "true" else "false"}
      '';

      # ══════════════════════════════════════════════════════════════════════
      # Inicialización para Fish
      # ══════════════════════════════════════════════════════════════════════
      "fish/completions/carapace.fish" = lib.mkIf cfg.enableFishIntegration {
        source = pkgs.runCommand "carapace-fish-init" {} ''
          ${pkgs.carapace}/bin/carapace _carapace fish > $out
        '';
      };
    };
  };
}
