# ════════════════════════════════════════════════════════════════════════════
# OpenCode AI Providers Configuration
# Configuración de modelos de IA para OpenCode
# Basado en: https://github.com/linuxmobile/kaku
# ════════════════════════════════════════════════════════════════════════════
#
# NOTA: Esta configuración usa el plugin antigravity-auth que proporciona
# acceso a modelos premium de forma gratuita a través de Google y OpenRouter.
# Si prefieres usar tus propias API keys, puedes modificar esta configuración.
#
# Modelos disponibles:
# - Gemini 3 Pro (Low/High) - Google's latest model
# - Gemini 3 Flash - Faster responses
# - Claude Sonnet 4.5 - Anthropic's latest (with thinking variants)
# - Claude Opus 4.5 - Most capable (with thinking variants)
# - GPT-OSS 120B - Open source alternative
# ════════════════════════════════════════════════════════════════════════════
{
  config = {
    google = {
      npm = "@ai-sdk/google";
      models = {
        # ══════════════════════════════════════════════════════════════════════
        # Gemini 3 Pro - Modelo principal de Google
        # ══════════════════════════════════════════════════════════════════════
        "antigravity-gemini-3-pro-low" = {
          name = "Gemini 3 Pro Low (Antigravity)";
          limit = {
            context = 1048576;  # ~1M tokens de contexto
            output = 65535;     # ~65K tokens de salida
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };
        "antigravity-gemini-3-pro-high" = {
          name = "Gemini 3 Pro High (Antigravity)";
          limit = {
            context = 1048576;
            output = 65535;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # Gemini 3 Flash - Respuestas más rápidas
        # ══════════════════════════════════════════════════════════════════════
        "antigravity-gemini-3-flash" = {
          name = "Gemini 3 Flash (Antigravity)";
          limit = {
            context = 1048576;
            output = 65536;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # Claude Sonnet 4.5 - Equilibrio entre velocidad y capacidad
        # ══════════════════════════════════════════════════════════════════════
        "antigravity-claude-sonnet-4-5" = {
          name = "Claude Sonnet 4.5 (Antigravity)";
          limit = {
            context = 200000;   # 200K tokens de contexto
            output = 64000;     # 64K tokens de salida
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        # Variantes con "thinking" (razonamiento extendido)
        "antigravity-claude-sonnet-4-5-thinking-low" = {
          name = "Claude Sonnet 4.5 Thinking Low (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };
        "antigravity-claude-sonnet-4-5-thinking-medium" = {
          name = "Claude Sonnet 4.5 Thinking Medium (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };
        "antigravity-claude-sonnet-4-5-thinking-high" = {
          name = "Claude Sonnet 4.5 Thinking High (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # Claude Opus 4.5 - Modelo más capaz de Anthropic
        # ══════════════════════════════════════════════════════════════════════
        "antigravity-claude-opus-4-5-thinking-low" = {
          name = "Claude Opus 4.5 Thinking Low (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };
        "antigravity-claude-opus-4-5-thinking-medium" = {
          name = "Claude Opus 4.5 Thinking Medium (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };
        "antigravity-claude-opus-4-5-thinking-high" = {
          name = "Claude Opus 4.5 Thinking High (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # GPT-OSS 120B - Alternativa open source
        # ══════════════════════════════════════════════════════════════════════
        "antigravity-gpt-oss-120b-medium" = {
          name = "GPT-OSS 120B Medium (Antigravity)";
          limit = {
            context = 131072;   # 128K tokens de contexto
            output = 32768;     # 32K tokens de salida
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };
      };
    };
  };
}
