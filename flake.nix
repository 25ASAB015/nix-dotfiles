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
    zen-browser-flake = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      # Main desktop PC configuration
      hydenixConfig = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/hydenix/configuration.nix
        ];
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
    };
}
