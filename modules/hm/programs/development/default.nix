# modules/hm/programs/development/default.nix
# Development - Programming tools and languages
{ ... }:

{
  imports = [
    ./languages.nix  # Programming languages and runtimes
    ./nix-tools.nix  # Nix development tools (linters and formatters)
    ./direnv.nix     # Direnv - automatic environment loading per directory
    # Future imports:
    # ./git.nix      # Git configuration (currently in terminal/software)
    # ./docker.nix   # Docker and containers
    # ./databases.nix # Database clients
  ];
}

