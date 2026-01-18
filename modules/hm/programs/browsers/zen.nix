{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;

    policies = {
      DisableAppUpdate = true;

      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  # ════════════════════════════════════════════════════════════════════════════
  # XDG MIME APPS - Establecer Zen Browser como navegador por defecto
  # ════════════════════════════════════════════════════════════════════════════
  # Esto configura los handlers MIME para que zen-browser abra enlaces http/https
  # IMPORTANTE: El archivo .desktop se llama "zen-twilight.desktop" (no "zen-browser.desktop")
  # IMPORTANTE: Después de hacer 'make switch', necesitas reiniciar sesión para
  # que los cambios surtan efecto completamente. También puedes ejecutar:
  #   xdg-settings set default-web-browser zen-twilight.desktop
  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen-twilight.desktop";
    "x-scheme-handler/http" = "zen-twilight.desktop";
    "x-scheme-handler/https" = "zen-twilight.desktop";
    "x-scheme-handler/about" = "zen-twilight.desktop";
    "x-scheme-handler/unknown" = "zen-twilight.desktop";
  };

  # ════════════════════════════════════════════════════════════════════════════
  # VARIABLE DE ENTORNO - Establecer BROWSER para Hyprland y scripts
  # ════════════════════════════════════════════════════════════════════════════
  # Nota: El ejecutable se llama "zen", no "zen-browser"
  # Esta variable es usada por Hyprland ($BROWSER) y algunos scripts de terminal
  home.sessionVariables = {
    BROWSER = "zen";
  };
}
