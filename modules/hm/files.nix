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
    ".local/share/waybar/modules/custom-weather.jsonc" = lib.mkForce {
      source = mkSymlink "${dotfilesDir}/resources/config/custom-weather.jsonc";
    };

    ".config/hypr/keybindings.conf" = lib.mkForce {
      source = mkSymlink "${dotfilesDir}/resources/config/keybinds.conf";
    };
    ".config/neovide/config.toml" = lib.mkForce {
      source = mkSymlink "${dotfilesDir}/resources/config/neovide/config.toml";
    };
    # Scripts en .local/lib/hyde/ (todos los scripts de resources/scripts)
    ".local/lib/hyde/script_launcher.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/script_launcher.sh";
    ".local/lib/hyde/record.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/record.sh";
    ".local/lib/hyde/dict.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/dict.sh";
    ".local/lib/hyde/sysmonlaunch.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/sysmonlaunch.sh";
    ".local/lib/hyde/if_discharging.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/if_discharging.sh";
    ".local/lib/hyde/nixos_github_setup.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/nixos_github_setup.sh";
    ".local/lib/hyde/toggle-hdmi.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/toggle-hdmi.sh";
    ".local/lib/hyde/set-weather.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/set-weather.sh";
    ".local/lib/hyde/ubuntu_github_setupsh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/ubuntu_github_setupsh";
  };

  # Asegurar que todos los scripts en resources/scripts sean ejecutables
  home.activation.ensureScriptsExecutable = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "${dotfilesDir}/resources/scripts" ]; then
      chmod -R u+rx,go+rx "${dotfilesDir}/resources/scripts"
    fi
  '';
}

