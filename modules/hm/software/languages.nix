{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Equivalente a 'build-essential'
    gcc
    binutils
    gnumake
    pkg-config
    
    # Herramientas de Rust
    cargo
    rustc
  ];
}