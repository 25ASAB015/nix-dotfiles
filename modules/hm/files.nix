{
  config,
  lib,
  ...
}:

let
  dotfilesDir = "${config.home.homeDirectory}/Dotfiles";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  # Archivos mutables (se actualizan sin rebuild al editar en el repo)
  home.file = {
    ".config/hypr/keybindings.conf" = lib.mkForce {
      source = mkSymlink "${dotfilesDir}/resources/config/keybinds.conf";
    };
    ".local/lib/hyde/script_launcher.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/script_launcher.sh";
    ".local/lib/hyde/record.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/record.sh";
    ".local/lib/hyde/dict.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/dict.sh";
  };
}

