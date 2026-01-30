# Documentation: docs/src/content/docs/mobile-development.mdx (Future)
# Mobile development module (Expo, Flutter, Android Studio)
{ config, pkgs, lib, ... }:

with lib; let
  cfg = config.modules.development.mobile;
  
  # Componer un SDK de Android mínimo pero funcional
  androidSdk = pkgs.androidenv.composeAndroidPackages {
    # Versiones de plataforma (Android 14)
    platformVersions = [ "34" ];
    # Herramientas de construcción
    buildToolsVersions = [ "34.0.0" "33.0.1" ];
    # Versión de Platform Tools
    platformToolsVersion = "36.0.2";
  };
in {
  options.modules.development.mobile = {
    enable = mkEnableOption "Entorno de desarrollo móvil (Android/Flutter/Expo)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Android Studio (desde unstable overlay)
      android-studio
      
      # SDK de Android gestionado por Nix
      androidSdk.androidsdk
      
      # Flutter (desde unstable overlay)
      (lib.setPrio 11 flutter) # Muy baja prioridad para evitar colisiones con dotfiles y elixir-ls
      
      # Expo y herramientas de Node (Node ya está instalado v22)
      nodePackages.eas-cli
      nodePackages.yarn
      nodePackages.typescript-language-server # LSP para TypeScript (Expo)
      nodePackages.vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      
      # Herramientas adicionales
      watchman # Útil para React Native
      jdk17    # Necesario para herramientas CLI de Android/Flutter
    ];

    # Variables de entorno para desarrollo móvil
    home.sessionVariables = {
      ANDROID_HOME = "${config.home.homeDirectory}/Android/Sdk";
      ANDROID_SDK_ROOT = "${config.home.homeDirectory}/Android/Sdk";
      CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
    };

    # Asegurar que el PATH incluya las herramientas del SDK
    home.sessionPath = [
      "${config.home.homeDirectory}/Android/Sdk/emulator"
      "${config.home.homeDirectory}/Android/Sdk/platform-tools"
      "${config.home.homeDirectory}/Android/Sdk/cmdline-tools/latest/bin"
    ];

    # Vincular de forma declarativa el SDK de Nix a la ruta esperada por Android Studio
    # Esto "engaña" a Android Studio haciéndole creer que el SDK está instalado localmente,
    # pero los archivos reales están en la store de Nix.
    home.file."Android/Sdk".source = "${androidSdk.androidsdk}/libexec/android-sdk";
  };
}
