# modules/hm/programs/terminal/sesh.nix
{ pkgs, ... }:

{
  home.packages = [
    pkgs.sesh
    pkgs.gum
  ];

  # Sesh configuration
  home.file.".config/sesh/sesh.toml".text = ''
    [default_session]
    startup_command = "nvim"

    [[session]]
    name = "Dotfiles ⚙️"
    path = "~/Dotfiles"
    startup_command = "nvim ."
    preview_command = "eza --all --git --icons --color=always {}"

    [[session]]
    name = "Work 💼"
    path = "~/Work"
    startup_command = "ls"
    preview_command = "eza --all --git --icons --color=always {}"

    [[session]]
    name = "Downloads 📥"
    path = "~/Downloads"
    startup_command = "ls"

    [[session]]
    name = "Tmux Config ⌨️"
    path = "~/Dotfiles/modules/hm/programs/terminal"
    startup_command = "nvim tmux.conf.local"
    preview_command = "bat --color=always --style=numbers tmux.conf.local"

    [[session]]
    name = "NixOS Config ❄️"
    path = "~/Dotfiles"
    startup_command = "nvim hosts/hydenix/configuration.nix"
    preview_command = "bat --color=always --style=numbers hosts/hydenix/configuration.nix"
  '';

  # Zsh integration (Alt-s to open sesh with fzf)
  programs.zsh.initExtra = ''
    function sesh-sessions() {
      {
        exec </dev/tty
        exec <&1
        local session
        session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
        zle reset-prompt > /dev/null 2>&1 || true
        [[ -z "$session" ]] && return
        sesh connect $session
      }
    }

    zle     -N             sesh-sessions
    bindkey -M emacs '\es' sesh-sessions
    bindkey -M vicmd '\es' sesh-sessions
    bindkey -M viins '\es' sesh-sessions
  '';
}
