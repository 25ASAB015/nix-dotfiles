# Documentation: docs/src/content/docs/mobile-development.mdx (Future)
# Android configuration for development
{ config, pkgs, lib, ... }:

{
  # Habilitar udev rules para dispositivos Android
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  # Grupo adbusers para el usuario
  users.users.ludus.extraGroups = [ "adbusers" "kvm" ];

  # Permitir KVM para emuladores
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Herramientas de sistema para Android
  environment.systemPackages = with pkgs; [
    adb
    fastboot
  ];
}
