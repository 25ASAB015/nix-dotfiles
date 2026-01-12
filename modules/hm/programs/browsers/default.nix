# modules/hm/programs/browsers/default.nix
# Web browsers configuration
{ ... }:

{
  imports = [
    ./helium.nix
    ./zen.nix
    ./google-chrome.nix
    ./brave.nix
  ];
}
