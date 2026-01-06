{ ... }:

{
  imports =
    [
      # Módulos personalizados - Estructura inspirada en Kaku
      ./terminal  # Terminal: software CLI, emuladores, shell
      # Futuros módulos a integrar:
      # ./editors    # Editores: helix, zed, neovim
      # ./packages   # Paquetes: GTK, browsers, media
      # ./services   # Servicios: wayland, system
    ] ++ import ./software/browsers;

  # home-manager options go here
  home.packages = [
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];

  # ════════════════════════════════════════════════════════════════════════════
  # HYDENIX - Configuración principal
  # ════════════════════════════════════════════════════════════════════════════
  hydenix.hm.enable = true;
  # Visit https://github.com/richen604/hydenix/blob/main/docs/options.md for more options

  # Desactivar git de Hydenix para usar nuestra configuración personalizada
  hydenix.hm.git.enable = false;

  # ════════════════════════════════════════════════════════════════════════════
  # MÓDULOS PERSONALIZADOS - Habilitados desde Kaku
  # ════════════════════════════════════════════════════════════════════════════
  
  # Git - Control de versiones con configuración avanzada
  # IMPORTANTE: hydenix.hm.git.enable = false arriba
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

  # GitHub CLI - Herramienta oficial de GitHub para terminal
  # Documentación: https://cli.github.com/manual/
  modules.terminal.software.gh = {
    enable = true;
    editor = "nano";        # Cambia a tu editor preferido: "nvim", "hx", "code"
    username = "25asab015";     # Tu usuario de GitHub
    gitProtocol = "https";  # o "ssh" si tienes configurado SSH keys
    # browser = "firefox";  # Descomenta para usar un navegador específico
  };

  # Lazygit - Interfaz TUI para Git
  # Uso: ejecutar `lazygit` en cualquier repositorio
  modules.terminal.software.lazygit = {
    enable = true;
    signOffCommits = true;    # Agregar firma a commits
    nerdFontsVersion = "3";   # Versión de Nerd Fonts para iconos
    # Personalizar colores:
    # theme.activeBorderColor = [ "cyan" "bold" ];
    # theme.inactiveBorderColor = [ "gray" ];
  };

  # Atuin - Historial de shell mejorado con búsqueda fuzzy
  # Uso: Ctrl+R para buscar en historial
  # Documentación: https://docs.atuin.sh/
  modules.terminal.software.atuin = {
    enable = true;
    enableFishIntegration = true;   # Solo para Fish
    enableZshIntegration = false;   # No afectar zsh/Hydenix
  };

  # Yazi - File manager moderno para terminal
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

  # CLI Tools - Colección de herramientas modernas de terminal
  # Incluye: eza (ls), fzf (fuzzy), ripgrep (grep), dust (du), duf (df), fd (find)
  # TUI Apps: discordo (Discord), reddit-tui, scope-tui (audio visualizer)
  # Mynixpkgs: bmm, dawn, dfft, lightview, nekot, omm, orchat, prs
  # Documentación: ver cada herramienta individual
  modules.terminal.software.cli = {
    enable = true;
    enableFishIntegration = true;   # Integración con Fish
    archives = true;                # zip, unzip, unrar
    systemUtils = true;             # dust, duf, fd, jq, glow, gtt, zfxtop, inshellisense
    tuiApps = true;                 # discordo, reddit-tui, scope-tui
    mynixpkgsApps = true;           # bmm, dawn, dfft, lightview, nekot, omm, orchat, prs
    eza = true;                     # ls moderno con iconos
    fzf = true;                     # Buscador fuzzy (Ctrl+T)
    ripgrep = true;                 # grep ultrarrápido (rg)
  };

  # Skim - Fuzzy finder escrito en Rust (alternativa a fzf)
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

  # Bat - cat con syntax highlighting
  # Uso: bat archivo.txt, bat -p (sin decoración), bat --list-themes
  # Documentación: https://github.com/sharkdp/bat
  modules.terminal.software.bat = {
    enable = true;
    theme = "base16";           # Tema de colores
    style = "plain";            # Estilo: plain, full, auto, changes
    useAsManPager = true;       # Coloriza man pages
  };

  # Bottom - Monitor de sistema moderno (reemplazo de htop/btop)
  # Uso: btm, btop (alias), htop (alias modo básico)
  # Documentación: https://clementtsang.github.io/bottom/
  modules.terminal.software.bottom = {
    enable = true;
    enableGpu = true;           # Monitorear GPU
    groupProcesses = true;      # Agrupar procesos con mismo nombre
    createAliases = true;       # Crear btop/htop como aliases
  };

  # OpenCode - Terminal AI Assistant (Claude, Gemini, GPT, etc.)
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

  # Foot - Terminal ligera para Wayland
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
    # Colores Catppuccin Mocha (por defecto)
    # Puedes cambiarlos a tu gusto
  };

  # Ghostty - Terminal moderna con GPU rendering
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
    # Si prefieres colores personalizados, usa theme = null y define colors
  };

  # ════════════════════════════════════════════════════════════════════════════
  # SHELL - Configuración del shell y prompt
  # ════════════════════════════════════════════════════════════════════════════
  
  # Fish Shell - Shell moderno con plugins
  # Incluye: carapace, autopair, done, bass, plugin-git, sudope, fifc, grc, puffer
  # Documentación: https://fishshell.com/docs/current/
  modules.terminal.shell.fish = {
    enable = true;
    editor = "nvim";           # Editor por defecto (EDITOR y VISUAL)
    nixosHost = "hydenix";     # Host para comandos nixos-rebuild
  };

  # Starship - Prompt para Fish (separado de zsh)
  # Usa archivo ~/.config/starship/fish.toml
  # NO afecta el prompt de zsh/Hydenix
  modules.terminal.shell.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
