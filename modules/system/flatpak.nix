# modules/system/flatpak.nix
# Flatpak system-level configuration
# Habilita el servicio flatpak y portales XDG necesarios
{ config, lib, pkgs, ... }:

{
  # Habilitar Flatpak a nivel del sistema
  services.flatpak.enable = true;

  # XDG Desktop Portal - Necesario para Flatpak
  # Permite que las apps flatpak accedan a recursos del sistema de forma segura
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk  # Portal GTK (para apps GTK)
    ];
  };
}

