# Documentation: docs/src/content/docs/mobile-development.mdx (Future)
# Android configuration for development
{ config, pkgs, lib, ... }:

{
  # Habilitar ADB (esto instala adb/fastboot y configura udev automáticamente)
  programs.adb.enable = true;

  # Grupos necesarios para el usuario (adbusers es necesario para adb)
  users.users.ravn.extraGroups = [ "adbusers" "kvm" ];

  # Permitir KVM para emuladores
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
}
