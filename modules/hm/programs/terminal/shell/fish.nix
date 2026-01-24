# Fish Shell - Configuración completa con plugins
# Integrado desde kakunew: /home/ludus/Downloads/kakunew/home/terminal/shell/fish.nix
# Usa programs.fish de Home Manager para mejor integración
#
# NOTA: Starship se configura por separado en starship.nix
# con archivo TOML exclusivo para Fish (no afecta zsh)
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.shell.fish;
in
{
  options.modules.terminal.shell.fish = {
    enable = lib.mkEnableOption "Fish shell con configuración completa";

    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "Editor por defecto (EDITOR y VISUAL)";
    };

    nixosHost = lib.mkOption {
      type = lib.types.str;
      default = "hydenix";
      description = "Nombre del host para comandos nixos-rebuild";
    };
  };

  config = lib.mkIf cfg.enable {
    # Paquete adicional para colorear output
    home.packages = with pkgs; [ grc ];

    # Forzar EDITOR a nvim (sobrescribe configuración de Hydenix)
    home.sessionVariables = {
      EDITOR = lib.mkForce cfg.editor;
      VISUAL = lib.mkForce cfg.editor;
    };

    programs = {
      # ══════════════════════════════════════════════════════════════════════
      # Fish Shell
      # ══════════════════════════════════════════════════════════════════════
      fish = {
        enable = true;

        # ════════════════════════════════════════════════════════════════════
        # Variables de entorno (se cargan primero)
        # ════════════════════════════════════════════════════════════════════
        shellInit = ''
          # Cargar secrets desde agenix (si existen)
          if test -f /run/agenix/discordo
            set -gx DISCORDO_TOKEN (cat /run/agenix/discordo)
            set -gx OXICORD_TOKEN (cat /run/agenix/discordo)
          end
          if test -f /run/agenix/openrouter
            set -gx OPENROUTER_API_KEY (cat /run/agenix/openrouter)
          end
          if test -f /run/agenix/github
            set -gx GITHUB_TOKEN (cat /run/agenix/github)
          end
          if test -f /run/agenix/twt
            set -gx TWT_TOKEN (cat /run/agenix/twt)
          end

          set -gx NIXPKGS_ALLOW_UNFREE 1
          set -gx NIXPKGS_ALLOW_INSECURE 1
          set -gx EDITOR ${cfg.editor}
          set -gx VISUAL ${cfg.editor}

          # Desactivar mensaje de bienvenida
          set -g fish_greeting
        '';

        # ════════════════════════════════════════════════════════════════════
        # Configuración interactiva (keybindings, colores, etc.)
        # ════════════════════════════════════════════════════════════════════
        interactiveShellInit = ''
          # Vi keybindings
          fish_vi_key_bindings

          # Custom key bindings function (REQUIRED to properly unbind keys)
          function fish_user_key_bindings
            # Custom bindings
            for mode in insert default
              bind -M $mode ctrl-backspace backward-kill-word
              bind -M $mode ctrl-z undo
              bind -M $mode ctrl-b beginning-of-line
              bind -M $mode ctrl-e end-of-line
            end

            bind -M insert \cx\ce edit_command_buffer
            bind -M default \cx\ce edit_command_buffer

            # History search with prefix (like nushell)
            bind -M insert up history-prefix-search-backward
            bind -M insert down history-prefix-search-forward
            bind -M default up history-prefix-search-backward
            bind -M default down history-prefix-search-forward

            # UNBIND alt-s and alt-v completely (for Zellij)
            bind -M insert alt-s ""
            bind -M default alt-s ""
            bind -M insert alt-v ""
            bind -M default alt-v ""
            bind -M insert alt-z ""
            bind -M default alt-z ""
          end

          # Cursor shapes per mode
          set fish_cursor_default block
          set fish_cursor_insert line
          set fish_cursor_replace_one underscore
          set fish_cursor_visual block

          # Syntax colors
          set -g fish_color_autosuggestion brblack
          set -g fish_color_command blue
          set -g fish_color_error red
          set -g fish_color_param normal

          # Path adicional
          fish_add_path ~/.local/bin

          # Search highlight
          set -g fish_color_search_match --background=normal

          # Plugin settings
          set -Ux fifc_editor ${cfg.editor}
          set -U fifc_keybinding \cv
          set -g __done_min_cmd_duration 10000
          set -g sudope_sequence \cs
        '';

        # ════════════════════════════════════════════════════════════════════
        # Funciones personalizadas
        # ════════════════════════════════════════════════════════════════════
        functions = {
          # Navegar a directorio con fuzzy finder
          fcd = ''
            set -l dir (fd --type d | sk | string trim)
            if test -n "$dir"
              cd $dir
            end
          '';

          # Ver paquetes instalados en el sistema
          installed = ''
            nix-store --query --requisites /run/current-system/ | string replace -r '.*?-(.*)' '$1' | sort | uniq | sk
          '';

          # Ver todos los paquetes con path completo y copiar
          installedall = ''
            nix-store --query --requisites /run/current-system/ | sk | wl-copy
          '';

          # File manager con Yazi que cambia al directorio al salir
          fm = ''
            set -l tmp (mktemp -t "yazi-cwd.XXXXX")
            yazi $argv --cwd-file $tmp
            set -l cwd (cat $tmp)
            if test -n "$cwd" -a "$cwd" != "$PWD"
              cd $cwd
            end
            rm -f $tmp
          '';

          # Buscar en archivos tracked por git
          gitgrep = ''
            git ls-files | rg $argv
          '';
        };

        # ════════════════════════════════════════════════════════════════════
        # Abbreviations (se expanden automáticamente)
        # ════════════════════════════════════════════════════════════════════
        shellAbbrs = {
          z = "zoxide query";
          zi = "zoxide query -i";
        };

        # ════════════════════════════════════════════════════════════════════
        # Aliases
        # ════════════════════════════════════════════════════════════════════
        shellAliases = {
          # NixOS - Mantenimiento
          cleanup = "sudo nix-collect-garbage --delete-older-than 1d";
          listgen = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
          nixremove = "nix-store --gc";
          bloat = "nix path-info -Sh /run/current-system";
          cleanram = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'";
          trimall = "sudo fstrim -va";

          # Navegación
          c = "clear";
          q = "exit";
          temp = "cd /tmp/";

          # NixOS rebuild (usa el host configurado)
          test-build = "sudo nixos-rebuild test --flake .#${cfg.nixosHost}";
          switch-build = "sudo nixos-rebuild switch --flake .#${cfg.nixosHost}";

          # Git
          add = "git add .";
          commit = "git commit";
          push = "git push";
          pull = "git pull";
          diff = "git diff --staged";
          gcld = "git clone --depth 1";
          gitui = "lazygit";

          # Herramientas mejoradas
          l = "eza -lF --time-style=long-iso --icons";
          ll = "eza -h --git --icons --color=auto --group-directories-first -s extension";
          tree = "eza --tree --icons --tree";
          cat = "${pkgs.bat}/bin/bat --paging=never";
          moon = "${pkgs.curlMinimal}/bin/curl -s wttr.in/Moon";
          weather = "${pkgs.curlMinimal}/bin/curl -s wttr.in";
          store-path = "${pkgs.coreutils-full}/bin/readlink (${pkgs.which}/bin/which $argv)";

          # Systemd
          us = "systemctl --user";
          rs = "sudo systemctl";

          # Apps
          zed = "zeditor";
        };

        # ════════════════════════════════════════════════════════════════════
        # Plugins
        # ════════════════════════════════════════════════════════════════════
        plugins = with pkgs.fishPlugins; [
          {
            name = "autopair";      # Cierra paréntesis/comillas automáticamente
            src = autopair.src;
          }
          {
            name = "done";          # Notificación cuando termina comando largo
            src = done.src;
          }
          {
            name = "bass";          # Ejecutar scripts bash en fish
            src = bass.src;
          }
          {
            name = "plugin-git";    # Aliases de git extendidos
            src = plugin-git.src;
          }
          {
            name = "plugin-sudope"; # Ctrl+S para agregar sudo
            src = plugin-sudope.src;
          }
          {
            name = "humantime-fish"; # Formato legible de tiempo
            src = humantime-fish.src;
          }
          {
            name = "fifc";          # Fuzzy finder para completions
            src = fifc.src;
          }
          {
            name = "grc";           # Coloriza output de comandos
            src = grc.src;
          }
          {
            name = "puffer";        # Expande ... a ../..
            src = puffer.src;
          }
        ];
      };
    };
  };
}
