{ pkgs, ... }:
{
  home.packages = [ pkgs.google-chrome ];
  # Puedes agregar variables de entorno propias aquí si lo deseas
  # home.sessionVariables = {
  #   GOOGLE_CHROME_EXTRA_FLAGS = "--some-flag";
  # };
}
