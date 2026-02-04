{ pkgs, ... }:
{
  # ════════════════════════════════════════════════════════════════════════════
  # GOOGLE CHROME - Sin modificaciones (para trabajo)
  # ════════════════════════════════════════════════════════════════════════════
  # Chrome se instala sin flags ni modificaciones para mantener compatibilidad
  # con herramientas de trabajo y evitar problemas con sitios corporativos.
  # 
  # Si necesitas flags personalizados, puedes descomentar y agregar:
  # home.sessionVariables = {
  #   GOOGLE_CHROME_EXTRA_FLAGS = "--some-flag";
  # };
  home.packages = [ pkgs.google-chrome ];
}
