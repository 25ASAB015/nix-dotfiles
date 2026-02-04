# ════════════════════════════════════════════════════════════════════════════
# OpenCode Languages & LSP Configuration
# Configuración de formatters y language servers para OpenCode
# Basado en: https://github.com/linuxmobile/kaku
# ════════════════════════════════════════════════════════════════════════════
{pkgs}: let
  # ══════════════════════════════════════════════════════════════════════════
  # Paths a los binarios de formatters
  # Esto evita problemas de PATH y asegura que OpenCode encuentre las herramientas
  # ══════════════════════════════════════════════════════════════════════════
  formatterBins = {
    alejandra = "${pkgs.alejandra}/bin/alejandra";     # Formatter para Nix
    biome = "${pkgs.biome}/bin/biome";                 # Formatter para JS/TS/JSON
    oxfmt = "${pkgs.oxfmt}/bin/oxfmt";                 # Formatter multi-lenguaje
    shfmt = "${pkgs.shfmt}/bin/shfmt";                 # Formatter para shell scripts
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Paths a los binarios de Language Servers
  # ══════════════════════════════════════════════════════════════════════════
  lspBins = {
    astro-ls = "${pkgs.astro-language-server}/bin/astro-ls";
    biome = "${pkgs.biome}/bin/biome";
    marksman = "${pkgs.marksman}/bin/marksman";                             # LSP para Markdown
    nil = "${pkgs.nil}/bin/nil";                                            # LSP para Nix
    tailwindcss = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
    volar = "${pkgs.vue-language-server}/bin/vue-language-server";
  };
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Paquetes a instalar
  # Estos se agregarán al environment de OpenCode
  # ══════════════════════════════════════════════════════════════════════════
  packages = with pkgs; [
    # Language Servers
    astro-language-server    # Astro framework
    biome                     # JS/TS linting y formatting
    marksman                  # Markdown
    nil                       # Nix
    tailwindcss-language-server
    vue-language-server
    
    # Formatters
    alejandra                 # Nix formatter
    oxfmt                     # Multi-language formatter
    shfmt                     # Shell formatter
  ];

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración de Formatters para OpenCode
  # Cada formatter define el comando y las extensiones de archivo que maneja
  # ══════════════════════════════════════════════════════════════════════════
  formatter = {
    shfmt = {
      command = [formatterBins.shfmt "-i" "2"];        # Indentación de 2 espacios
      extensions = ["sh" "bash"];
    };
    oxfmt = {
      command = [formatterBins.oxfmt];
      extensions = ["yaml" "js" "json" "jsx" "md" "ts" "tsx" "css" "html" "vue"];
    };
    biome = {
      command = [formatterBins.biome "format" "--stdin-file-path"];
      extensions = ["astro"];
    };
    alejandra = {
      command = [formatterBins.alejandra "-q"];        # Modo silencioso
      extensions = ["nix"];
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración de Language Servers para OpenCode
  # Cada LSP define el comando de inicio y las extensiones de archivo
  # ══════════════════════════════════════════════════════════════════════════
  lsp = {
    astro-ls = {
      command = [lspBins.astro-ls "--stdio"];
      extensions = ["astro"];
    };
    biome = {
      command = [lspBins.biome "lsp-proxy"];
      extensions = ["js" "ts" "json" "jsx" "tsx"];
    };
    nil = {
      command = [lspBins.nil];
      extensions = ["nix"];
    };
    marksman = {
      command = [lspBins.marksman];
      extensions = ["md"];
    };
    tailwindcss = {
      command = [lspBins.tailwindcss "--stdio"];
      extensions = ["css" "html"];
    };
    volar = {
      command = [lspBins.volar "--stdio"];
      extensions = ["vue"];
    };
  };
}
