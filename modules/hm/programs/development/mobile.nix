# Documentation: docs/src/content/docs/mobile-development.mdx (Future)
# Mobile development module (Expo, Flutter, Android Studio)
{ config, pkgs, lib, ... }:

with lib; let
  cfg = config.modules.development.mobile;
in {
  options.modules.development.mobile = {
    enable = mkEnableOption "Entorno de desarrollo móvil (Android/Flutter/Expo)";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Android Studio (desde unstable overlay)
      android-studio
      
      # Flutter (desde unstable overlay)
      flutter
      
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
    ];
  };
}
