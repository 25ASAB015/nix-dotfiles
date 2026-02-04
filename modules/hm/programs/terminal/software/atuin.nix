# Atuin - Historial de shell mágico con sincronización
# Integrado desde kakunew: /home/ravn/Downloads/kakunew/home/terminal/software/atuin.nix
# Documentación: https://docs.atuin.sh/configuration/config/
#
# Atuin reemplaza el historial de shell con una base de datos SQLite
# que permite búsqueda fuzzy, sincronización entre máquinas, y más.
{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.terminal.software.atuin;
in
{
  options.modules.terminal.software.atuin = {
    enable = lib.mkEnableOption "Atuin - historial de shell mejorado";

    enableFishIntegration = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar integración con Fish shell";
    };

    # No habilitar para zsh por defecto (Hydenix maneja zsh)
    enableZshIntegration = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Habilitar integración con Zsh (deshabilitado por defecto para no afectar Hydenix)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      enableFishIntegration = cfg.enableFishIntegration;
      enableZshIntegration = cfg.enableZshIntegration;
      
      # Deshabilitar up arrow para no interferir con navegación normal
      flags = [ "--disable-up-arrow" ];
      
      settings = {
        # ══════════════════════════════════════════════════════════════════
        # Sincronización
        # ══════════════════════════════════════════════════════════════════
        auto_sync = false;          # No sincronizar automáticamente
        update_check = false;       # No buscar actualizaciones
        sync = {
          records = true;
        };

        # ══════════════════════════════════════════════════════════════════
        # Búsqueda
        # ══════════════════════════════════════════════════════════════════
        search_mode = "skim";       # Usar skim para búsqueda fuzzy
        filter_mode = "host";       # Filtrar por host actual
        filter_mode_shell_up_key_binding = "session";  # Up arrow filtra por sesión
        
        # ══════════════════════════════════════════════════════════════════
        # Interfaz
        # ══════════════════════════════════════════════════════════════════
        style = "compact";          # Estilo compacto
        inline_height = 7;          # Altura del menú inline
        show_help = false;          # No mostrar ayuda
        enter_accept = true;        # Enter acepta selección
        
        # ══════════════════════════════════════════════════════════════════
        # Comportamiento
        # ══════════════════════════════════════════════════════════════════
        workspaces = false;         # No usar workspaces
        ctrl_n_shortcuts = true;    # Habilitar Ctrl+N shortcuts
        dialect = "uk";             # Formato de fecha UK
        keymap_mode = "vim-normal"; # Modo vim para navegación
        
        # ══════════════════════════════════════════════════════════════════
        # Filtros
        # ══════════════════════════════════════════════════════════════════
        history_filter = [ "shit" ]; # Comandos a ignorar
      };
    };
  };
}
