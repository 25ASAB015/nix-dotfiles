# configuration.nix
# 
# ⚠️  DEPRECATED: This file is kept for backward compatibility
# 
# The configuration has been moved to hosts/hydenix/configuration.nix
# Please use the new structure going forward.
# 
# This file simply re-exports the new configuration.

{ ... }:

{
  imports = [
    ./hosts/hydenix/configuration.nix
  ];
}
