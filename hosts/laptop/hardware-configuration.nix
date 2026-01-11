# Hardware Configuration Template for Laptop
# 
# This is a template. Generate the actual hardware config with:
# sudo nixos-generate-config --show-hardware-config > hosts/laptop/hardware-configuration.nix
#
# Or during installation:
# 1. Boot the NixOS installer
# 2. Mount your partitions
# 3. Run: nixos-generate-config --root /mnt
# 4. Copy /mnt/etc/nixos/hardware-configuration.nix to this location

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Laptop-specific kernel modules
  # REPLACE WITH YOUR ACTUAL VALUES from nixos-generate-config
  boot.initrd.availableKernelModules = [ 
    "xhci_pci" 
    "thunderbolt" 
    "nvme" 
    "usb_storage" 
    "sd_mod"
    "rtsx_pci_sdmmc" 
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ]; # or "kvm-amd" for AMD CPUs
  boot.extraModulePackages = [ ];

  # REPLACE THESE WITH YOUR ACTUAL PARTITIONS
  # Run `lsblk` or `df -h` to see your partition layout
  fileSystems."/" = {
    device = "/dev/nvme0n1p2"; # Change this to your root partition
    fsType = "ext4";            # Or btrfs, xfs, etc.
  };

  fileSystems."/boot" = {
    device = "/dev/nvme0n1p1"; # Change this to your boot partition
    fsType = "vfat";
  };

  # Swap device or swapfile
  swapDevices = [
    { device = "/dev/nvme0n1p3"; } # Or use swapfile
  ];

  # Networking (WiFi)
  # Most modern laptops use NetworkManager (enabled in default.nix)
  # Additional wireless configuration if needed:
  # networking.wireless.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # For AMD: hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}

