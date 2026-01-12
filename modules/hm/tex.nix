{
  pkgs,
  lib,
  ...
}: let
  my_tex = pkgs.texlive.combined.scheme-full.withPackages (
    ps:
      with ps; [
        # ════════════════════════════════════════════════════════════════════════════
        # HERRAMIENTAS DE COMPILACIÓN - Build tools para LaTeX
        # ════════════════════════════════════════════════════════════════════════════
        latexmk         # Build automation tool (usado por VimTeX y texlab)
        
        # ════════════════════════════════════════════════════════════════════════════
        # PAQUETES ADICIONALES - Uncomment if needed
        # ════════════════════════════════════════════════════════════════════════════
        # latex-bin         # LaTeX binaries
        # latexindent       # Code formatting
        # biber             # Bibliography processor
        # collection-fontsrecommended  # Recommended fonts
      ]
  );
in {
  # ══════════════════════════════════════════════════════════════════════════════
  # TEX LIVE - Distribución completa de LaTeX
  # ══════════════════════════════════════════════════════════════════════════════
  
  options.my.texlivePackage = lib.mkOption {
    type = lib.types.package;
    readOnly = true;
    default = my_tex;
    description = ''
      TeX Live distribution completa (scheme-full) con latexmk.
      Incluye todo lo necesario para compilar documentos LaTeX estándar.
      Integrado con Neovim (VimTeX + texlab LSP) y Zathura (visor PDF).
    '';
  };
  
  config.home.packages = [
    my_tex  # TeX Live completo
  ];
}
