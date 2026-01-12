#!/usr/bin/env bash
# Script para hacer commits atómicos de la reorganización
# Ejecuta esto en tu terminal: bash ~/dotfiles/commit_reorganization.sh

set -e  # Exit on error
cd ~/dotfiles

echo "🚀 Iniciando commits atómicos de la reorganización..."
echo ""

# Crear rama
echo "📌 Creando rama feature/reorganize-structure..."
git checkout -b feature/reorganize-structure
echo "✅ Rama creada"
echo ""

# Commit 1: Documentación
echo "📝 Commit 1/8: Documentación de análisis..."
git add ANALYSIS.md AGENTS.md MIGRATION_COMPLETE.md
git commit -m "docs: add comprehensive migration documentation

📚 ANALYSIS.md - Análisis comparativo de 3 repos Hydenix
- Compara gitm3-hydenix (Makefile), nixdots (files.nix), nixos-flake-hydenix (hosts/)
- Documenta fortalezas y debilidades de cada enfoque
- Propone estructura híbrida óptima
- Plan de migración en 4 fases

📋 AGENTS.md - Sistema de tracking de progreso
- Control atómico de cada tarea (21 total)
- Barras de progreso visuales por fase
- Lista de commits realizados
- Criterios de éxito por fase
- Estado actual: 81% completado (Core: 100%)

🎉 MIGRATION_COMPLETE.md - Resumen final
- Métricas de mejora (85% reducción en default.nix)
- Before/After comparisons
- Quick start guide
- Referencias a toda la documentación"
echo "✅ Commit 1 completado"
echo ""

# Commit 2: Makefile
echo "🔧 Commit 2/8: Makefile profesional..."
git add Makefile
git commit -m "feat: add professional Makefile with 40+ commands

🔧 Makefile - Sistema de gestión completo (adaptado de gitm3-hydenix)

Categorías de comandos:
- Building: switch, test, build, dry-run, boot, quick
- Debugging: debug, check-syntax, show, emergency
- Maintenance: clean (30/7/90d), deep-clean, optimize
- Updates: update, upgrade, update-nixpkgs, update-hydenix
- Git: git-add, git-commit, git-push, save
- Backup: backup, list-generations, rollback
- Info: info, status, progress, phases
- Hardware: hardware-scan, watch-logs
- Advanced: repl, shell, vm

Features:
- Output con colores (ANSI codes)
- Help automático (make help)
- Variables configurables (HOSTNAME=hydenix)
- Comandos de migración (progress, phases)
- Integración GitHub CLI"
echo "✅ Commit 2 completado"
echo ""

# Commit 3: Estructura hosts
echo "🏠 Commit 3/8: Estructura multi-host..."
git add hosts/
git commit -m "feat: create multi-host structure for scalability

🏠 hosts/ - Arquitectura multi-máquina

hosts/default.nix - Configuración compartida
- Imports comunes (home-manager, hydenix, system)
- Paquetes base, Nix settings, NetworkManager
- Heredado por todos los hosts

hosts/hydenix/ - PC desktop principal (ACTIVO)
- configuration.nix: hostname, timezone, locale
- user.nix: usuario ludus con home-manager
- Intel CPU + SSD optimizations

hosts/vm/ - Template para VMs
- QEMU guest additions, spice-vdagent
- Recursos reducidos, gaming disabled
- Template listo para personalizar

hosts/laptop/ - Template para laptops
- TLP power management (40-80% charge)
- Touchpad, backlight, WiFi
- Battery optimization completa

hosts/README.md - Guía completa
- Cómo agregar hosts paso a paso
- Ejemplos de clonación
- Testing workflow
- Integración con Makefile"
echo "✅ Commit 3 completado"
echo ""

# Commit 4: Programs reorganization
echo "📦 Commit 4/8: Reorganización de programs/..."
git add modules/hm/programs/ modules/hm/hydenix-config.nix
git commit -m "refactor: reorganize home-manager into programs/ structure

📦 modules/hm/programs/ - Organizado por categoría

programs/terminal/ - Todo lo relacionado a terminal
- emulators/: foot, ghostty
- shell/: fish, starship (separado de zsh)
- software/: git, gh, lazygit, cli tools, opencode

programs/browsers/ - Navegadores web
- brave, chromium, google-chrome, zen

programs/development/ - Dev tools
- languages.nix: lenguajes y runtimes
- Preparado para git.nix, docker.nix

modules/hm/hydenix-config.nix - Todas las configs
- Extraído de default.nix (era 238 líneas)
- Todas las configs de modules.* aquí
- Documentación inline completa
- Git, GitHub CLI, Lazygit, Atuin, Yazi
- CLI tools, emuladores, shell
- OpenCode AI assistant con MCP"
echo "✅ Commit 4 completado"
echo ""

# Commit 5: Simplificar default.nix
echo "📝 Commit 5/8: Simplificación de default.nix..."
git add modules/hm/default.nix
git commit -m "refactor: simplify hm/default.nix - 85% code reduction

📝 modules/hm/default.nix - Simplificado radicalmente

ANTES: 238 líneas con configs mezcladas
DESPUÉS: 35 líneas con solo imports

Contiene:
1. Imports de programs/ y hydenix-config.nix
2. home.packages para extras
3. hydenix.hm.enable settings

Ventajas:
- 85% menos código (238 → 35 líneas)
- Punto de entrada claro
- Configuraciones en archivos dedicados
- Fácil de leer y mantener"
echo "✅ Commit 5 completado"
echo ""

# Commit 6: System modules
echo "⚙️  Commit 6/8: Módulos de sistema..."
git add modules/system/
git commit -m "refactor: organize system modules thematically

⚙️ modules/system/ - Módulos sistema organizados

modules/system/packages.nix - Paquetes sistema
- VLC y futuros paquetes system-wide
- Separado por categorías (media, etc.)

modules/system/default.nix - Import central
- Imports packages.nix
- Preparado para audio.nix, boot.nix, networking.nix
- Estructura modular escalable"
echo "✅ Commit 6 completado"
echo ""

# Commit 7: Resources folder
echo "📁 Commit 7/8: Folder resources/..."
git add resources/
git commit -m "feat: add resources/ folder for mutable configs

📁 resources/ - Configs mutables y assets

resources/config/ - Archivos de config planos
- hypr/, fish/, starship/
- Editables como texto plano

resources/scripts/ - Scripts de utilidad
- Bash, python, etc.

resources/wallpapers/ - Fondos de pantalla
- Para temas de Hydenix

resources/README.md - Guía de uso
- Cómo usar configs mutables
- Ejemplos de home.file con lib.mkForce
- Filosofía híbrida (inmutable Nix + mutable resources)"
echo "✅ Commit 7 completado"
echo ""

# Commit 8: README y archivos modificados
echo "📚 Commit 8/9: README y archivos finales..."
git add README.md configuration.nix flake.nix
git commit -m "docs: update README and core files for new structure

📚 README.md - Completamente reescrito
- Estructura visual del proyecto
- Quick start guide
- Tabla de archivos clave
- Comandos del Makefile
- Software instalado
- Guía de customización
- Multi-host setup
- Links a documentación

📄 configuration.nix - Wrapper de compatibilidad
- Re-exporta hosts/hydenix/configuration.nix
- Mantiene backward compatibility
- Deprecation notice

📦 flake.nix - Actualizado para hosts/
- Módulos apuntan a hosts/hydenix/configuration.nix
- Comentarios mejorados
- Preparado para múltiples hosts"
echo "✅ Commit 8 completado"
echo ""

# Commit 9: AI Tools sin restricciones
echo "🤖 Commit 9/9: Configuración AI tools sin restricciones..."
git add modules/system/ai-tools-unrestricted.nix modules/system/AI_TOOLS_README.md modules/system/default.nix
git commit -m "feat: add unrestricted configuration for AI tools

🤖 modules/system/ai-tools-unrestricted.nix - Sin restricciones
Configuración completa para dar libertad total a:
- Cursor (AI IDE)
- VSCode con AI extensions  
- Antigravity (OpenCode plugin)
- OpenCode (Terminal AI)

Cambios aplicados:
- Nix sandbox DISABLED (permite ejecución sin restricciones)
- Sudo sin contraseña para wheel
- Usuario en grupos privilegiados (docker, libvirtd, disk, etc.)
- Polkit sin restricciones para operaciones comunes
- Git sin safe.directory checks
- AppArmor disabled
- Variables de entorno optimizadas (NIX_LD, SANDBOX=false)

📚 modules/system/AI_TOOLS_README.md - Documentación completa
- Explicación de cada cambio y su impacto
- Advertencias de seguridad claras
- Cómo revertir si es necesario
- Comparación antes/después
- Testing checklist
- Referencias a docs NixOS

⚙️ modules/system/default.nix - Import agregado
- Importa ai-tools-unrestricted.nix
- Activo por defecto en hydenix host

Resultado:
✅ Cursor puede ejecutar comandos sin problemas
✅ Git funciona en cualquier directorio
✅ Sudo sin fricción en scripts
✅ Nix builds sin sandbox errors
✅ AI agents con autonomía completa

⚠️ IMPORTANTE:
Solo para desarrollo local. NO usar en:
- Servidores expuestos
- VMs públicas
- Laptops en redes no confiables"
echo "✅ Commit 9 completado"
echo ""

echo "🎉 ¡Todos los commits completados!"
echo ""
echo "📊 Resumen:"
git log --oneline -9
echo ""
echo "🚀 Próximos pasos:"
echo "1. Revisar los commits: git log"
echo "2. Push a GitHub: git push -u origin feature/reorganize-structure"
echo "3. Crear PR: gh pr create"
echo ""
echo "✅ Reorganización completada!"

