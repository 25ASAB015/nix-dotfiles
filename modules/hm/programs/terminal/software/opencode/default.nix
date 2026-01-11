# ════════════════════════════════════════════════════════════════════════════
# OpenCode - Terminal AI Assistant
# Asistente de IA para terminal con soporte para múltiples modelos
# Basado en: https://github.com/linuxmobile/kaku
# Documentación: https://github.com/anomalyco/opencode
# ════════════════════════════════════════════════════════════════════════════
#
# OpenCode es una herramienta de línea de comandos que permite interactuar
# con modelos de IA (Claude, Gemini, GPT, etc.) directamente desde la terminal.
# 
# Características:
# - Soporte para múltiples proveedores de IA
# - Integración con LSP para autocompletado inteligente
# - Skills personalizables para tareas específicas
# - Integración con MCP (Model Context Protocol) servers
#
# Uso básico:
#   opencode              # Inicia el asistente
#   opencode "prompt"     # Envía un prompt directo
# ════════════════════════════════════════════════════════════════════════════
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.terminal.software.opencode;
  
  # Importar configuraciones auxiliares
  languages = import ./_languages.nix {inherit pkgs;};
  providers = import ./_providers.nix;
  skills = import ./_skills.nix {inherit pkgs;};

  # Obtener el paquete de OpenCode desde el input del flake
  opencode = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;

  # Environment con todas las herramientas de lenguajes y skills
  opencodeEnv = pkgs.buildEnv {
    name = "opencode-env";
    paths =
      languages.packages
      ++ skills.packages;
  };

  # Script de inicialización que configura directorios necesarios
  opencodeInitScript = pkgs.writeShellScript "opencode-init" ''
    # Crear directorios para plugins
    mkdir -p "$HOME/.local/cache/opencode/node_modules/@opencode-ai"
    mkdir -p "$HOME/.config/opencode/node_modules/@opencode-ai"
    
    # Crear symlink para el plugin si existe
    if [ -d "$HOME/.config/opencode/node_modules/@opencode-ai/plugin" ]; then
      if [ ! -L "$HOME/.local/cache/opencode/node_modules/@opencode-ai/plugin" ]; then
        ln -sf "$HOME/.config/opencode/node_modules/@opencode-ai/plugin" \
               "$HOME/.local/cache/opencode/node_modules/@opencode-ai/plugin"
      fi
    fi
    
    # Ejecutar opencode con todos los argumentos
    exec ${opencode}/bin/opencode "$@"
  '';

  # Wrapper de OpenCode con PATH y variables de entorno configuradas
  opencodeWrapped =
    pkgs.runCommand "opencode-wrapped" {
      buildInputs = [pkgs.makeWrapper];
    } ''
      mkdir -p $out/bin
      makeWrapper ${opencodeInitScript} $out/bin/opencode \
        --prefix PATH : ${opencodeEnv}/bin \
        --set OPENCODE_LIBC ${pkgs.glibc}/lib/libc.so.6
    '';
    
  # Ruta del archivo de configuración
  configFile = "opencode/config.json";
in {
  # ══════════════════════════════════════════════════════════════════════════
  # Opciones del módulo
  # ══════════════════════════════════════════════════════════════════════════
  options.modules.terminal.software.opencode = {
    enable = mkEnableOption "OpenCode - Terminal AI Assistant";
    
    smallModel = mkOption {
      type = types.str;
      default = "google/gemma-3n-e4b-it:free";
      description = "Modelo pequeño para tareas rápidas (modelo gratuito por defecto)";
      example = "google/gemma-3n-e4b-it:free";
    };
    
    autoupdate = mkOption {
      type = types.bool;
      default = false;
      description = "Habilitar actualizaciones automáticas de OpenCode";
    };
    
    share = mkOption {
      type = types.enum ["enabled" "disabled"];
      default = "disabled";
      description = "Habilitar/deshabilitar compartir datos de uso";
    };
    
    enabledProviders = mkOption {
      type = types.listOf types.str;
      default = ["openrouter" "google"];
      description = "Proveedores de IA habilitados";
      example = ["openrouter" "google" "anthropic"];
    };
    
    disabledProviders = mkOption {
      type = types.listOf types.str;
      default = [
        "amazon-bedrock"
        "anthropic"
        "azure-openai"
        "azure-cognitive-services"
        "baseten"
        "cerebras"
        "cloudflare-ai-gateway"
        "cortecs"
        "deepseek"
        "deep-infra"
        "fireworks-ai"
        "github-copilot"
        "google-vertex-ai"
        "groq"
        "hugging-face"
        "helicone"
        "llama.cpp"
        "io-net"
        "lmstudio"
        "moonshot-ai"
        "nebius-token-factory"
        "ollama"
        "ollama-cloud"
        "openai"
        "opencode-zen"
        "sap-ai-core"
        "ovhcloud-ai-endpoints"
        "together-ai"
        "venice-ai"
        "xai"
        "zai"
        "zenmux"
      ];
      description = "Proveedores de IA deshabilitados";
    };
    
    plugins = mkOption {
      type = types.listOf types.str;
      default = ["opencode-antigravity-auth@1.2.7-beta.6"];
      description = "Plugins a instalar (el plugin antigravity proporciona acceso gratuito a modelos)";
    };
    
    mcp = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          type = mkOption {
            type = types.enum ["remote" "local"];
            default = "remote";
            description = "Tipo de servidor MCP";
          };
          url = mkOption {
            type = types.str;
            description = "URL del servidor MCP";
          };
          enabled = mkOption {
            type = types.bool;
            default = true;
            description = "Habilitar este servidor MCP";
          };
          timeout = mkOption {
            type = types.int;
            default = 10000;
            description = "Timeout en milisegundos";
          };
        };
      });
      default = {
        gh_grep = {
          type = "remote";
          url = "https://mcp.grep.app/";
          enabled = true;
          timeout = 10000;
        };
        deepwiki = {
          type = "remote";
          url = "https://mcp.deepwiki.com/mcp";
          enabled = true;
          timeout = 10000;
        };
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          enabled = true;
          timeout = 10000;
        };
      };
      description = "Servidores MCP (Model Context Protocol) para extender capacidades";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Configuración cuando el módulo está habilitado
  # ══════════════════════════════════════════════════════════════════════════
  config = mkIf cfg.enable {
    # Instalar el paquete wrapped de OpenCode
    home.packages = [opencodeWrapped];
    
    # Configuración XDG
    xdg.configFile = {
      # Archivo de configuración principal
      "${configFile}".text = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        plugin = cfg.plugins;
        small_model = cfg.smallModel;
        autoupdate = cfg.autoupdate;
        share = cfg.share;
        disabled_providers = cfg.disabledProviders;
        enabled_providers = cfg.enabledProviders;
        mcp = cfg.mcp;
        formatter = languages.formatter;
        lsp = languages.lsp;
        provider = providers.config;
      };
      
      # Skills directory
      "opencode/skill".source = skills.skillsSource + "/skill";
    };
  };
}
