# hosts/default.nix
# Shared configuration for all hosts
# This file contains common settings that apply to every machine
{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  # Common imports for all hosts
  imports = [
    inputs.hydenix.inputs.home-manager.nixosModules.home-manager
    inputs.hydenix.nixosModules.default
    ../modules/system # Custom system modules
  ];

  # Common Hydenix settings
  hydenix = {
    enable = true;
    # Common locale (can be overridden per-host)
    locale = lib.mkDefault "en_US.UTF-8";
  };

  # Common system packages (available on all hosts)
  environment.systemPackages = with pkgs; [
    # Essential tools
    git
    wget
    curl
    vim
    
    # System tools
    htop
    btop
    
    # Network tools
    networkmanagerapplet
    ethtool
    mtr
  ];

  # Common Nix settings
  nix = {
    settings = {
      # ===== OPTIMIZACIÓN DE RED =====
      http2 = true; # ✅ HTTP/2 mejora velocidad de descargas (cachix, binarios)
      connect-timeout = 10;
      download-attempts = 5;
      fallback = true;
      download-buffer-size = 1073741824; # 1 GiB (default: 64 MiB) - evita "download buffer is full"

      # ===== PARALELIZACIÓN =====
      max-jobs = "auto";
      cores = 0;
      max-substitution-jobs = 16;

      # ===== SUBSTITUTERS (MIRRORS) =====
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      # ===== USUARIOS DE CONFIANZA =====
      trusted-users = [ "root" "@wheel" "ludus" ];

      # ===== OPTIMIZACIONES ADICIONALES =====
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      narinfo-cache-negative-ttl = 0;
      tarball-ttl = 300;

      # ===== LIMPIEZA AUTOMÁTICA =====
    };
  };

  # Common networking
  networking = {
    networkmanager = {
      enable = true;
      # Usa systemd-resolved para evitar que el ISP inyecte DNS lentos
      dns = "systemd-resolved";
      # Forzar DNS en la conexión cableada (ignora DNS del ISP/DHCP)
      ensureProfiles.profiles."wired-main" = {
        connection = {
          id = "Wired connection 1";
          type = "ethernet";
          permissions = "";
        };
        ipv4 = {
          method = "auto";
          ignore-auto-dns = "true";
          dns = "1.1.1.1;1.0.0.1;9.9.9.9;";
          dns-search = "";
        };
        ipv6 = {
          method = "auto";
          ignore-auto-dns = "true";
          dns-search = "";
        };
      };
    };
    # DNS del sistema (fallback)
    nameservers = [ "1.1.1.1" "9.9.9.9" "8.8.8.8" "8.8.4.4" ];
  };

  # Resolver centralizado con DNS seguro y consistente
  services.resolved = {
    enable = true;
    dnssec = "false";
    extraConfig = ''
      DNS=1.1.1.1 9.9.9.9
      FallbackDNS=8.8.8.8 8.8.4.4
      DNSOverTLS=opportunistic
    '';
  };

  # System version
  system.stateVersion = lib.mkDefault "25.05";

  # ══════════════════════════════════════════════════════════════════════════
  # NIXPKGS CONFIG - Permitir paquetes unfree específicos
  # Permite antigravity y code-cursor que tienen licencias unfree
  # ══════════════════════════════════════════════════════════════════════════
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      let
        pkgName = lib.getName pkg;
      in
      builtins.elem pkgName [
        "antigravity"
        "antigravity-fhs"
        "code-cursor"
        "code-cursor-fhs"
      ];
  };

  # Kernel parameters
  boot.kernel.sysctl = {
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.ipv4.tcp_rmem" = "4096 87380 67108864";
    "net.ipv4.tcp_wmem" = "4096 65536 67108864";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };
}

