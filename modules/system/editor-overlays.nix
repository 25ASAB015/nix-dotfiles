# Documentation: docs/src/content/docs/editors.mdx (sección "Editor Overlays")
# Editor Overlays - Actualización selectiva de Cursor y Antigravity
# 
# Este módulo crea un overlay que:
# 1. Importa nixpkgs-unstable con allowUnfree configurado (wrapper)
# 2. Sobrescribe Cursor y Antigravity con versiones actualizadas
#
# Propósito: Permitir actualizaciones rápidas de editores AI sin cambiar
# todo el sistema a unstable, resolviendo el problema de licencias unfree
# mediante un wrapper que importa nixpkgs-unstable con la configuración correcta.

{ config, lib, inputs, ... }:

{
  # Overlay para actualizar editores y herramientas de desarrollo desde nixpkgs-unstable con allowUnfree
  nixpkgs.overlays = [
    (final: prev: 
      let
        # Obtener el sistema desde el contexto del overlay
        system = prev.stdenv.hostPlatform.system;
        # Importar nixpkgs-unstable con allowUnfree configurado (wrapper)
        unstablePkgs = import inputs.nixpkgs-unstable {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfreePredicate = pkg:
              let
                pkgName = inputs.nixpkgs-unstable.lib.getName pkg;
              in
              builtins.elem pkgName [
                "antigravity"
                "antigravity-fhs"
                "code"
                "code-fhs"
                "code-cursor"
                "code-cursor-fhs"
                "cursor"
                "cursor-fhs"
                "vscode"
                "vscode-fhs"
                # Desarrollo Móvil
                "android-studio"
                "android-studio-stable"
                "android-sdk"
                "flutter"
                "google-chrome"
              ];
          };
        };
      in
      {
        # Editores
        code-cursor-fhs = unstablePkgs.code-cursor-fhs;
        antigravity-fhs = unstablePkgs.antigravity-fhs;
        
        # Desarrollo Móvil (Unstable)
        android-studio = unstablePkgs.android-studio;
        flutter = unstablePkgs.flutter;

        # Desarrollo Web (Elixir/Erlang)
        # Traemos las versiones más recientes de unstable
        elixir = unstablePkgs.elixir;
        erlang = unstablePkgs.erlang;
        google-chrome = unstablePkgs.google-chrome;
      }
    )
  ];
}

