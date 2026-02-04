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
# - Gemini 3 Pro (con variantes low/high)
# - Gemini 3 Flash (con variantes minimal/low/medium/high)
# - Gemini 2.5 Pro/Flash (modelos estables)
# - Gemini 3 Preview (modelos en preview)
# - Claude Sonnet 4.5 (con thinking configurable)
# - Claude Opus 4.5 (con thinking configurable)
# ════════════════════════════════════════════════════════════════════════════
{
  config = {
    google = {
      npm = "@ai-sdk/google";
      models = {
        # ══════════════════════════════════════════════════════════════════════
        # Gemini 3 Pro - Modelo principal de Google con variantes
        # ══════════════════════════════════════════════════════════════════════
        antigravity-gemini-3-pro = {
          name = "Gemini 3 Pro (Antigravity)";
          limit = {
            context = 1048576;  # ~1M tokens de contexto
            output = 65535;     # ~65K tokens de salida
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
          variants = {
            low = {thinkingLevel = "low";};
            high = {thinkingLevel = "high";};
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # Gemini 3 Flash - Respuestas más rápidas con múltiples variantes
        # ══════════════════════════════════════════════════════════════════════
        antigravity-gemini-3-flash = {
          name = "Gemini 3 Flash (Antigravity)";
          limit = {
            context = 1048576;
            output = 65536;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
          variants = {
            minimal = {thinkingLevel = "minimal";};
            low = {thinkingLevel = "low";};
            medium = {thinkingLevel = "medium";};
            high = {thinkingLevel = "high";};
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # Claude Sonnet 4.5 - Equilibrio entre velocidad y capacidad
        # ══════════════════════════════════════════════════════════════════════
        antigravity-claude-sonnet-4-5 = {
          name = "Claude Sonnet 4.5 (no thinking) (Antigravity)";
          limit = {
            context = 200000;   # 200K tokens de contexto
            output = 64000;     # 64K tokens de salida
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        # Claude Sonnet 4.5 con thinking configurable
        antigravity-claude-sonnet-4-5-thinking = {
          name = "Claude Sonnet 4.5 Thinking (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
          variants = {
            low = {thinkingConfig = {thinkingBudget = 8192;};};
            max = {thinkingConfig = {thinkingBudget = 32768;};};
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # Claude Opus 4.5 - Modelo más capaz de Anthropic
        # ══════════════════════════════════════════════════════════════════════
        antigravity-claude-opus-4-5-thinking = {
          name = "Claude Opus 4.5 Thinking (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
          variants = {
            low = {thinkingConfig = {thinkingBudget = 8192;};};
            max = {thinkingConfig = {thinkingBudget = 32768;};};
          };
        };

        # ══════════════════════════════════════════════════════════════════════
        # Gemini 2.5 - Modelos estables
        # ══════════════════════════════════════════════════════════════════════
        gemini-2-5-flash = {
          name = "Gemini 2.5 Flash (Gemini CLI)";
          limit = {
            context = 1048576;
            output = 65536;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        gemini-2-5-pro = {
          name = "Gemini 2.5 Pro (Gemini CLI)";
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
        # Gemini 3 Preview - Modelos en preview
        # ══════════════════════════════════════════════════════════════════════
        gemini-3-flash-preview = {
          name = "Gemini 3 Flash Preview (Gemini CLI)";
          limit = {
            context = 1048576;
            output = 65536;
          };
          modalities = {
            input = ["text" "image" "pdf"];
            output = ["text"];
          };
        };

        gemini-3-pro-preview = {
          name = "Gemini 3 Pro Preview (Gemini CLI)";
          limit = {
            context = 1048576;
            output = 65535;
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
