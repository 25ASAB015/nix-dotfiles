# Yazi - Tema del Manager (panel principal)
# Colores y estilos del navegador de archivos
# Referencia: https://yazi-rs.github.io/docs/configuration/theme#manager
{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.terminal.software.yazi;
in
{
  config = lib.mkIf cfg.enable {
    programs.yazi.theme.mgr = {
      # Directorio actual (cwd = current working directory)
      cwd = { fg = "cyan"; };

      # ════════════════════════════════════════════════════════════════════════
      # HOVERED - Elemento seleccionado/resaltado
      # ════════════════════════════════════════════════════════════════════════
      hovered = {
        fg = "black";
        bg = "magenta";
      };

      preview_hovered = {
        fg = "black";
        bg = "magenta";
      };

      # ════════════════════════════════════════════════════════════════════════
      # FIND - Búsqueda interactiva
      # ════════════════════════════════════════════════════════════════════════
      find_keyword = {
        fg = "yellow";
        italic = true;
      };

      find_position = {
        fg = "magenta";
        bg = "reset";
        italic = true;
      };

      # ════════════════════════════════════════════════════════════════════════
      # MARKER - Indicadores de selección
      # ════════════════════════════════════════════════════════════════════════
      marker_selected = {
        fg = "green";
        # bg = "green";
      };

      marker_copied = {
        fg = "yellow";
        # bg = "yellow";
      };

      marker_cut = {
        fg = "red";
        # bg = "red";
      };

      # ════════════════════════════════════════════════════════════════════════
      # TAB - Pestañas (si usas múltiples)
      # ════════════════════════════════════════════════════════════════════════
      tab_active = {
        fg = "black";
        bg = "magenta";
      };

      tab_inactive = {
        fg = "white";
        bg = "darkgray";
      };

      tab_width = 1;

      # ════════════════════════════════════════════════════════════════════════
      # BORDER - Bordes de paneles
      # ════════════════════════════════════════════════════════════════════════
      border_symbol = "│";
      border_style = { fg = "gray"; };

      # ════════════════════════════════════════════════════════════════════════
      # OFFSET - Espaciado de paneles [arriba derecha abajo izquierda]
      # ════════════════════════════════════════════════════════════════════════
      folder_offset = [ 1 0 1 0 ];
      preview_offset = [ 1 1 1 1 ];

      # Tema de syntax highlighting (vacío = usar el por defecto)
      syntect_theme = "";
    };
  };
}
