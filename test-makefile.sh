#!/usr/bin/env bash
# Script de Testing Automático del Makefile
# Ejecuta todos los comandos seguros en orden

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Contadores
TOTAL_TESTED=0
TOTAL_PASSED=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0

# Función para probar comando
test_command() {
    local cmd="$1"
    local description="$2"
    
    echo -e "${BLUE}Testing:${NC} $cmd"
    echo -e "${CYAN}$description${NC}"
    
    if eval "$cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}\n"
        ((TOTAL_PASSED++))
    else
        echo -e "${RED}✗ FAIL${NC}\n"
        ((TOTAL_FAILED++))
    fi
    ((TOTAL_TESTED++))
    sleep 0.5
}

# Función para skip
skip_command() {
    local cmd="$1"
    local reason="$2"
    
    echo -e "${YELLOW}⊘ SKIP:${NC} $cmd"
    echo -e "${YELLOW}  Reason: $reason${NC}\n"
    ((TOTAL_SKIPPED++))
}

echo -e "${PURPLE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║     MAKEFILE AUTOMATED TESTING SUITE                 ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# ============================================================================
echo -e "${GREEN}═══ NIVEL 0: Sistema de Ayuda (3 comandos) ===${NC}"
# ============================================================================

test_command "make help | head -5" "Show all commands"
test_command "make help-examples | head -10" "Show commands with examples"
test_command "make help-advanced | head -10" "Show workflows"

echo -e "${GREEN}✅ NIVEL 0 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 1: Información y Consulta (15 comandos) ===${NC}"
# ============================================================================

test_command "make info" "Show system information"
test_command "make status" "Show comprehensive status"
test_command "make version" "Show versions"
test_command "make current-generation" "Show current generation"
test_command "make list-generations | head -10" "List generations"
test_command "make generation-sizes" "Show generation sizes"
test_command "make list-hosts" "List available hosts"
test_command "make hosts-info" "Show hosts info"
test_command "make packages | head -20" "List packages"
test_command "make changelog | head -10" "Show recent changes"
test_command "make changelog-detailed | head -10" "Show detailed changelog"
test_command "make show" "Show flake outputs"
test_command "make check-syntax" "Check syntax"
test_command "make docs-local" "Show local docs"
test_command "make tree | head -20" "Show tree structure"

echo -e "${GREEN}✅ NIVEL 1 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 2: Búsqueda (2 comandos) ===${NC}"
# ============================================================================

test_command "make search PKG=firefox" "Search for firefox"
test_command "make search-installed PKG=bash" "Search installed bash"

echo -e "${GREEN}✅ NIVEL 2 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 3: Diff y Comparación (5 comandos) ===${NC}"
# ============================================================================

test_command "make diff-config" "Show uncommitted changes"
test_command "make diff-flake" "Show flake changes"
test_command "make diff-generations" "Compare generations"

# Para diff-gen necesitamos números de generación
echo -e "${BLUE}Getting generation numbers for diff-gen...${NC}"
CURRENT_GEN=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -1 | awk '{print $1}')
PREV_GEN=$((CURRENT_GEN - 1))
if [ "$PREV_GEN" -gt 0 ]; then
    test_command "make diff-gen GEN1=$PREV_GEN GEN2=$CURRENT_GEN" "Compare specific generations"
else
    skip_command "make diff-gen" "No previous generation"
fi

test_command "make compare-hosts HOST1=hydenix HOST2=laptop" "Compare hosts"

echo -e "${GREEN}✅ NIVEL 3 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 4: Logs (3 comandos) ===${NC}"
# ============================================================================

test_command "make logs-errors | head -10" "Show error logs"
test_command "make logs-boot | head -10" "Show boot logs"
test_command "make logs-service SVC=systemd-journald | head -10" "Show service logs"

skip_command "make watch-logs" "Interactive command"
skip_command "make watch-rebuild" "Interactive command"

echo -e "${GREEN}✅ NIVEL 4 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 5: Validación (3 comandos) ===${NC}"
# ============================================================================

test_command "make validate" "Validate configuration"
test_command "make health" "Health check"
test_command "make dry-run" "Dry run"

echo -e "${GREEN}✅ NIVEL 5 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 6: Export (4 comandos) ===${NC}"
# ============================================================================

test_command "make update-info" "Show update info"
test_command "make diff-update" "Show update diff"

# Skip export commands that create files
skip_command "make export-config" "Creates tarball files"
skip_command "make export-minimal" "Creates tarball files"
skip_command "make readme" "Interactive pager"
skip_command "make tutorial" "Interactive pager"

echo -e "${GREEN}✅ NIVEL 6 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 7: Templates (SKIP - crea archivos) ===${NC}"
# ============================================================================

skip_command "make new-host" "Creates new host files"
skip_command "make new-module" "Creates new module files"

echo -e "${GREEN}✅ NIVEL 7 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 8: Git (1 comando) ===${NC}"
# ============================================================================

test_command "make git-status" "Show git status"

echo -e "${GREEN}✅ NIVEL 8 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 9: Backup (SKIP - crea archivos) ===${NC}"
# ============================================================================

skip_command "make backup" "Creates backup directory"

echo -e "${GREEN}✅ NIVEL 9 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 10: Build Analysis (3 comandos) ===${NC}"
# ============================================================================

test_command "make closure-size" "Show closure size"
test_command "make why-depends PKG=bash" "Show why depends"
test_command "make build-trace | head -20" "Show build trace"

echo -e "${GREEN}✅ NIVEL 10 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 11: Build Commands (SKIP - pesados) ===${NC}"
# ============================================================================

skip_command "make build" "Takes too long"
skip_command "make benchmark" "Does full build"

echo -e "${GREEN}✅ NIVEL 11 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 12: Advanced (SKIP - interactivos) ===${NC}"
# ============================================================================

skip_command "make repl" "Interactive REPL"
skip_command "make shell" "Interactive shell"
skip_command "make vm" "Builds VM, takes long"

echo -e "${GREEN}✅ NIVEL 12 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 13: Maintenance (1 comando) ===${NC}"
# ============================================================================

test_command "make clean-result" "Clean result symlinks"

echo -e "${GREEN}✅ NIVEL 13 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 14: Quick Fixes (SKIP - modifican) ===${NC}"
# ============================================================================

skip_command "make fix-permissions" "Modifies permissions"
skip_command "make fix-store" "Verifies store (slow)"

echo -e "${GREEN}✅ NIVEL 14 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${GREEN}═══ NIVEL 16: Linting (1 comando) ===${NC}"
# ============================================================================

test_command "make lint" "Lint nix files"

skip_command "make format" "Modifies .nix files"

echo -e "${GREEN}✅ NIVEL 16 COMPLETADO${NC}\n"

# ============================================================================
echo -e "${YELLOW}═══ COMANDOS QUE MODIFICAN SISTEMA (SKIPPED) ===${NC}"
# ============================================================================

echo -e "${YELLOW}Los siguientes comandos modifican el sistema y deben probarse manualmente:${NC}"
echo -e "${YELLOW}  - make switch, test, boot, rollback${NC}"
echo -e "${YELLOW}  - make update, upgrade, update-*${NC}"
echo -e "${YELLOW}  - make clean, clean-*, optimize${NC}"
echo -e "${YELLOW}  - make deep-clean (PELIGROSO)${NC}"
echo ""

# ============================================================================
echo -e "${PURPLE}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║              TESTING SUMMARY                          ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════╝${NC}"
# ============================================================================

echo ""
echo -e "${CYAN}Total Commands Tested:${NC}  $TOTAL_TESTED"
echo -e "${GREEN}Passed:${NC}                 $TOTAL_PASSED"
echo -e "${RED}Failed:${NC}                 $TOTAL_FAILED"
echo -e "${YELLOW}Skipped:${NC}                $TOTAL_SKIPPED"
echo ""

if [ $TOTAL_FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ ALL TESTED COMMANDS PASSED!${NC}"
    echo -e "${GREEN}🎉 Your Makefile is working perfectly!${NC}"
else
    echo -e "${RED}❌ Some commands failed. Review the output above.${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}Next steps:${NC}"
echo -e "  1. Review the commands that were skipped"
echo -e "  2. Test system-modifying commands manually if needed"
echo -e "  3. Run: make help-examples to see usage examples"
echo ""

