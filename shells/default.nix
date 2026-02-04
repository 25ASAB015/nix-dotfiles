{ pkgs, ... }:

pkgs.mkShell {
  name = "dotfiles-shell";

  packages = with pkgs; [
    # Nix Tools
    nil
    statix
    deadnix
    alejandra
    nh
    home-manager

    # Documentation
    nodejs_22
    nodePackages.npm

    # Development
    neovim
    jujutsu # jj
    git
    gh
    ripgrep
    fd
  ];

  shellHook = ''
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🔨 Welcome to Dotfiles DevShell"
    echo ""
    echo "   Tools available:"
    echo "   - Nix: nil, statix, deadnix, alejandra, nh"
    echo "   - Docs: node, npm (Astro)"
    echo "   - Git: jj, git, gh"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  '';
}
