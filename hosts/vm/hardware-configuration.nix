# Hardware Configuration Template for VM
# 
# This is a template. Generate the actual hardware config with:
# sudo nixos-generate-config --show-hardware-config > hosts/vm/hardware-configuration.nix
#
# Or if installing in a VM:
# 1. Boot the NixOS installer
# 2. Mount your partitions
# 3. Run: nixos-generate-config --root /mnt
# 4. Copy /mnt/etc/nixos/hardware-configuration.nix to this location

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # VM-specific kernel modules
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # REPLACE THESE WITH YOUR ACTUAL PARTITIONS
  # Run `lsblk` or `df -h` to see your partition layout
  fileSystems."/" = {
    device = "/dev/vda1"; # Change this to your root partition
    fsType = "ext4";      # Change if using different filesystem
  };

  fileSystems."/boot" = {
    device = "/dev/vda0"; # Change this to your boot partition
    fsType = "vfat";
  };

  # Swap device (if you have one)
  # swapDevices = [
  #   { device = "/dev/vda2"; }
  # ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

