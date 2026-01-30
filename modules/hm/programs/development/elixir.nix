# Documentation: docs/src/content/docs/elixir-development.mdx (Future)
# Elixir and Phoenix development module
{ config, pkgs, lib, ... }:

with lib; let
  cfg = config.modules.development.elixir;
in {
  options.modules.development.elixir = {
    enable = mkEnableOption "Entorno de desarrollo Elixir/Phoenix";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Elixir y Erlang (desde unstable overlay)
      elixir
      erlang
      elixir-ls     # Language Server para Elixir
      
      # Herramientas para Phoenix
      inotify-tools # Necesario para live reload en Linux
    ];

    # Variables de entorno útiles para Elixir
    home.sessionVariables = {
      # ERL_AFLAGS = "-kernel shell_history enabled"; # Opcional: historial en iex
    };
  };
}
