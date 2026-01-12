{
  inputs,
  config,
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    extraPackages = [
      # TeX support (comentado por defecto, descomentar si usas LaTeX)
      # pkgs.texlive.combined.scheme-full
      # pkgs.texlab
    ];

    imports = [
      ./options.nix
      ./keymaps.nix
      ./plugins
      ./lsp
      ./themes/tokyonight.nix
    ];
  };
}
