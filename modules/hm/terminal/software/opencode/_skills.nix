# ════════════════════════════════════════════════════════════════════════════
# OpenCode Skills Configuration
# Skills (habilidades) que extienden las capacidades de OpenCode
# Basado en: https://github.com/linuxmobile/kaku
# ════════════════════════════════════════════════════════════════════════════
#
# Los skills son archivos SKILL.md que proporcionan instrucciones especializadas
# al modelo de IA para tareas específicas como:
# - Technical Writing
# - Refactoring Patterns
# - Frontend Design
# - Architecture Patterns
# - etc.
#
# Se descargan de repositorios públicos de GitHub y se instalan en:
# ~/.config/opencode/skill/
# ════════════════════════════════════════════════════════════════════════════
{pkgs}: let
  # ══════════════════════════════════════════════════════════════════════════
  # Función para descargar un skill individual (archivo SKILL.md)
  # ══════════════════════════════════════════════════════════════════════════
  fetchSkill = {
    name,     # Nombre del skill
    owner,    # Usuario/org de GitHub
    repo,     # Nombre del repositorio
    rev,      # Commit hash
    path,     # Path al archivo SKILL.md dentro del repo
    hash,     # Hash SHA256 del contenido
  }:
    pkgs.stdenv.mkDerivation {
      name = "opencode-skill-${name}";
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev hash;
      };

      installPhase = ''
        mkdir -p $out
        cp ${path} $out/SKILL.md
      '';
    };

  # ══════════════════════════════════════════════════════════════════════════
  # Función para descargar un directorio de skill completo
  # (para skills que tienen múltiples archivos)
  # ══════════════════════════════════════════════════════════════════════════
  fetchSkillDir = {
    name,
    owner,
    repo,
    rev,
    basePath,  # Path al directorio del skill
    hash,
  }:
    pkgs.stdenv.mkDerivation {
      name = "opencode-skill-${name}";
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev hash;
      };

      installPhase = ''
        mkdir -p $out
        cp -r ${basePath}/* $out/
      '';
    };

  # ══════════════════════════════════════════════════════════════════════════
  # Definición de skills disponibles
  # Puedes comentar/descomentar los que quieras usar
  # ══════════════════════════════════════════════════════════════════════════
  skills = {
    # ── Escritura Técnica ──────────────────────────────────────────────────
    technical-writing = fetchSkill {
      name = "technical-writing";
      owner = "proffesor-for-testing";
      repo = "agentic-qe";
      rev = "990aee4a6a747f2db0ef77a2f67d58462f61e608";
      path = ".claude/skills/technical-writing/SKILL.md";
      hash = "sha256-PdIVhLp5/quigz325ZeG4NaWUgPsD3PgykSD61FFjLo=";
    };

    # ── Patrones de Refactoring ────────────────────────────────────────────
    refactoring-patterns = fetchSkill {
      name = "refactoring-patterns";
      owner = "proffesor-for-testing";
      repo = "agentic-qe";
      rev = "990aee4a6a747f2db0ef77a2f67d58462f61e608";
      path = ".claude/skills/refactoring-patterns/SKILL.md";
      hash = "sha256-PdIVhLp5/quigz325ZeG4NaWUgPsD3PgykSD61FFjLo=";
    };

    # ── Escritor de Blog Posts ─────────────────────────────────────────────
    blog-post-writer = fetchSkillDir {
      name = "blog-post-writer";
      owner = "nicknisi";
      repo = "dotfiles";
      rev = "f1be3f2b669c8e3401b589141f9a56651e45a1a7";
      basePath = "home/.claude/skills/blog-post-writer";
      hash = "sha256-U1GqtQMgzimGbbDJpqIGrBnu5HiSTZDETAKFhijMU9s=";
    };

    # ── Diseño Frontend ────────────────────────────────────────────────────
    frontend-design = fetchSkill {
      name = "frontend-design";
      owner = "anthropics";
      repo = "claude-code";
      rev = "d213a74fc8e3b6efded52729196e0c2d4c3abb3e";
      path = "plugins/frontend-design/skills/frontend-design/SKILL.md";
      hash = "sha256-SleLxTUjM7HNHc78YklikuFwix2DPaTDIACUnsSQCrA=";
    };

    # ── Patrones de Arquitectura ───────────────────────────────────────────
    architecture-patterns = fetchSkill {
      name = "architecture-patterns";
      owner = "wshobson";
      repo = "agents";
      rev = "e4dade12847a99d277d81192c2966e9b61c0d3f1";
      path = "plugins/backend-development/skills/architecture-patterns/SKILL.md";
      hash = "sha256-UiiJzLo8fJLMoCjh389v1P0Q4Nc36S8Po+fvm/j0gxo=";
    };

    # ── Desarrollo Flutter ─────────────────────────────────────────────────
    flutter-development = fetchSkill {
      name = "flutter-development";
      owner = "aj-geddes";
      repo = "useful-ai-prompts";
      rev = "ce8c39c22df0e0e64c853817a7f8d79f0ea331e2";
      path = "skills/flutter-development/SKILL.md";
      hash = "sha256-BCvO+P2URoTiUOSV8PTq62ckyxXLEHtIml0EkZGRbK8=";
    };

    # ── Escribir Documentación ─────────────────────────────────────────────
    writing-documentation = fetchSkillDir {
      name = "writing-documentation";
      owner = "dhruvbaldawa";
      repo = "ccconfigs";
      rev = "451b604718d39fcc2c008d22e550bdf60c7115da";
      basePath = "essentials/skills/writing-documentation";
      hash = "sha256-7V1xG2FmzqWdnWmVV6WWKBAvY6QHWo+UKzh0Uu/Xg/w=";
    };

    # ── Ingeniero Rust ─────────────────────────────────────────────────────
    rust-engineer = fetchSkill {
      name = "rust-engineer";
      owner = "sammcj";
      repo = "agentic-coding";
      rev = "f2ee2fb7138b78856b68c9b874d6e3d406a2a8a4";
      path = "Claude/skills_disabled/rust-engineer/SKILL.md";
      hash = "sha256-vQpInoUbctAwT/eL/27Gr6UkuNH3Au8By2PCXM5z9AQ=";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════
  # Combinar todos los skills en un solo derivation
  # Esto crea la estructura: $out/skill/<nombre-skill>/SKILL.md
  # ══════════════════════════════════════════════════════════════════════════
  allSkills = pkgs.runCommand "opencode-skills" {} ''
    mkdir -p $out/skill

    ${pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList (name: skill: ''
        mkdir -p $out/skill/${name}
        cp -r ${skill}/* $out/skill/${name}/
      '')
      skills)}
  '';
in {
  packages = [];  # Los skills no agregan paquetes al PATH
  skillsSource = allSkills;
}
