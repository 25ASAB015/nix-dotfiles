# modules/system/ai-tools-unrestricted.nix
# Configuración para dar acceso completo a herramientas AI (Cursor, VSCode, Antigravity, OpenCode)
# Sin restricciones de sandbox, con permisos completos
{
  config,
  lib,
  pkgs,
  ...
}:

{
  # ══════════════════════════════════════════════════════════════════════════
  # NIX SANDBOX - Desactivar para permitir ejecución sin restricciones
  # ══════════════════════════════════════════════════════════════════════════
  nix.settings = {
    # Desactiva el sandbox de Nix (permite acceso completo al sistema)
    sandbox = false;
    
    # Permite ejecutar binarios no-NixOS sin restricciones
    filter-syscalls = false;
    
    # Confía en usuarios wheel (incluyendo tu usuario ludus)
    trusted-users = [ "root" "@wheel" "ludus" ];
    
    # Permite características experimentales (ya configurado, pero reforzamos)
    experimental-features = [ "nix-command" "flakes" ];
  };

  # ══════════════════════════════════════════════════════════════════════════
  # PERMISOS DEL USUARIO - Grupos adicionales para acceso completo
  # ══════════════════════════════════════════════════════════════════════════
  users.users.ludus = {
    extraGroups = [
      "wheel"           # Sudo sin restricciones
      "networkmanager"  # Acceso red completo
      "video"           # GPU/Display
      "audio"           # Audio
      "docker"          # Docker (si lo usas)
      "libvirtd"        # VMs (si las usas)
      "input"           # Dispositivos input
      "plugdev"         # Dispositivos USB
      "disk"            # Acceso a discos
      "systemd-journal" # Logs del sistema
    ];
  };

  # ══════════════════════════════════════════════════════════════════════════
  # POLKIT - Permisos administrativos sin contraseña para operaciones comunes
  # ══════════════════════════════════════════════════════════════════════════
  security.polkit = {
    enable = true;
    extraConfig = ''
      // Permitir a usuarios wheel ejecutar comandos sin contraseña
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
          // Permite operaciones de sistema sin contraseña
          if (action.id == "org.freedesktop.systemd1.manage-units" ||
              action.id == "org.freedesktop.NetworkManager.network-control" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.reboot") {
            return polkit.Result.YES;
          }
        }
      });
    '';
  };

  # ══════════════════════════════════════════════════════════════════════════
  # SUDO - Sin contraseña SOLO para comandos específicos (Opción 3)
  # Ver SECURITY_SUDO.md para más opciones de configuración
  # ══════════════════════════════════════════════════════════════════════════
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true; # Por defecto requiere contraseña
    extraRules = [
      {
        users = [ "ludus" ];
        commands = [
          # nixos-rebuild sin contraseña
          {
            command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }
          # systemctl sin contraseña
          {
            command = "${pkgs.systemd}/bin/systemctl";
            options = [ "NOPASSWD" ];
          }
          # journalctl sin contraseña
          {
            command = "${pkgs.systemd}/bin/journalctl";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
    extraConfig = ''
      # Mantener variables de entorno importantes
      Defaults env_keep += "SSH_AUTH_SOCK"
      Defaults env_keep += "NIX_PATH"
      Defaults env_keep += "HOME"
      
      # Recordar contraseña por 60 minutos después de ingresarla
      Defaults timestamp_timeout=60
      
      # Una contraseña vale para todas las terminales abiertas
      Defaults !tty_tickets
      
      # No mostrar mensaje de advertencia cada vez
      Defaults !lecture
    '';
  };

  # ══════════════════════════════════════════════════════════════════════════
  # SYSTEMD - Sin limitaciones de recursos
  # ══════════════════════════════════════════════════════════════════════════
  systemd.services = {
    # Permitir a los servicios de usuario acceso completo
    "user@".serviceConfig = {
      Delegate = "yes";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # DBUS - Sin restricciones para AI tools
  # ══════════════════════════════════════════════════════════════════════════
  services.dbus = {
    enable = true;
    packages = [ pkgs.dconf ];
  };

  # ══════════════════════════════════════════════════════════════════════════
  # FILESYSTEM - Acceso completo sin restricciones
  # ══════════════════════════════════════════════════════════════════════════
  # No AppArmor, no SELinux, sin restricciones de acceso
  security.apparmor.enable = lib.mkForce false;
  
  # ══════════════════════════════════════════════════════════════════════════
  # GIT - Sin restricciones de safe.directory
  # ══════════════════════════════════════════════════════════════════════════
  environment.etc."gitconfig".text = ''
    [safe]
      directory = *
  '';

  # ══════════════════════════════════════════════════════════════════════════
  # ENVIRONMENT - Variables para herramientas AI
  # ══════════════════════════════════════════════════════════════════════════
  environment.sessionVariables = {
    # Permitir ejecución de binarios no-NixOS (usa mkDefault para no conflictuar con nix-ld)
    NIX_LD = lib.mkDefault "${pkgs.stdenv.cc.libc}/lib/ld-linux-x86-64.so.2";
    NIX_LD_LIBRARY_PATH = lib.mkDefault (lib.makeLibraryPath [
      pkgs.stdenv.cc.cc
      pkgs.zlib
      pkgs.openssl
      pkgs.curl
    ]);
    
    # Sin restricciones de sandboxing
    SANDBOX = "false";
    
    # Cursor/VSCode sin restricciones
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    ELECTRON_TRASH = "gio";
  };

  # ══════════════════════════════════════════════════════════════════════════
  # PAQUETES NECESARIOS para AI tools
  # ══════════════════════════════════════════════════════════════════════════
  environment.systemPackages = with pkgs; [
    # Build tools (para compilar si es necesario)
    gcc
    gnumake
    pkg-config
    
    # Herramientas Git sin restricciones
    git
    git-lfs
    gh # GitHub CLI
    
    # Herramientas de desarrollo
    python3
    nodejs
    
    # Utilidades para AI agents
    curl
    wget
    jq
    
    # Debugging
    strace
    lsof
  ];

  # ══════════════════════════════════════════════════════════════════════════
  # PROGRAMAS CON PERMISOS ESPECIALES
  # ══════════════════════════════════════════════════════════════════════════
  programs = {
    # Git sin restricciones
    git = {
      enable = true;
      config = {
        safe.directory = "*";
      };
    };
    
    # Bash completion
    bash.completion.enable = true;
    
    # ZSH con autosuggestions
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # NOTAS DE SEGURIDAD
  # ══════════════════════════════════════════════════════════════════════════
  # ⚠️  IMPORTANTE:
  # Esta configuración ELIMINA muchas protecciones de seguridad.
  # Es ideal para desarrollo local pero NO para servidores expuestos.
  #
  # Cambios aplicados:
  # - Nix sandbox desactivado
  # - Sudo sin contraseña para wheel
  # - Acceso completo al filesystem
  # - Sin AppArmor/SELinux
  # - Usuario en múltiples grupos privilegiados
  #
  # Para revertir seguridad:
  # 1. Cambiar nix.settings.sandbox = true
  # 2. Cambiar security.sudo.wheelNeedsPassword = true
  # 3. Remover grupos extras del usuario
}

