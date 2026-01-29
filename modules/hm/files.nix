{
  config,
  lib,
  pkgs,
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
      force = true;
    };

    ".config/hypr/keybindings.conf" = lib.mkForce {
      source = mkSymlink "${dotfilesDir}/resources/config/hypr/keybinds.conf";
    };
    ".config/hypr/monitors.conf" = lib.mkForce {
      source = mkSymlink "${dotfilesDir}/resources/config/hypr/monitors.conf";
      force = true;
    };
    ".config/neovide/config.toml" = lib.mkForce {
      source = mkSymlink "${dotfilesDir}/resources/config/neovide/config.toml";
    };
    
    # VS Code Configuration
    ".config/Code/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/vscode/settings.json";
      force = true;
    };
    
    ".config/Code/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/vscode/keybindings.json";
      force = true;
    };
    
    # Extensión Wallbash de Hydenix
    ".vscode/extensions/prasanthrangan.wallbash" = {
      source = "${pkgs.hyde}/share/vscode/extensions/prasanthrangan.wallbash";
      recursive = true;
      force = true;
    };
    
    # Cursor Configuration
    ".config/Cursor/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/cursor/settings.json";
      force = true;
    };
    
    ".config/Cursor/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/cursor/keybindings.json";
      force = true;
    };
    
    # AntiGravity Configuration
    ".config/Antigravity/User/settings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/antigravity/settings.json";
      force = true;
    };
    
    ".config/Antigravity/User/keybindings.json" = {
      source = mkSymlink "${dotfilesDir}/resources/config/antigravity/keybindings.json";
      force = true;
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
    ".local/lib/hyde/monitor-toggle.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/monitor-toggle.sh";
    ".local/lib/hyde/set-weather.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/set-weather.sh";
    ".local/lib/hyde/cliphist.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/cliphist.sh";
    ".local/lib/hyde/ubuntu_github_setupsh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/ubuntu_github_setupsh";
    ".local/lib/hyde/toggle_gaps.sh".source =
      mkSymlink "${dotfilesDir}/resources/scripts/toggle_gaps.sh";
    ".antigravity_debug".text = "Module is loaded";
  };

  # Asegurar que todos los scripts en resources/scripts sean ejecutables
  home.activation.ensureScriptsExecutable = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "${dotfilesDir}/resources/scripts" ]; then
      chmod -R u+rx,go+rx "${dotfilesDir}/resources/scripts"
    fi
  '';


}

