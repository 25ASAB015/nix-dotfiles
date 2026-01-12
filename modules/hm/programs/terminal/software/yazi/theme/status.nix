# Yazi - Tema de la barra de estado
# Colores y estilos del status bar inferior
# Referencia: https://yazi-rs.github.io/docs/configuration/theme#status
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
    programs.yazi.theme.status = {
      # ════════════════════════════════════════════════════════════════════════
      # SEPARATORS - Separadores entre secciones
      # ════════════════════════════════════════════════════════════════════════
      separator_open = "█";
      separator_close = "█";
      separator_style = {
        fg = "darkgray";
        bg = "darkgray";
      };

      # ════════════════════════════════════════════════════════════════════════
      # MODE - Indicador de modo (normal, select, unset)
      # ════════════════════════════════════════════════════════════════════════
      # Modo normal: navegación estándar
      mode_normal = {
        fg = "black";
        bg = "blue";
        bold = true;
      };

      # Modo select: seleccionando archivos (V para visual)
      mode_select = {
        fg = "black";
        bg = "green";
        bold = true;
      };

      # Modo unset: sin modo activo
      mode_unset = {
        fg = "black";
        bg = "magenta";
        bold = true;
      };

      # ════════════════════════════════════════════════════════════════════════
      # PROGRESS - Barra de progreso (para operaciones)
      # ════════════════════════════════════════════════════════════════════════
      progress_label = { bold = true; };

      progress_normal = {
        fg = "magenta";
        bg = "black";
      };

      progress_error = {
        fg = "red";
        bg = "black";
      };

      # ════════════════════════════════════════════════════════════════════════
      # PERMISSIONS - Permisos de archivos (rwx)
      # ════════════════════════════════════════════════════════════════════════
      permissions_t = { fg = "magenta"; };  # Tipo (d para directorio, - para archivo)
      permissions_r = { fg = "yellow"; };   # Read (lectura)
      permissions_w = { fg = "red"; };      # Write (escritura)
      permissions_x = { fg = "green"; };    # Execute (ejecución)
      permissions_s = { fg = "darkgray"; }; # Special (sticky, setuid, etc)
    };
  };
}
