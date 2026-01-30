{
  description = "template for hydenix";

  inputs = {
    nixpkgs = {
      # url = "github:nixos/nixpkgs/nixos-unstable"; # uncomment this if you know what you're doing
      follows = "hydenix/nixpkgs"; # then comment this
    };
    hydenix.url = "github:richen604/hydenix";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    
    # ══════════════════════════════════════════════════════════════════════════
    # PAQUETES EXTRA - Repositorio personal de linuxmobile
    # Incluye herramientas CLI/TUI que no están en nixpkgs oficial
    # ══════════════════════════════════════════════════════════════════════════
    mynixpkgs = {
      url = "github:linuxmobile/mynixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # ══════════════════════════════════════════════════════════════════════════
    # OPENCODE - Terminal AI Assistant
    # Herramienta de línea de comandos para interactuar con modelos de IA
    # Documentación: https://github.com/anomalyco/opencode
    # ══════════════════════════════════════════════════════════════════════════
    opencode = {
      url = "github:anomalyco/opencode";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Navegador Zen (flake comunitario)
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # NIX-FLATPAK - Gestión declarativa de aplicaciones Flatpak
    # Permite instalar y configurar aplicaciones Flatpak desde Flathub
    # Documentación: https://github.com/gmodena/nix-flatpak
    # ══════════════════════════════════════════════════════════════════════════
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };

    # ══════════════════════════════════════════════════════════════════════════
    # KHANELIVIM - Configuración profesional de Neovim con Nixvim
    # Full-featured Neovim setup con LSP, DAP, y más (usado como paquete)
    # Documentación: https://github.com/khaneliman/khanelivim
    # ══════════════════════════════════════════════════════════════════════════
    khanelivim = {
      url = "github:khaneliman/khanelivim";
      # No seguimos nixpkgs para evitar conflictos con la configuración interna
    };

    # ══════════════════════════════════════════════════════════════════════════
    # OPENSPEC - Spec-driven development for AI coding assistants
    # Documentación: https://github.com/Fission-AI/OpenSpec
    # ══════════════════════════════════════════════════════════════════════════
    openspec.url = "github:Fission-AI/OpenSpec";

    # ══════════════════════════════════════════════════════════════════════════
    # NIXPKGS-UNSTABLE - Para paquetes actualizados (Cursor, Antigravity)
    # Solo se usa para sobrescribir paquetes específicos via overlay
    # El resto del sistema usa las versiones fijadas por hydenix
    # ══════════════════════════════════════════════════════════════════════════
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { ... }@inputs:
    let
      # Import nixpkgs with configuration to allow unfree packages
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfreePredicate = pkg:
            let
              pkgName = inputs.nixpkgs.lib.getName pkg;
            in
            builtins.elem pkgName [
              "antigravity"
              "antigravity-fhs"
              "code"
              "code-fhs"
              "code-cursor"
              "code-cursor-fhs"
              "vscode"
              "vscode-fhs"
            ];
        };
      };
      
      # Main desktop PC configuration
      hydenixConfig = inputs.nixpkgs.lib.nixosSystem {
        # Modern syntax (replaces deprecated 'system')
        modules = [
          { nixpkgs.hostPlatform = "x86_64-linux"; }
          # Pass configured pkgs to override the externally created instance
          {
            nixpkgs.pkgs = pkgs;
          }
          ./hosts/hydenix/configuration.nix
        ];
        specialArgs = {
          inherit inputs;
        };
      };
      
      # VM configuration (using hydenix lib)
      vmConfig = inputs.hydenix.lib.vmConfig {
        inherit inputs;
        nixosConfiguration = hydenixConfig;
      };
    in
    {
      # Main host configuration
      nixosConfigurations.hydenix = hydenixConfig;
      nixosConfigurations.default = hydenixConfig;
      
      # VM package
      packages."x86_64-linux".vm = vmConfig.config.system.build.vm;

      # Development Shells
      devShells."x86_64-linux".default = import ./shells/default.nix {
        inherit inputs;
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      };
    };
}
