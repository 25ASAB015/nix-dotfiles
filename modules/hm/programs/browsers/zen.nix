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
  xdg.mimeApps.defaultApplications = {
    "text/html" = "zen-browser.desktop";
    "x-scheme-handler/http" = "zen-browser.desktop";
    "x-scheme-handler/https" = "zen-browser.desktop";
    "x-scheme-handler/about" = "zen-browser.desktop";
    "x-scheme-handler/unknown" = "zen-browser.desktop";
  };
}
