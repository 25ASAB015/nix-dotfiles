{ ... }:

{
  imports =
    [
      # ══════════════════════════════════════════════════════════════════════════
      # ESTRUCTURA DE MÓDULOS
      # ══════════════════════════════════════════════════════════════════════════
      ./programs           # Programs: terminal, browsers, development
      ./programs/terminal/software/essentials.nix  # Herramientas esenciales (gh, git)
      
      # ══════════════════════════════════════════════════════════════════════════
      # CONFIGURACIONES
      # ══════════════════════════════════════════════════════════════════════════
      ./hydenix-config.nix # Configuración de todos los módulos modules.*
    ];

  # ════════════════════════════════════════════════════════════════════════════
  # HOME MANAGER - Paquetes adicionales
  # ════════════════════════════════════════════════════════════════════════════
  home.packages = [
    # Agrega paquetes adicionales aquí si no encajan en los módulos existentes
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];

  # ════════════════════════════════════════════════════════════════════════════
  # HYDENIX - Configuración principal del framework
  # ════════════════════════════════════════════════════════════════════════════
  hydenix.hm.enable = true;
  # Visit https://github.com/richen604/hydenix/blob/main/docs/options.md for more options

  # Desactivar git de Hydenix para usar nuestra configuración personalizada
  hydenix.hm.git.enable = false;
}
