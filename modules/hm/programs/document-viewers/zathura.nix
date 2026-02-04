# Zathura - Visor de PDF minimalista con atajos Vim
# Ideal para documentos LaTeX con SyncTeX
{ config, lib, pkgs, ... }:
with lib; let
  cfg = config.modules.document-viewers.zathura;
in {
  options.modules.document-viewers.zathura = {
    enable = mkEnableOption "Zathura PDF viewer";
  };

  config = mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      extraConfig = ''
        # ════════════════════════════════════════════════════════════════════════════
        # CONFIGURACIÓN DE ZATHURA - PDF Viewer para LaTeX
        # ════════════════════════════════════════════════════════════════════════════
        
        # Desactivar sandbox para permitir SyncTeX con editores
        set sandbox none
        
        # Copiar al clipboard del sistema (Wayland/X11)
        set selection-clipboard "clipboard"
        
        # Mantener tonos de color al usar recolor (útil para modo oscuro)
        set recolor-keephue true
        
        # ────────────────────────────────────────────────────────────────────────────
        # CONFIGURACIÓN DE VISUALIZACIÓN
        # ────────────────────────────────────────────────────────────────────────────
        
        # Ajustar página al ancho de la ventana
        set adjust-open "best-fit"
        
        # Espaciado entre páginas
        set page-padding 1
        
        # Zoom inicial
        set zoom-min 10
        set zoom-max 1000
        set zoom-step 10
        
        # ────────────────────────────────────────────────────────────────────────────
        # INTEGRACIÓN CON NEOVIM/VIMTEX (SyncTeX)
        # ────────────────────────────────────────────────────────────────────────────
        # SyncTeX permite saltar entre el PDF y el código fuente LaTeX
        # Configurado en nvim/plugins/latex.nix y nvim/lsp/default.nix
      '';
    };
  };
}

