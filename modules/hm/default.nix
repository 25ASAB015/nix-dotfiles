{ ... }:

{
  imports = [
    # Módulos personalizados - Estructura inspirada en Kaku
    ./terminal  # Terminal: software CLI, emuladores, shell
    
    # Futuros módulos a integrar:
    # ./editors    # Editores: helix, zed, neovim
    # ./packages   # Paquetes: GTK, browsers, media
    # ./services   # Servicios: wayland, system
  ];

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
