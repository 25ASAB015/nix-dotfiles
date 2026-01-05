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
