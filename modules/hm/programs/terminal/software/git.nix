# Git - Control de versiones con configuración avanzada
# Integrado desde Kaku: https://github.com/linuxmobile/kaku
# IMPORTANTE: Requiere desactivar hydenix.hm.git.enable = false
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.terminal.software.git;
  toINI = (pkgs.formats.ini {}).generate;
  configFile = "git/config";
  ignoreFile = "git/ignore";
in
{
  options.modules.terminal.software.git = {
    enable = lib.mkEnableOption "Git con configuración avanzada";

    # ════════════════════════════════════════════════════════════════════════
    # Identidad del usuario
    # ════════════════════════════════════════════════════════════════════════
    userName = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Tu nombre para commits (ej: 'Juan Pérez')";
      example = "Juan Pérez";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Tu email para commits";
      example = "juan@example.com";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Editor y herramientas
    # ════════════════════════════════════════════════════════════════════════
    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "Editor para commits y rebases";
      example = "code --wait";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Delta (pager mejorado con syntax highlighting)
    # ════════════════════════════════════════════════════════════════════════
    delta = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Usar delta como pager (diffs bonitos)";
      };

      sideBySide = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Mostrar diffs lado a lado";
      };
    };

    # ════════════════════════════════════════════════════════════════════════
    # Firma GPG (opcional)
    # ════════════════════════════════════════════════════════════════════════
    gpg = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Firmar commits con GPG";
      };

      signingKey = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "ID de la llave GPG para firmar";
        example = "ABCD1234EFGH5678";
      };
    };

    # ════════════════════════════════════════════════════════════════════════
    # Git LFS (archivos grandes)
    # ════════════════════════════════════════════════════════════════════════
    lfs.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Habilitar Git LFS para archivos grandes";
    };

    # ════════════════════════════════════════════════════════════════════════
    # Aliases personalizados
    # ════════════════════════════════════════════════════════════════════════
    extraAliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = "Aliases adicionales para git";
      example = { wip = "commit -am 'WIP'"; };
    };

    # ════════════════════════════════════════════════════════════════════════
    # Gitignore global
    # ════════════════════════════════════════════════════════════════════════
    ignorePatterns = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "*~"
        "*.swp"
        "*result*"
        ".direnv"
        "node_modules"
        ".DS_Store"
        "*.log"
      ];
      description = "Patrones para ignorar globalmente";
    };
  };

  config = lib.mkIf cfg.enable {
    # Paquetes necesarios
    home.packages = with pkgs; [
      git
      peco        # Para alias interactivos
    ] 
    ++ lib.optionals cfg.delta.enable [ delta ]
    ++ lib.optionals cfg.gpg.enable [ gnupg ]
    ++ lib.optionals cfg.lfs.enable [ git-lfs ];

    # Configuración principal de Git
    xdg.configFile."${configFile}".source = toINI "config" (
      {
        # ══════════════════════════════════════════════════════════════════
        # Aliases útiles
        # ══════════════════════════════════════════════════════════════════
        alias = {
          # Básicos
          st = "status";
          br = "branch";
          co = "checkout";
          d = "diff";
          
          # Commits
          ca = "commit -am";
          fuck = "commit --amend -m";  # Cambiar mensaje del último commit
          
          # Push/Pull simplificados
          pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
          ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
          
          # Historial visual
          hist = ''log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
          llog = ''log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
          
          # Interactivos (requieren fzf/peco)
          af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
          df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
        } // cfg.extraAliases;

        # ══════════════════════════════════════════════════════════════════
        # Core
        # ══════════════════════════════════════════════════════════════════
        core = {
          editor = cfg.editor;
          whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        } // lib.optionalAttrs cfg.delta.enable {
          pager = "${pkgs.delta}/bin/delta";
        };

        # ══════════════════════════════════════════════════════════════════
        # Configuración de ramas y merge
        # ══════════════════════════════════════════════════════════════════
        init = {
          defaultBranch = "main";
        };

        pull = {
          ff = "only";  # Solo fast-forward, evita merges automáticos
        };

        push = {
          autoSetupRemote = "true";
          default = "current";
        };

        merge = {
          conflictstyle = "diff3";  # Muestra ancestro común en conflictos
          stat = "true";
        };

        rebase = {
          autoSquash = "true";
          autoStash = "true";  # Stash automático antes de rebase
        };

        diff = {
          colorMoved = "default";
        };

        rerere = {
          enabled = "true";      # Recordar resolución de conflictos
          autoupdate = "true";
        };

        # ══════════════════════════════════════════════════════════════════
        # Usuario (si está configurado)
        # ══════════════════════════════════════════════════════════════════
        user = lib.optionalAttrs (cfg.userName != "") {
          name = cfg.userName;
        } // lib.optionalAttrs (cfg.userEmail != "") {
          email = cfg.userEmail;
        } // lib.optionalAttrs (cfg.gpg.enable && cfg.gpg.signingKey != "") {
          signingKey = cfg.gpg.signingKey;
        };
      }

      # ════════════════════════════════════════════════════════════════════
      # Delta (pager mejorado) - solo si está habilitado
      # ════════════════════════════════════════════════════════════════════
      // lib.optionalAttrs cfg.delta.enable {
        delta = {
          features = "unobtrusive-line-numbers decorations";
          navigate = "true";
          "side-by-side" = if cfg.delta.sideBySide then "true" else "false";
          "true-color" = "never";
        };

        "delta-decorations" = {
          "commit-decoration-style" = "bold grey box ul";
          "file-decoration-style" = "ul";
          "file-style" = "bold blue";
          "hunk-header-decoration-style" = "box";
        };

        "delta-unobtrusive-line-numbers" = {
          "line-numbers" = "true";
          "line-numbers-left-format" = "{nm:>4}│";
          "line-numbers-left-style" = "grey";
          "line-numbers-right-format" = "{np:>4}│";
          "line-numbers-right-style" = "grey";
        };

        interactive = {
          diffFilter = "${pkgs.delta}/bin/delta --color-only";
        };
      }

      # ════════════════════════════════════════════════════════════════════
      # GPG - solo si está habilitado
      # ════════════════════════════════════════════════════════════════════
      // lib.optionalAttrs cfg.gpg.enable {
        commit = {
          gpgSign = "true";
        };

        tag = {
          gpgSign = "true";
        };

        gpg = {
          format = "openpgp";
        };

        "gpg-openpgp" = {
          program = "${pkgs.gnupg}/bin/gpg";
        };
      }

      # ════════════════════════════════════════════════════════════════════
      # Git LFS - solo si está habilitado
      # ════════════════════════════════════════════════════════════════════
      // lib.optionalAttrs cfg.lfs.enable {
        "filter-lfs" = {
          clean = "git-lfs clean -- %f";
          process = "git-lfs filter-process";
          required = "true";
          smudge = "git-lfs smudge -- %f";
        };
      }
    );

    # Gitignore global
    xdg.configFile."${ignoreFile}".text = 
      lib.concatStringsSep "\n" cfg.ignorePatterns;
  };
}
