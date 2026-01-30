# Documentation: docs/modules/system/editor-overlays.md
# Editor Overlays - Actualización selectiva de Cursor y Antigravity
# 
# Este módulo crea un overlay que sobrescribe solo los paquetes de Cursor y
# Antigravity con versiones más recientes desde nixpkgs-unstable, mientras
# el resto del sistema mantiene las versiones fijadas por hydenix.
#
# Propósito: Permitir actualizaciones rápidas de editores AI sin cambiar
# todo el sistema a unstable.

{ config, lib, inputs, ... }:

{
  # Overlay para actualizar solo Cursor y Antigravity desde nixpkgs-unstable
  nixpkgs.overlays = [
    (final: prev: 
      let
        # Obtener el sistema desde el contexto del overlay
        system = prev.stdenv.hostPlatform.system;
        # Paquetes de nixpkgs-unstable para este sistema
        unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
      in
      {
        # Sobrescribir code-cursor-fhs con versión de nixpkgs-unstable
        code-cursor-fhs = unstablePkgs.code-cursor-fhs;
        
        # Sobrescribir antigravity-fhs con versión de nixpkgs-unstable
        antigravity-fhs = unstablePkgs.antigravity-fhs;
        
        # Mantener cursor-cli desde el nixpkgs principal (no necesita actualización frecuente)
        # cursor-cli = prev.cursor-cli;  # Ya está en prev, no necesita override
      }
    )
  ];
}

