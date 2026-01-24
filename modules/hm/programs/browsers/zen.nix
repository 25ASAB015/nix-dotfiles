{ inputs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;

    # ════════════════════════════════════════════════════════════════════════════
    # POLICIES - Configuración de políticas de Firefox/Zen
    # ════════════════════════════════════════════════════════════════════════════
    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      # ══════════════════════════════════════════════════════════════════════════
      # EXTENSIONES - Agregar extensiones automáticamente
      # ══════════════════════════════════════════════════════════════════════════
      # Para agregar una nueva extensión:
      # 1. Obtén el ID de la extensión desde addons.mozilla.org
      #    - Puede estar en formato "ID@author" o "{UUID}"
      #    - Revisa la página de la extensión o el código fuente del .xpi
      # 2. Usa la URL de descarga directa del .xpi con el formato:
      #    https://addons.mozilla.org/firefox/downloads/latest/[extension-slug]/latest.xpi
      # 3. Agrega una entrada aquí con el formato:
      #
      #   "EXTENSION_ID" = {
      #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/extension-slug/latest.xpi";
      #     installation_mode = "force_installed";  # o "normal_installed"
      #   };
      #
      # Nota: El ID puede tener diferentes formatos:
      # - Formato con @: "uBlock0@raymondhill.net"
      # - Formato UUID: "{d633138d-6c8b-4493-84d1-909800a9d5b5}"
      #
      # Ejemplos de extensiones comunes:
      # - Bitwarden: "browserpass@bitwarden.com"
      # - Dark Reader: "addon@darkreader.org"
      # - Privacy Badger: "jid1-MnnxcxisBPnSXQ@jetpack"
      # - Multi-Account Containers: "@testpilot-containers"
      ExtensionSettings = {
        # Extensiones instaladas actualmente:
        
        # uBlock Origin - Bloqueador de anuncios
        # Formato de ID: "ID@author"
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        
        # 1Password X - Password Manager
        # Formato de ID: "{UUID}"
        # https://addons.mozilla.org/en-US/firefox/addon/1password-x-password-manager/
        # NOTA: Temporalmente comentado - puede causar problemas al iniciar
        # "{d633138d-6c8b-4493-84d1-909800a9d5b5}" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        #   installation_mode = "force_installed";
        # };
        
        # Agregar más extensiones aquí:
        # "OTRA_EXTENSION_ID" = {
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/extension-slug/latest.xpi";
        #   installation_mode = "force_installed";
        # };
      };
    };

    # ════════════════════════════════════════════════════════════════════════════
    # SETTINGS/PREFERENCIAS - Configuración personalizada de Zen
    # ════════════════════════════════════════════════════════════════════════════
    # Para agregar settings personalizados, usa 'extraPrefs' con sintaxis user.js
    # Referencia: https://kb.mozillazine.org/About:config_entries
    #
    # Settings actualmente configurados:
    # - DRM content habilitado (media.eme.enabled)
    # - Scrollbars siempre visibles (widget.gtk.overlay-scrollbars.enabled)
    # - Picture-in-Picture habilitado con controles
    # - Mantener reproducción en PiP al cambiar pestañas
    #
    # Para agregar más settings, agrega líneas con el formato:
    #   user_pref("preference.name", value);
    #
    # Ejemplos adicionales:
    # - Cambiar página de inicio: user_pref("browser.startup.homepage", "about:blank");
    # - Deshabilitar sugerencias: user_pref("browser.urlbar.showSearchSuggestionsFirst", false);
    # - Habilitar Wayland: user_pref("widget.wayland.enabled", true);
    # - Modo oscuro: user_pref("ui.systemUsesDarkTheme", 1);
    #
    # Para ver todas las preferencias disponibles, abre Zen y ve a about:config
    extraPrefs = ''
      # ════════════════════════════════════════════════════════════════════════
      # DRM Content - Habilitar reproducción de contenido DRM
      # ════════════════════════════════════════════════════════════════════════
      user_pref("media.eme.enabled", true);

      # ════════════════════════════════════════════════════════════════════════
      # Scrollbars - Mostrar siempre las barras de desplazamiento
      # ════════════════════════════════════════════════════════════════════════
      # Deshabilitar overlay scrollbars para mostrar siempre las barras
      user_pref("widget.gtk.overlay-scrollbars.enabled", false);

      # ════════════════════════════════════════════════════════════════════════
      # Picture-in-Picture - Habilitar controles de Picture-in-Picture
      # ════════════════════════════════════════════════════════════════════════
      user_pref("media.videocontrols.picture-in-picture.enabled", true);
      
      # Mantener reproducción de videos en Picture-in-Picture al cambiar pestañas
      user_pref("media.videocontrols.picture-in-picture.keep-playing-when-switching-tabs", true);
    '';

    # ════════════════════════════════════════════════════════════════════════════
    # ARCHIVOS DE PREFERENCIAS ADICIONALES (opcional)
    # ════════════════════════════════════════════════════════════════════════════
    # Si prefieres mantener las preferencias en archivos separados:
    # extraPrefsFiles = [
    #   ./zen-prefs.js
    # ];

    # ════════════════════════════════════════════════════════════════════════════
    # PERFILES - Configuración de perfiles (spaces, pins, keybindings, mods)
    # ════════════════════════════════════════════════════════════════════════════
    profiles = {
      default = {
        # ════════════════════════════════════════════════════════════════════════
        # KEYBINDINGS - Atajos de teclado personalizados
        # ════════════════════════════════════════════════════════════════════════
        # Para agregar un keybinding personalizado:
        # 1. Encuentra el ID del shortcut:
        #    - Abre Zen y ve a about:config
        #    - Busca "zen.keyboard.shortcuts.version" para ver la versión
        #    - O revisa ~/.zen/default/zen-keyboard-shortcuts.json después de ejecutar Zen
        # 2. Agrega una entrada aquí con el formato:
        #
        #   {
        #     id = "cmd_shortcutName";  # ID del shortcut en Zen
        #     key = "t";                 # Carácter de la tecla (opcional)
        #     keycode = "VK_W";          # Código de tecla virtual (opcional, alternativo a key)
        #     modifiers = {
        #       accel = true;    # Ctrl (Linux/Windows) o Cmd (macOS)
        #       control = true;  # Ctrl explícito
        #       alt = true;      # Alt
        #       shift = true;    # Shift
        #       meta = true;     # Meta/Windows/Command
        #     };
        #     disabled = false;  # true para deshabilitar el shortcut
        #   }
        #
        # IDs comunes de shortcuts en Zen:
        # - cmd_newTab: Nueva pestaña
        # - cmd_closeTab: Cerrar pestaña
        # - cmd_undoCloseTab: Reabrir pestaña cerrada
        # - cmd_newWindow: Nueva ventana
        # - cmd_toggleSidebar: Mostrar/ocultar sidebar
        # - cmd_goBack: Ir atrás
        # - cmd_goForward: Ir adelante
        # - cmd_reload: Recargar página
        # - cmd_find: Buscar en página
        #
        # Para encontrar más IDs, ejecuta Zen y revisa:
        # ~/.zen/default/zen-keyboard-shortcuts.json
        keyboardShortcuts = [
          # Agregar keybindings personalizados aquí:
          # {
          #   id = "cmd_newTab";
          #   key = "t";
          #   modifiers = {
          #     accel = true;
          #   };
          #   disabled = false;
          # }
        ];

        # Versión del schema de shortcuts (opcional, para validación)
        # Si Zen actualiza y cambia los shortcuts, esto previene errores silenciosos
        # Encuéntrala en about:config como "zen.keyboard.shortcuts.version"
        # keyboardShortcutsVersion = 1;

        # ════════════════════════════════════════════════════════════════════════
        # SPACES/WORKSPACES - Espacios de trabajo (opcional)
        # ════════════════════════════════════════════════════════════════════════
        # spaces = {
        #   work = {
        #     id = "uuid-aqui";  # Genera un UUID v4
        #     name = "Work";
        #     position = 0;
        #     icon = "💼";
        #   };
        # };

        # ════════════════════════════════════════════════════════════════════════
        # PINS - Pestañas fijadas (opcional)
        # ════════════════════════════════════════════════════════════════════════
        # pins = {
        #   gmail = {
        #     id = "uuid-aqui";
        #     title = "Gmail";
        #     url = "https://mail.google.com";
        #     position = 0;
        #   };
        # };

        # ════════════════════════════════════════════════════════════════════════
        # MODS - Temas desde la tienda de Zen (opcional)
        # ════════════════════════════════════════════════════════════════════════
        # Lista de UUIDs de mods desde https://zen-browser.github.io/theme-store/
        # mods = [
        #   "mod-uuid-1"
        #   "mod-uuid-2"
        # ];
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
