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

  # ════════════════════════════════════════════════════════════════════════════
  # SHELL - Configuración del shell y prompt
  # ════════════════════════════════════════════════════════════════════════════
  
  # Fish Shell - Shell moderno e interactivo
  # Documentación: https://fishshell.com/docs/current/
  modules.terminal.shell.fish = {
    enable = true;
    editor = "nvim";           # Editor por defecto (EDITOR y VISUAL)
    viMode = true;             # Keybindings estilo Vi
    nixosHost = "hydenix";     # Host para comandos nixos-rebuild
    # extraConfig = ''         # Configuración adicional
    #   set -gx MY_VAR "value"
    # '';
    # extraAliases = {         # Aliases personalizados
    #   myalias = "echo 'Hola'";
    # };
    # extraFunctions = {       # Funciones adicionales
    #   myfunc = "echo $argv";
    # };
  };

  # Starship - Prompt para Fish (separado de zsh)
  # Usa archivo ~/.config/starship/fish.toml
  # NO afecta el prompt de zsh/Hydenix
  modules.terminal.shell.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Carapace - Autocompletado inteligente multi-shell
  # Documentación: https://rsteube.github.io/carapace/
  modules.terminal.shell.carapace = {
    enable = true;
    enableFishIntegration = true;
    bridges = [ "fish" "zsh" "bash" ];  # Heredar completados de estos shells
    # enableInshellisense = false;      # AI completions (experimental)
  };
}
