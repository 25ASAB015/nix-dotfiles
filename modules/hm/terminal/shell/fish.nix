# Fish Shell - Shell moderno e interactivo
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# Documentación: https://fishshell.com/docs/current/
# 
# IMPORTANTE: Este módulo configura Fish de forma completa con:
# - Keybindings Vi mode
# - Variables de entorno
# - Funciones personalizadas (fcd, fm, gitgrep, etc.)
# - Aliases útiles para NixOS y Git
# - Integración con herramientas (zoxide, fzf, etc.)
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
    
    # ════════════════════════════════════════════════════════════════════════
    # Editor por defecto
    # ════════════════════════════════════════════════════════════════════════
    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "Editor por defecto (EDITOR y VISUAL)";
      example = "hx";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Vi Keybindings
    # ════════════════════════════════════════════════════════════════════════
    viMode = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Usar keybindings estilo Vi";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Host para rebuild (usado en aliases)
    # ════════════════════════════════════════════════════════════════════════
    nixosHost = lib.mkOption {
      type = lib.types.str;
      default = "hydenix";
      description = "Nombre del host para comandos nixos-rebuild";
      example = "aesthetic";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Aliases adicionales
    # ════════════════════════════════════════════════════════════════════════
    extraAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Aliases adicionales personalizados";
      example = {
        myalias = "echo 'Hola mundo'";
      };
    };

    # ════════════════════════════════════════════════════════════════════════
    # Funciones extra
    # ════════════════════════════════════════════════════════════════════════
    extraFunctions = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Funciones Fish adicionales (nombre -> código)";
      example = {
        hello = "echo 'Hello, world!'";
      };
    };

    # ════════════════════════════════════════════════════════════════════════
    # Configuración inicial extra
    # ════════════════════════════════════════════════════════════════════════
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Configuración adicional para config.fish";
      example = ''
        set -gx MY_VAR "value"
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Paquetes necesarios
    home.packages = with pkgs; [
      fish
      grc          # Generic colorizer
      fd           # Alternativa rápida a find (usado en fcd)
      skim         # Fuzzy finder (alternativa a fzf)
      eza          # Alternativa moderna a ls
      bat          # Alternativa a cat con syntax highlighting
    ];

    # ══════════════════════════════════════════════════════════════════════════
    # Configuración principal de Fish
    # ══════════════════════════════════════════════════════════════════════════
    xdg.configFile = {
      # Archivo principal config.fish
      "fish/config.fish".text = ''
        # ════════════════════════════════════════════════════════════════════
        # Variables de entorno
        # ════════════════════════════════════════════════════════════════════
        set -gx NIXPKGS_ALLOW_UNFREE 1
        set -gx NIXPKGS_ALLOW_INSECURE 1
        set -gx EDITOR ${cfg.editor}
        set -gx VISUAL ${cfg.editor}

        # Desactivar el mensaje de bienvenida
        set -g fish_greeting

        ${lib.optionalString cfg.viMode ''
        # ════════════════════════════════════════════════════════════════════
        # Vi keybindings
        # ════════════════════════════════════════════════════════════════════
        fish_vi_key_bindings

        # Función de keybindings personalizada
        function fish_user_key_bindings
          # Keybindings útiles para insert y default mode
          for mode in insert default
            bind -M $mode ctrl-backspace backward-kill-word
            bind -M $mode ctrl-z undo
            bind -M $mode ctrl-b beginning-of-line
            bind -M $mode ctrl-e end-of-line
          end

          # Editar comando en editor externo
          bind -M insert \cx\ce edit_command_buffer
          bind -M default \cx\ce edit_command_buffer

          # Búsqueda en historial con prefijo (como nushell)
          bind -M insert up history-prefix-search-backward
          bind -M insert down history-prefix-search-forward
          bind -M default up history-prefix-search-backward
          bind -M default down history-prefix-search-forward

          # Desvincular alt-s y alt-v (para Zellij/tmux)
          bind -M insert alt-s ""
          bind -M default alt-s ""
          bind -M insert alt-v ""
          bind -M default alt-v ""
        end

        # Formas del cursor según modo Vi
        set fish_cursor_default block
        set fish_cursor_insert line
        set fish_cursor_replace_one underscore
        set fish_cursor_visual block
        ''}

        # ════════════════════════════════════════════════════════════════════
        # Colores de sintaxis
        # ════════════════════════════════════════════════════════════════════
        set -g fish_color_autosuggestion brblack
        set -g fish_color_command blue
        set -g fish_color_error red
        set -g fish_color_param normal
        set -g fish_color_search_match --background=normal

        # ════════════════════════════════════════════════════════════════════
        # Configuración extra del usuario
        # ════════════════════════════════════════════════════════════════════
        ${cfg.extraConfig}
      '';

      # ══════════════════════════════════════════════════════════════════════
      # Aliases - Comandos abreviados
      # ══════════════════════════════════════════════════════════════════════
      "fish/conf.d/aliases.fish".text = ''
        # ═══════════════════════════════════════════════════════════════════
        # NixOS - Mantenimiento del sistema
        # ═══════════════════════════════════════════════════════════════════
        alias cleanup="sudo nix-collect-garbage --delete-older-than 1d"
        alias listgen="sudo nix-env -p /nix/var/nix/profiles/system --list-generations"
        alias nixremove="nix-store --gc"
        alias bloat="nix path-info -Sh /run/current-system"
        alias cleanram="sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'"
        alias trimall="sudo fstrim -va"
        
        # Rebuild rápido
        alias test-build="sudo nixos-rebuild test --flake .#${cfg.nixosHost}"
        alias switch-build="sudo nixos-rebuild switch --flake .#${cfg.nixosHost}"

        # ═══════════════════════════════════════════════════════════════════
        # Navegación y utilidades
        # ═══════════════════════════════════════════════════════════════════
        alias c="clear"
        alias q="exit"
        alias temp="cd /tmp/"

        # ═══════════════════════════════════════════════════════════════════
        # Git - Operaciones comunes
        # ═══════════════════════════════════════════════════════════════════
        alias add="git add ."
        alias commit="git commit"
        alias push="git push"
        alias pull="git pull"
        alias diff="git diff --staged"
        alias gcld="git clone --depth 1"
        alias gitui="lazygit"

        # ═══════════════════════════════════════════════════════════════════
        # Herramientas mejoradas (eza, bat)
        # ═══════════════════════════════════════════════════════════════════
        alias l="eza -lF --time-style=long-iso --icons"
        alias ll="eza -h --git --icons --color=auto --group-directories-first -s extension"
        alias tree="eza --tree --icons --tree"
        alias cat="${pkgs.bat}/bin/bat --paging=never"

        # ═══════════════════════════════════════════════════════════════════
        # Info del clima (fun)
        # ═══════════════════════════════════════════════════════════════════
        alias moon="${pkgs.curlMinimal}/bin/curl -s wttr.in/Moon"
        alias weather="${pkgs.curlMinimal}/bin/curl -s wttr.in"

        # ═══════════════════════════════════════════════════════════════════
        # Systemd
        # ═══════════════════════════════════════════════════════════════════
        alias us="systemctl --user"
        alias rs="sudo systemctl"

        # ═══════════════════════════════════════════════════════════════════
        # Aliases extra del usuario
        # ═══════════════════════════════════════════════════════════════════
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "alias ${name}=\"${value}\"") cfg.extraAliases)}
      '';

      # ══════════════════════════════════════════════════════════════════════
      # Abbreviations - Se expanden automáticamente
      # ══════════════════════════════════════════════════════════════════════
      "fish/conf.d/abbreviations.fish".text = ''
        abbr -a z "zoxide query"
        abbr -a zi "zoxide query -i"
      '';

      # ══════════════════════════════════════════════════════════════════════
      # Funciones personalizadas
      # ══════════════════════════════════════════════════════════════════════
      
      # fcd - Navegar a cualquier directorio con fuzzy finder
      "fish/functions/fcd.fish".text = ''
        function fcd
          set -l dir (fd --type d | sk | string trim)
          if test -n "$dir"
            cd $dir
          end
        end
      '';

      # fm - File manager con Yazi que cambia al directorio al salir
      "fish/functions/fm.fish".text = ''
        function fm
          set -l tmp (mktemp -t "yazi-cwd.XXXXX")
          yazi $argv --cwd-file $tmp
          set -l cwd (cat $tmp)
          if test -n "$cwd" -a "$cwd" != "$PWD"
            cd $cwd
          end
          rm -f $tmp
        end
      '';

      # gitgrep - Buscar en archivos tracked por git
      "fish/functions/gitgrep.fish".text = ''
        function gitgrep
          git ls-files | rg $argv
        end
      '';

      # installed - Ver paquetes instalados en el sistema
      "fish/functions/installed.fish".text = ''
        function installed
          nix-store --query --requisites /run/current-system/ | string replace -r '.*?-(.*)' '$1' | sort | uniq | sk
        end
      '';

      # installedall - Ver todos los paquetes con path completo
      "fish/functions/installedall.fish".text = ''
        function installedall
          nix-store --query --requisites /run/current-system/ | sk | wl-copy
        end
      '';
    } 
    # Agregar funciones extra del usuario
    // lib.mapAttrs' (name: value: {
      name = "fish/functions/${name}.fish";
      value.text = ''
        function ${name}
          ${value}
        end
      '';
    }) cfg.extraFunctions;
  };
}
