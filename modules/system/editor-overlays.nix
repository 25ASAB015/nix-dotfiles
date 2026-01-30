# Documentation: docs/modules/system/editor-overlays.md
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
  # Overlay para actualizar editores desde nixpkgs-unstable con allowUnfree
  nixpkgs.overlays = [
    (final: prev: 
      let
        # Obtener el sistema desde el contexto del overlay
        system = prev.stdenv.hostPlatform.system;
        # Importar nixpkgs-unstable con allowUnfree configurado (wrapper)
        # Esto permite evaluar paquetes unfree sin necesidad de nixpkgs.config
        unstablePkgs = import inputs.nixpkgs-unstable {
          inherit system;
          config = {
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
                "vscode"
                "vscode-fhs"
              ];
          };
        };
      in
      {
        # Sobrescribir code-cursor-fhs con versión de nixpkgs-unstable (wrapper con allowUnfree)
        code-cursor-fhs = unstablePkgs.code-cursor-fhs;
        
        # Sobrescribir antigravity-fhs con versión de nixpkgs-unstable (wrapper con allowUnfree)
        antigravity-fhs = unstablePkgs.antigravity-fhs;
        
        # También hacer disponibles otros paquetes unfree desde unstable si se necesitan
        # code = unstablePkgs.code;
        # code-fhs = unstablePkgs.code-fhs;
        # vscode = unstablePkgs.vscode;
        # vscode-fhs = unstablePkgs.vscode-fhs;
      }
    )
  ];
}

