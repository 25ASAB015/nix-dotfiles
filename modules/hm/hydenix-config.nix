# modules/hm/hydenix-config.nix
# Hydenix home-manager configuration
# This file contains all modules.* configurations (the actual settings)
{ ... }:

{
  # ════════════════════════════════════════════════════════════════════════════
  # GIT - Control de versiones con configuración avanzada
  # ════════════════════════════════════════════════════════════════════════════
  # IMPORTANTE: hydenix.hm.git.enable = false (configured below)
  modules.terminal.software.git = {
    enable = true;
    userName = "Roberto Flores";         # Tu nombre para commits
    userEmail = "25asab015@ujmd.edu.sv"; # Tu email
    editor = "nvim";                     # Editor para commits
    delta.enable = true;                 # Diffs bonitos con syntax highlighting
    delta.sideBySide = true;             # Vista lado a lado
    lfs.enable = true;                   # Git LFS para archivos grandes
    # GPG signing
    gpg.enable = true;
    gpg.signingKey = "A2EFB4449AD569C6";
  };

  # ════════════════════════════════════════════════════════════════════════════
  # GITHUB CLI - Herramienta oficial de GitHub para terminal
  # ════════════════════════════════════════════════════════════════════════════
  # Documentación: https://cli.github.com/manual/
  modules.terminal.software.gh = {
    enable = true;
    editor = "nano";        # Editor preferido: "nvim", "hx", "code"
    username = "25asab015"; # Usuario de GitHub
    gitProtocol = "https";  # o "ssh" si tienes configurado SSH keys
    # browser = "firefox";  # Descomenta para usar un navegador específico
  };

  # ════════════════════════════════════════════════════════════════════════════
  # LAZYGIT - Interfaz TUI para Git
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: ejecutar `lazygit` en cualquier repositorio
  modules.terminal.software.lazygit = {
    enable = true;
    signOffCommits = true;    # Agregar firma a commits
    nerdFontsVersion = "3";   # Versión de Nerd Fonts para iconos
  };

  # ════════════════════════════════════════════════════════════════════════════
  # NIX DEVELOPMENT TOOLS - Linters y formatters para desarrollo en Nix
  # ════════════════════════════════════════════════════════════════════════════
  # Herramientas necesarias para `make format` y `make lint`
  # - nixpkgs-fmt/alejandra: formatea archivos .nix
  # - statix: linter estático para Nix (detecta problemas y malas prácticas)
  modules.development.nix-tools = {
    enable = true;
    formatter = "nixpkgs-fmt";  # o "alejandra"
    installLinter = true;        # instala statix
  };

  # ════════════════════════════════════════════════════════════════════════════
  # DIRENV - Carga automática de entornos por directorio
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: echo "use nix" > .envrc en tu proyecto, luego direnv allow
  # Al entrar al directorio, carga el entorno automáticamente (nix-shell, variables, etc.)
  # Integración automática con Fish y Zsh (detecta shells habilitados)
  # Documentación: https://direnv.net/
  modules.development.direnv.enable = true;

  # ════════════════════════════════════════════════════════════════════════════
  # ATUIN - Historial de shell mejorado con búsqueda fuzzy
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: Ctrl+R para buscar en historial
  # Documentación: https://docs.atuin.sh/
  modules.terminal.software.atuin = {
    enable = true;
    enableFishIntegration = true;   # Solo para Fish
    enableZshIntegration = false;   # No afectar zsh/Hydenix
  };

  # ════════════════════════════════════════════════════════════════════════════
  # YAZI - File manager moderno para terminal
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: ejecutar `yazi` o `y` (con fish) para navegar archivos
  # Controles: hjkl para navegar, Enter para abrir, q para salir
  # Documentación: https://yazi-rs.github.io/docs/
  modules.terminal.software.yazi = {
    enable = true;
    enableFishIntegration = true;   # Habilita comando `y` en Fish
    showHidden = false;             # true para mostrar archivos ocultos
    sortDirFirst = true;            # Directorios antes que archivos
    layout = [ 1 4 3 ];             # Proporciones [izq medio der]
    darkFlavor = "noctalia";        # Tema oscuro
  };

  # ════════════════════════════════════════════════════════════════════════════
  # CLI TOOLS - Colección de herramientas modernas de terminal
  # ════════════════════════════════════════════════════════════════════════════
  # Incluye: eza (ls), fzf (fuzzy), ripgrep (grep), dust (du), duf (df), fd (find)
  # TUI Apps: discordo (Discord), reddit-tui, scope-tui (audio visualizer)
  # Dev Tools: lua-language-server, nixd, stylua, prettierd, gotools
  # Mynixpkgs: bmm, dawn, dfft, lightview, nekot, omm, orchat, prs
  modules.terminal.software.cli = {
    enable = true;
    enableFishIntegration = true;   # Integración con Fish
    archives = true;                # zip, unzip, unrar
    systemUtils = true;             # dust, duf, fd, jq, glow, gtt, zfxtop, inshellisense
    tuiApps = true;                 # discordo, reddit-tui, scope-tui
    devTools = true;                # LSPs y formatters (lua-language-server, nixd, stylua, prettierd, gotools)
    mynixpkgsApps = true;           # bmm, dawn, dfft, lightview, nekot, omm, orchat, prs
    eza = true;                     # ls moderno con iconos
    fzf = true;                     # Buscador fuzzy (Ctrl+T)
    ripgrep = true;                 # grep ultrarrápido (rg)
  };

  # ════════════════════════════════════════════════════════════════════════════
  # SKIM - Fuzzy finder escrito en Rust (alternativa a fzf)
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: sk, Ctrl+T (archivos), Ctrl+R (historial), Alt+C (directorios)
  # Documentación: https://github.com/lotabout/skim
  modules.terminal.software.skim = {
    enable = true;
    enableFishIntegration = true;   # Keybindings en Fish
    defaultCommand = "rg --files --hidden";
    # Preview de directorios con eza
    changeDirWidgetOptions = [
      "--preview 'eza --icons --git --color always -T -L 3 {} | head -200'"
      "--exact"
    ];
  };

  # ════════════════════════════════════════════════════════════════════════════
  # BAT - cat con syntax highlighting
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: bat archivo.txt, bat -p (sin decoración), bat --list-themes
  # Documentación: https://github.com/sharkdp/bat
  modules.terminal.software.bat = {
    enable = true;
    theme = "base16";           # Tema de colores
    style = "plain";            # Estilo: plain, full, auto, changes
    useAsManPager = true;       # Coloriza man pages
  };

  # ════════════════════════════════════════════════════════════════════════════
  # BOTTOM - Monitor de sistema moderno (reemplazo de htop/btop)
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: btm, btop (alias), htop (alias modo básico)
  # Documentación: https://clementtsang.github.io/bottom/
  modules.terminal.software.bottom = {
    enable = true;
    enableGpu = true;           # Monitorear GPU
    groupProcesses = true;      # Agrupar procesos con mismo nombre
    createAliases = true;       # Crear btop/htop como aliases
  };

  # ════════════════════════════════════════════════════════════════════════════
  # OPENCODE - Terminal AI Assistant (Claude, Gemini, GPT, etc.)
  # ════════════════════════════════════════════════════════════════════════════
  # Uso: opencode "pregunta" o simplemente opencode para modo interactivo
  # Incluye: Skills especializados, integración con LSP, formatters
  # Plugin antigravity: acceso gratuito a modelos premium
  # Documentación: https://github.com/anomalyco/opencode
  modules.terminal.software.opencode = {
    enable = true;
    smallModel = "google/gemma-3n-e4b-it:free";  # Modelo pequeño gratuito
    autoupdate = false;                           # Desactivar updates automáticos
    share = "disabled";                           # No compartir datos de uso
    enabledProviders = ["openrouter" "google"];   # Proveedores habilitados
    # MCP Servers (Model Context Protocol) para extender capacidades
    mcp = {
      gh_grep = {
        type = "remote";
        url = "https://mcp.grep.app/";
        enabled = true;
        timeout = 10000;
      };
      deepwiki = {
        type = "remote";
        url = "https://mcp.deepwiki.com/mcp";
        enabled = true;
        timeout = 10000;
      };
      context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        enabled = true;
        timeout = 10000;
      };
    };
  };

  # ════════════════════════════════════════════════════════════════════════════
  # EMULADORES DE TERMINAL
  # ════════════════════════════════════════════════════════════════════════════

  # FOOT - Terminal ligera para Wayland
  # Uso: foot, foot -e comando
  # Muy ligera y rápida, ideal para uso diario
  # Documentación: https://codeberg.org/dnkl/foot
  modules.terminal.emulators.foot = {
    enable = true;
    font = "JetBrainsMono Nerd Font:size=11";
    padding = "10x10";
    cursorStyle = "beam";
    scrollbackLines = 10000;
    alpha = 0.95;              # Transparencia (1.0 = opaco)
    enableSixel = true;        # Soporte para imágenes en terminal
  };

  # GHOSTTY - Terminal moderna con GPU rendering
  # Uso: ghostty, Ctrl+Shift+V (split), Alt+N (tab)
  # Muy rápida con soporte de splits y tabs nativos
  # Documentación: https://ghostty.org/docs
  modules.terminal.emulators.ghostty = {
    enable = true;
    font = "JetBrainsMono Nerd Font";
    fontSize = 12;
    fontFeatures = "calt,liga";  # Ligatures
    cursorStyle = "bar";
    cursorBlink = true;
    paddingX = 10;
    paddingY = 6;
    scrollbackLimit = 10000;
    windowDecoration = false;    # Sin bordes de ventana
    enableFishIntegration = true;
    theme = "catppuccin-mocha";  # Temas: dracula, nord, gruvbox-dark, one-dark
  };

  # ════════════════════════════════════════════════════════════════════════════
  # SHELL - Configuración del shell y prompt
  # ════════════════════════════════════════════════════════════════════════════
  
  # FISH SHELL - Shell moderno con plugins
  # Incluye: carapace, autopair, done, bass, plugin-git, sudope, fifc, grc, puffer
  # Documentación: https://fishshell.com/docs/current/
  modules.terminal.shell.fish = {
    enable = true;
    editor = "nvim";           # Editor por defecto (EDITOR y VISUAL)
    nixosHost = "hydenix";     # Host para comandos nixos-rebuild
  };

  # STARSHIP - Prompt para Fish (separado de zsh)
  # Usa archivo ~/.config/starship/fish.toml
  # NO afecta el prompt de zsh/Hydenix
  modules.terminal.shell.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # ════════════════════════════════════════════════════════════════════════════
  # GAMMASTEP - Ajuste de temperatura de color de pantalla
  # ════════════════════════════════════════════════════════════════════════════
  # Reduce luz azul en la noche para mejor salud visual y sueño
  # Alternativa Wayland a Redshift
  # Ubicación: San Salvador, El Salvador
  modules.system.gammastep = {
    enable = true;
    latitude = "13.6929";   # San Salvador
    longitude = "-89.2182"; # San Salvador
    dayTemp = 5700;         # Temperatura diurna (neutral)
    nightTemp = 3500;       # Temperatura nocturna (cálida, menos luz azul)
    tray = true;            # Icono en bandeja del sistema
  };

  # ════════════════════════════════════════════════════════════════════════════
  # FLATPAK - Gestor de aplicaciones en sandbox
  # ════════════════════════════════════════════════════════════════════════════
  # Configuración en modules/hm/flatpak.nix (simple como gitm3-hydenix)
  # Apps incluidas: Bottles, Stretchly
  # Para agregar más: edita modules/hm/flatpak.nix
  # Documentación: https://flatpak.org/

  # ════════════════════════════════════════════════════════════════════════════
  # ZATHURA - Visor de PDF minimalista con soporte LaTeX
  # ════════════════════════════════════════════════════════════════════════════
  # Ideal para documentos LaTeX con SyncTeX (sincronización PDF <-> código)
  # Atajos estilo Vim para navegación rápida
  # Integrado con Neovim/VimTeX para desarrollo LaTeX
  # Documentación: https://pwmt.org/projects/zathura/
  modules.document-viewers.zathura.enable = true;
}

