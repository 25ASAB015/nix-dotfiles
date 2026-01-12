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
      # TeX support - Paquetes necesarios para LaTeX
      config.my.texlivePackage        # TeX Live personalizado con soporte japonés
      pkgs.texlive.combined.scheme-full  # TeX Live completo
      pkgs.texlab                     # LSP para LaTeX
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
