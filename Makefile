# NixOS Management Makefile
# Place this in your flake directory (where flake.nix is located)

.PHONY: help help-examples switch test build clean update check format lint test-network

# Default target
.DEFAULT_GOAL := help

# Configuration
FLAKE_DIR := .
HOSTNAME ?= hydenix
AVAILABLE_HOSTS := hydenix laptop vm

# Colors for pretty output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color


# === Ayuda y Documentación ===

help: ## Show this help message
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)      Ayuda Avanzada y Workflows (Makefile)        \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@awk -v GREEN="$(GREEN)" -v BLUE="$(BLUE)" -v NC="$(NC)" 'BEGIN {FS=":.*##"} /^[a-zA-Z0-9_-]+:.*##/ {desc[$$1]=$$2} \
	function print_cat(title, list,    n,i,cmd) { \
		printf "\n%s%s%s\n", BLUE, title, NC; \
		n = split(list, arr, " "); \
		for (i=1; i<=n; i++) { \
			cmd = arr[i]; \
			if (cmd in desc) { \
				printf "  %s%-18s%s %s\n", GREEN, cmd, NC, desc[cmd]; \
			} else { \
				printf "  %s%-18s%s %s\n", GREEN, cmd, NC, "(sin descripción)"; \
			} \
		} \
	} \
	END { \
		print_cat("Ayuda y Documentación", "help help-examples docs-local docs-dev docs-build docs-install docs-clean"); \
		print_cat("Gestión del Sistema (Rebuild/Switch)", "switch safe-switch test build dry-run boot validate debug quick emergency"); \
		print_cat("Limpieza y Optimización", "clean clean-week clean-conservative deep-clean optimize clean-result fix-store"); \
		print_cat("Actualizaciones y Flakes", "update update-nixpkgs update-hydenix update-input diff-update upgrade show flake-check diff-flake"); \
		print_cat("Generaciones y Rollback", "list-generations rollback diff-generations diff-gen generation-sizes current-generation"); \
		print_cat("Git y Respaldo", "git-add git-commit git-push git-status git-diff save"); \
		print_cat("Diagnóstico y Logs", "health test-network info status watch-logs logs-boot logs-errors logs-service"); \
		print_cat("Análisis y Desarrollo", "list-hosts hosts-info search search-installed repl shell vm closure-size"); \
		print_cat("Formato, Linting y Estructura", "format lint tree"); \
		print_cat("Reportes y Exportación", "git-log"); \
		print_cat("Plantillas y Otros", "hardware-scan fix-permissions fix-git-permissions"); \
		printf "\nWorkflows sugeridos:\n"; \
		printf "  • Desarrollo diario:  make test → make switch → make rollback\n"; \
		printf "  • Updates seguros:    make update → make diff-update → make validate → make test → make switch\n"; \
		printf "  • Mantenimiento:      make health → make clean → make optimize → make generation-sizes\n"; \
		printf "  • Multi-host:         make list-hosts → make switch HOSTNAME=laptop\n"; \
		printf "\nAyuda rápida: make help | make help-examples | less MAKEFILE_TUTORIAL.md\n\n"; \
	}' $(MAKEFILE_LIST)
help-examples: ## Show commands with usage examples
	@printf "$(CYAN)╔════════════════════════════════════════════════════╗\n$(NC)"
	@printf "$(CYAN)║        NixOS Commands with Usage Examples          ║\n$(NC)"
	@printf "$(CYAN)╚════════════════════════════════════════════════════╝\n$(NC)"
	@printf "\n$(PURPLE)💡 Tip: Commands without parameters can be run directly$(NC)\n"
	@printf "$(PURPLE)   Commands with parameters are shown with examples below$(NC)\n\n"
	@printf "$(GREEN)═══ 🔨 Build & Deploy ═══$(NC)\n"
	@printf "$(BLUE)switch HOSTNAME=<host>$(NC)\n"
	@printf "  → make switch HOSTNAME=laptop\n\n"
	@printf "$(GREEN)═══ 🔍 Search & Discovery ═══$(NC)\n"
	@printf "$(BLUE)search PKG=<name>$(NC)\n"
	@printf "  → make search PKG=firefox\n"
	@printf "  → make search PKG=neovim\n\n"
	@printf "$(BLUE)search-installed PKG=<name>$(NC)\n"
	@printf "  → make search-installed PKG=kitty\n"
	@printf "  → make search-installed PKG=docker\n\n"
	@printf "$(GREEN)═══ 📦 Updates ═══$(NC)\n"
	@printf "$(BLUE)update-input INPUT=<name>$(NC)\n"
	@printf "  → make update-input INPUT=hydenix\n"
	@printf "  → make update-input INPUT=nixpkgs\n"
	@printf "  → make update-input INPUT=zen-browser-flake\n\n"
	@printf "$(GREEN)═══ 💾 Generations ═══$(NC)\n"
	@printf "$(BLUE)diff-gen GEN1=<n> GEN2=<m>$(NC)\n"
	@printf "  → make diff-gen GEN1=20 GEN2=25\n"
	@printf "  → make diff-gen GEN1=184 GEN2=186\n\n"
	@printf "$(GREEN)═══ 📋 Logs & Monitoring ═══$(NC)\n"
	@printf "$(BLUE)logs-service SVC=<service>$(NC)\n"
	@printf "  → make logs-service SVC=sshd\n"
	@printf "  → make logs-service SVC=docker\n"
	@printf "  → make logs-service SVC=networkmanager\n\n"
	@printf "$(GREEN)═══ 📊 Diff & Compare ═══$(NC)\n"
	@printf "$(GREEN)═══ 📚 Common Commands (No parameters needed) ═══$(NC)\n"
	@printf "$(BLUE)Everyday use:$(NC)\n"
	@printf "  make switch         → Apply configuration\n"
	@printf "  make test           → Test without applying\n"
	@printf "  make rollback       → Undo last change\n"
	@printf "  make validate       → Check config before applying\n\n"
	@printf "$(BLUE)Information:$(NC)\n"
	@printf "  make status         → System overview\n"
	@printf "  make health         → Health check\n"
	@printf "  make info           → System information (includes versions)\n"
	@printf "  make list-hosts     → Show available hosts\n"
	@printf "  make git-log        → Recent changes\n\n"
	@printf "$(BLUE)Maintenance:$(NC)\n"
	@printf "  make clean          → Clean old (30 days)\n"
	@printf "  make optimize       → Optimize store\n"
	@printf "  make generation-sizes → Show generation sizes\n"
	@printf "  make closure-size   → Show what uses space\n\n"
	@printf "$(BLUE)Troubleshooting:$(NC)\n"
	@printf "  make debug          → Debug rebuild\n"
	@printf "  make logs-errors    → Show errors\n"
	@printf "  make fix-permissions → Fix permission issues\n"
	@printf "  make fix-store      → Repair nix store\n\n"
	@printf "$(YELLOW)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n"
	@printf "$(YELLOW)For full command list:$(NC) make help\n"
	@printf "$(YELLOW)For workflows:$(NC) make help\n"
	@printf "$(YELLOW)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n\n"

docs-local: ## Show local documentation files
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📚 Local Documentation                    \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@COUNT=0; \
	if [ -f "README.md" ]; then \
		printf "  $(GREEN)✓$(NC) $(BLUE)README.md$(NC)\n"; \
		COUNT=$$((COUNT + 1)); \
	fi; \
	if [ -f "MAKEFILE_TUTORIAL.md" ]; then \
		printf "  $(GREEN)✓$(NC) $(BLUE)MAKEFILE_TUTORIAL.md$(NC)\n"; \
		COUNT=$$((COUNT + 1)); \
	fi; \
	if [ -f "MAKEFILE_IMPROVEMENTS_PLAN.md" ]; then \
		printf "  $(GREEN)✓$(NC) $(BLUE)MAKEFILE_IMPROVEMENTS_PLAN.md$(NC)\n"; \
		COUNT=$$((COUNT + 1)); \
	fi; \
	if [ -f "AGENTS.md" ]; then \
		printf "  $(GREEN)✓$(NC) $(BLUE)AGENTS.md$(NC)\n"; \
		COUNT=$$((COUNT + 1)); \
	fi; \
	if [ -d "docs/" ]; then \
		printf "  $(GREEN)✓$(NC) $(BLUE)docs/$(NC)\n"; \
		DOCS_COUNT=0; \
		for doc in docs/*.md; do \
			if [ -f "$$doc" ]; then \
				printf "    ├─ $(PURPLE)$$doc$(NC)\n"; \
				DOCS_COUNT=$$((DOCS_COUNT + 1)); \
			fi; \
		done; \
		if [ $$DOCS_COUNT -eq 0 ]; then \
			printf "    └─ $(YELLOW)No .md files found$(NC)\n"; \
		fi; \
		COUNT=$$((COUNT + 1)); \
	fi; \
	if [ $$COUNT -eq 0 ]; then \
		printf "  $(YELLOW)⚠ No documentation files found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)💡 Tip:$(NC) Use $(GREEN)less <file>$(NC) or $(GREEN)cat <file>$(NC) to view documentation\n"
	@printf "\n"
docs-dev: ## Run Astro docs dev server locally
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📘 Servidor de Documentación              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if [ -d "docs" ]; then \
		if [ ! -d "docs/node_modules" ]; then \
			printf "$(YELLOW)📦 Instalando dependencias primero...\n$(NC)"; \
			cd docs && npm install; \
			printf "\n"; \
		fi; \
		printf "$(BLUE)Iniciando servidor de desarrollo Astro...\n$(NC)"; \
		printf "$(YELLOW)La documentación estará disponible en http://localhost:4321\n$(NC)"; \
		printf "\n"; \
		cd docs && npm run dev; \
	else \
		printf "$(RED)✗ Directorio docs/ no encontrado$(NC)\n"; \
		printf "\n"; \
	fi
docs-build: ## Build Astro documentation for production
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📦 Construir Documentación                \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if [ -d "docs" ]; then \
		if [ ! -d "docs/node_modules" ]; then \
			printf "$(YELLOW)📦 Instalando dependencias primero...\n$(NC)"; \
			cd docs && npm install; \
			printf "\n"; \
		fi; \
		printf "$(BLUE)Construyendo documentación para producción...\n$(NC)"; \
		cd docs && npm run build; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Documentación construida exitosamente\n$(NC)"; \
		printf "$(BLUE)Los archivos están en docs/dist/\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "$(RED)✗ Directorio docs/ no encontrado$(NC)\n"; \
		printf "\n"; \
	fi
docs-clean: ## Clean documentation dependencies (node_modules)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Limpiar Dependencias                   \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando dependencias de la documentación...\n$(NC)"
	@if [ -d "docs/node_modules" ]; then \
		rm -rf docs/node_modules; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Dependencias limpiadas\n$(NC)"; \
		printf "$(BLUE)Se liberó espacio eliminando node_modules/\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
	else \
		printf "$(YELLOW)⚠ No hay dependencias para limpiar\n$(NC)"; \
	fi
	@printf "\n"
docs-install: ## Install/update documentation dependencies
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📦 Instalar Dependencias                  \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if [ -d "docs" ]; then \
		printf "$(BLUE)Instalando dependencias de npm...\n$(NC)"; \
		cd docs && npm install; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Dependencias instaladas\n$(NC)"; \
		printf "$(BLUE)La documentación está lista para usar.\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
	else \
		printf "$(RED)✗ Directorio docs/ no encontrado$(NC)\n"; \
	fi
	@printf "\n"

# === Gestión del Sistema (Rebuild/Switch) ===

switch: ## Build and switch to new configuration
	@printf "\n$(BLUE)==================== Switch ====================\n$(NC)"
	@printf "$(BLUE)🔄 Git add, build y switch...\n$(NC)"
	@$(MAKE) --no-print-directory fix-git-permissions
	@if [ "$$(id -u)" -eq 0 ]; then \
		if [ -n "$$SUDO_USER" ]; then \
			sudo -u "$$SUDO_USER" git add .; \
		else \
			printf "$(RED)✗ Do not run 'make switch' as root (no SUDO_USER)\n$(NC)"; \
			exit 1; \
		fi; \
	else \
		git add .; \
	fi
	@printf "\n$(BLUE)==================== Build =====================\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME)
	@printf "\n$(GREEN)==================== Done ======================\n$(NC)"
safe-switch: validate switch ## Validate then switch (safest option)
test: ## Build and test configuration (no switch)
	@printf "$(YELLOW)🧪 Testing configuration (no switch)...\n$(NC)"
	sudo nixos-rebuild test --flake $(FLAKE_DIR)#$(HOSTNAME)
build: ## Build configuration without switching
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔨 Build Configuration                    \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Building configuration without applying changes...$(NC)\n"
	@printf "$(YELLOW)This will compile but not activate the new generation.$(NC)\n"
	@printf "\n"
	@START=$$(date +%s); \
	sudo nixos-rebuild build --flake $(FLAKE_DIR)#$(HOSTNAME); \
	BUILD_EXIT=$$?; \
	END=$$(date +%s); \
	DURATION=$$((END - START)); \
	MINUTES=$$((DURATION / 60)); \
	SECONDS=$$((DURATION % 60)); \
	printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
	if [ $$BUILD_EXIT -eq 0 ]; then \
		printf "$(GREEN)✅ Build completed successfully$(NC)\n"; \
		printf "$(BLUE)Configuration compiled but not activated.$(NC)\n"; \
		printf "$(YELLOW)Use 'make switch' to apply changes.$(NC)\n"; \
		printf "\n$(BLUE)Build Statistics:$(NC)\n"; \
		if [ $$MINUTES -gt 0 ]; then \
			printf "  $(GREEN)Build time:$(NC) $(YELLOW)$${MINUTES}m $${SECONDS}s$(NC) ($(YELLOW)$${DURATION}s$(NC) total)\n"; \
		else \
			printf "  $(GREEN)Build time:$(NC) $(YELLOW)$${SECONDS}s$(NC)\n"; \
		fi; \
	else \
		printf "$(RED)✗ Build failed$(NC)\n"; \
		printf "$(YELLOW)Build time: $${DURATION}s$(NC)\n"; \
	fi; \
	printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
	printf "\n"; \
	exit $$BUILD_EXIT
dry-run: ## Show what would be built/changed
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔍 Dry Run - Preview Changes             \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Showing what would be built/changed without applying...$(NC)\n\n"
	@sudo nixos-rebuild dry-run --flake $(FLAKE_DIR)#$(HOSTNAME)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Dry run completed$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
boot: ## Build and set as boot default (no immediate switch)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🥾 Configurar para Próximo Arranque      \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Compilando y configurando para el próximo arranque...\n$(NC)"
	@printf "$(YELLOW)Los cambios se aplicarán al reiniciar el sistema.\n$(NC)"
	@printf "$(YELLOW)La sesión actual no se verá afectada.\n$(NC)"
	@printf "\n"
	sudo nixos-rebuild boot --flake $(FLAKE_DIR)#$(HOSTNAME)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Configuración preparada para próximo arranque\n$(NC)"
	@printf "$(BLUE)Reinicia el sistema para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

validate: ## Validate configuration before switching
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔍 Validation Checks                       \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)1/3 Checking flake syntax...$(NC) "
	@if nix flake check $(FLAKE_DIR) >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
		nix flake check $(FLAKE_DIR); \
		exit 1; \
	fi
	@printf "$(BLUE)2/3 Checking configuration evaluation...$(NC) "
	@if nix eval .#nixosConfigurations.$(HOSTNAME).config.system.build.toplevel >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
		nix eval .#nixosConfigurations.$(HOSTNAME).config.system.build.toplevel --show-trace; \
		exit 1; \
	fi
	@printf "$(BLUE)3/3 Checking for common issues...$(NC) "
	@if command -v statix >/dev/null 2>&1; then \
		if statix check . >/dev/null 2>&1; then \
			printf "$(GREEN)✓$(NC)\n"; \
		else \
			printf "$(YELLOW)⚠$(NC) (warnings found, see 'make lint')\n"; \
		fi \
	else \
		printf "$(YELLOW)⊘$(NC) (statix not installed)\n"; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Validation passed$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
debug: ## Rebuild with verbose output and trace
	@printf "$(RED)🐛 Debug rebuild with full trace...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --show-trace --verbose
quick: ## Quick rebuild (skip checks)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          ⚡ Rebuild Rápido (Sin Checks)              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Ejecutando rebuild rápido omitiendo verificaciones...\n$(NC)"
	@printf "$(YELLOW)⚠️  Este comando omite validaciones de seguridad para acelerar el proceso.\n$(NC)"
	@printf "$(BLUE)Útil cuando estás seguro de tu configuración y necesitas velocidad.\n$(NC)"
	@printf "\n"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --fast
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Rebuild rápido completado\n$(NC)"
	@printf "$(BLUE)Configuración aplicada sin verificaciones previas\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
emergency: ## Emergency rebuild with maximum verbosity
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🚨 Rebuild de Emergencia (Debug Extremo)   \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(RED)⚠️  MODO DE EMERGENCIA ACTIVADO\n$(NC)"
	@printf "$(YELLOW)Este comando ejecuta rebuild con máxima verbosidad y debugging.\n$(NC)"
	@printf "$(YELLOW)Desactiva caché de evaluación para forzar reconstrucción completa.\n$(NC)"
	@printf "$(BLUE)Útil cuando el sistema no arranca o hay problemas críticos.\n$(NC)"
	@printf "$(RED)⚠️  Este proceso puede tomar mucho más tiempo que un rebuild normal.\n$(NC)"
	@printf "\n"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --show-trace --verbose --option eval-cache false
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Rebuild de emergencia completado\n$(NC)"
	@printf "$(BLUE)Revisa el output arriba para diagnosticar problemas\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# === Limpieza y Optimización ===

clean: ## Clean build artifacts older than 30 days
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Limpieza Estándar (30 días)            \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando artefactos de construcción mayores a 30 días...\n$(NC)"
	@printf "$(YELLOW)Esto eliminará generaciones del sistema y paquetes no referenciados.\n$(NC)"
	@printf "$(BLUE)Se mantendrán las generaciones de los últimos 30 días para rollback.\n$(NC)"
	@printf "\n"
	sudo nix-collect-garbage --delete-older-than 30d
	nix-collect-garbage --delete-older-than 30d
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Limpieza completada (mantenidos últimos 30 días)\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
clean-week: ## Clean build artifacts older than 7 days
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Limpieza Semanal (7 días)              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando artefactos de construcción mayores a 7 días...\n$(NC)"
	@printf "$(YELLOW)⚠️  Solo podrás hacer rollback a generaciones de la última semana.\n$(NC)"
	@printf "$(BLUE)Útil cuando necesitas liberar espacio rápidamente.\n$(NC)"
	@printf "\n"
	sudo nix-collect-garbage --delete-older-than 7d
	nix-collect-garbage --delete-older-than 7d
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Limpieza completada (mantenidos últimos 7 días)\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
clean-conservative: ## Clean build artifacts older than 90 days (very safe)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Limpieza Conservadora (90 días)         \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando artefactos de construcción mayores a 90 días...\n$(NC)"
	@printf "$(GREEN)✓ Esta es la opción más segura - mantiene 90 días de historial.\n$(NC)"
	@printf "$(BLUE)Recomendado para sistemas de producción o primera limpieza.\n$(NC)"
	@printf "\n"
	sudo nix-collect-garbage --delete-older-than 90d
	nix-collect-garbage --delete-older-than 90d
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Limpieza conservadora completada (mantenidos últimos 90 días)\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
deep-clean: ## Aggressive cleanup (removes ALL old generations)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🗑️  Limpieza Profunda (IRREVERSIBLE)        \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(RED)⚠️  ADVERTENCIA CRÍTICA ⚠️\n$(NC)"
	@printf "$(RED)Este comando eliminará TODAS las generaciones antiguas del sistema.\n$(NC)"
	@printf "$(RED)Esta acción es IRREVERSIBLE y NO podrás hacer rollback.\n$(NC)"
	@printf "\n"
	@printf "$(YELLOW)¿Qué se eliminará?\n$(NC)"
	@printf "$(YELLOW)  • TODAS las generaciones del sistema (excepto la actual)\n$(NC)"
	@printf "$(YELLOW)  • TODAS las generaciones de usuario\n$(NC)"
	@printf "$(YELLOW)  • TODOS los paquetes no referenciados\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Espacio que se liberará: Máximo posible (típicamente 20-100+ GB)\n$(NC)"
	@printf "\n"
	@printf "$(RED)¿Estás ABSOLUTAMENTE seguro? Escribe 'yes' para continuar: $(NC)"; \
	read -r REPLY; \
	if [ "$$REPLY" = "yes" ]; then \
		printf "\n$(YELLOW)Ejecutando limpieza profunda...\n$(NC)\n"; \
		sudo nix-collect-garbage -d; \
		nix-collect-garbage -d; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Limpieza profunda completada\n$(NC)"; \
		printf "$(RED)⚠️  TODAS las generaciones antiguas han sido eliminadas\n$(NC)"; \
		printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(BLUE)ℹ️  Limpieza profunda cancelada\n$(NC)"; \
		printf "$(GREEN)✓ No se realizaron cambios en el sistema\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	fi
optimize: ## Optimize nix store
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🚀 Optimización del Nix Store             \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Optimizando el Nix store...\n$(NC)"
	@printf "$(YELLOW)Esto encontrará archivos idénticos y los convertirá en hardlinks.\n$(NC)"
	@printf "$(BLUE)Ahorra espacio sin eliminar nada - proceso seguro.\n$(NC)"
	@printf "$(YELLOW)⏱️  Esto puede tomar de 5 a 30 minutos dependiendo del tamaño del store.\n$(NC)"
	@printf "\n"
	sudo nix-store --optimise
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Optimización del store completada\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio ahorrado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
clean-result: ## Remove result symlinks
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Clean Result Symlinks                  \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Searching for result symlinks...$(NC)\n"
	@printf "$(YELLOW)These symlinks are created by Nix builds and can be safely removed.$(NC)\n"
	@printf "\n"
	@RESULT_LINKS=$$(find . -maxdepth 2 -name 'result*' -type l 2>/dev/null); \
	if [ -z "$$RESULT_LINKS" ]; then \
		printf "$(GREEN)✓ No result symlinks found$(NC)\n"; \
	else \
		COUNT=$$(echo "$$RESULT_LINKS" | wc -l); \
		printf "$(BLUE)Found $(YELLOW)$$COUNT$(NC) $(BLUE)result symlink(s):$(NC)\n"; \
		echo "$$RESULT_LINKS" | while read -r link; do \
			TARGET=$$(readlink -f "$$link" 2>/dev/null || echo "broken"); \
			printf "  $(YELLOW)$$link$(NC)"; \
			if [ "$$TARGET" != "broken" ]; then \
				printf " → $(GREEN)$$TARGET$(NC)\n"; \
			else \
				printf " → $(RED)(broken link)$(NC)\n"; \
			fi; \
		done; \
		printf "\n$(BLUE)Removing symlinks...$(NC)\n"; \
		find . -maxdepth 2 -name 'result*' -type l -delete 2>/dev/null; \
		printf "$(GREEN)✅ Removed $$COUNT symlink(s)$(NC)\n"; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Cleanup complete$(NC)\n"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
fix-store: ## Attempt to repair nix store
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔧 Repair Nix Store                       \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Verifying and repairing Nix store...$(NC)\n"
	@printf "$(YELLOW)⚠️  This may take a long time (minutes to hours) on large systems.$(NC)\n"
	@printf "$(YELLOW)The store will be checked for corruption and repaired if needed.$(NC)\n"
	@printf "\n"
	@if nix-store --verify --check-contents --repair; then \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Store repair complete$(NC)\n"; \
		printf "$(BLUE)All store paths verified and repaired.$(NC)\n"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(RED)✗ Store repair encountered errors$(NC)\n"; \
		printf "$(YELLOW)Check the output above for details.$(NC)\n"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
		exit 1; \
	fi

# === Actualizaciones y Flakes ===

update: ## Update flake inputs
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📦 Actualizar Inputs del Flake            \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Actualizando todos los inputs del flake...\n$(NC)"
	@printf "$(YELLOW)Esto actualizará nixpkgs, hydenix, home-manager y otros inputs.\n$(NC)"
	@printf "\n"
	nix flake update
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Inputs del flake actualizados\n$(NC)"
	@printf "$(BLUE)Usa 'make diff-update' para ver los cambios en flake.lock\n$(NC)"
	@printf "$(YELLOW)Recuerda ejecutar 'make switch' para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
update-nixpkgs: ## Update only nixpkgs input
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📦 Actualizar nixpkgs                     \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Actualizando solo el input nixpkgs...\n$(NC)"
	@printf "$(YELLOW)Esto actualizará el repositorio principal de paquetes.\n$(NC)"
	@printf "\n"
	nix flake lock --update-input nixpkgs $(FLAKE_DIR)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ nixpkgs actualizado\n$(NC)"
	@printf "$(BLUE)Usa 'make diff-update' para ver los cambios\n$(NC)"
	@printf "$(YELLOW)Recuerda ejecutar 'make switch' para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
update-hydenix: ## Update only hydenix input
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📦 Actualizar hydenix                     \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Actualizando solo el input hydenix...\n$(NC)"
	@printf "$(YELLOW)Esto actualizará el framework hydenix.\n$(NC)"
	@printf "\n"
	nix flake lock --update-input hydenix $(FLAKE_DIR)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ hydenix actualizado\n$(NC)"
	@printf "$(BLUE)Usa 'make diff-update' para ver los cambios\n$(NC)"
	@printf "$(YELLOW)Recuerda ejecutar 'make switch' para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
update-input: ## Update specific flake input (use INPUT=name)
	@if [ -z "$(INPUT)" ]; then \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(CYAN)          📦 Actualizar Input Específico            \n$(NC)"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
		printf "$(RED)✗ Error: Variable INPUT requerida$(NC)\n"; \
		printf "\n"; \
		printf "$(YELLOW)Uso: make update-input INPUT=<nombre>$(NC)\n"; \
		printf "\n"; \
		printf "$(BLUE)Inputs disponibles:$(NC)\n"; \
		printf "  - nixpkgs\n"; \
		printf "  - hydenix\n"; \
		printf "  - nixos-hardware\n"; \
		printf "  - mynixpkgs\n"; \
		printf "  - opencode\n"; \
		printf "  - zen-browser-flake\n"; \
		printf "\n"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
		exit 1; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📦 Actualizar Input Específico            \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Actualizando input: $(INPUT)\n$(NC)"
	@printf "$(YELLOW)Esto actualizará solo este input específico.\n$(NC)"
	@printf "\n"
	nix flake lock --update-input $(INPUT) $(FLAKE_DIR)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Input '$(INPUT)' actualizado\n$(NC)"
	@printf "$(BLUE)Usa 'make diff-update' para ver los cambios\n$(NC)"
	@printf "$(YELLOW)Recuerda ejecutar 'make switch' para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
diff-update: ## Show changes in flake.lock after update
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Diferencias en flake.lock              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if git diff --quiet flake.lock; then \
		printf "$(YELLOW)⚠ No hay cambios en flake.lock\n$(NC)"; \
		printf "$(BLUE)Tip: Ejecuta 'make update' primero para actualizar los inputs\n$(NC)"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "$(BLUE)Mostrando cambios en flake.lock después de la actualización...\n$(NC)"; \
		printf "\n"; \
		git diff flake.lock; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Diferencias mostradas\n$(NC)"; \
		printf "$(BLUE)Revisa los cambios antes de aplicar con 'make switch'\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	fi
upgrade: ## Update, show changes, and switch (recommended workflow)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🆙 Actualización Completa (Flujo Recomendado)\n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Ejecutando flujo recomendado de actualización:\n$(NC)"
	@printf "$(YELLOW)  1. Actualizar inputs del flake\n$(NC)"
	@printf "$(YELLOW)  2. Mostrar cambios en flake.lock\n$(NC)"
	@printf "$(YELLOW)  3. Aplicar cambios al sistema\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Paso 1/3: Actualizando inputs del flake...\n$(NC)"
	@printf "\n"
	@$(MAKE) --no-print-directory update
	@printf "\n$(BLUE)Paso 2/3: Mostrando cambios en flake.lock...\n$(NC)"
	@printf "\n"
	@$(MAKE) --no-print-directory diff-update
	@printf "\n$(BLUE)Paso 3/3: Aplicando cambios al sistema...\n$(NC)"
	@printf "$(YELLOW)Esto compilará y activará la nueva configuración.\n$(NC)"
	@printf "\n"
	@$(MAKE) --no-print-directory switch
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Actualización completa finalizada\n$(NC)"
	@printf "$(BLUE)Flujo recomendado ejecutado exitosamente:\n$(NC)"
	@printf "$(BLUE)  ✓ Inputs actualizados\n$(NC)"
	@printf "$(BLUE)  ✓ Cambios revisados\n$(NC)"
	@printf "$(BLUE)  ✓ Configuración aplicada\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

show: ## Show flake outputs
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📄 Flake Outputs Structure                \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@nix flake show $(FLAKE_DIR) 2>&1 | grep -v "^warning:" || nix flake show $(FLAKE_DIR) 2>/dev/null || true
	@printf "\n"

flake-check: ## Check flake syntax without building
	@printf "$(CYAN)📋 Checking flake syntax...\n$(NC)"
	nix flake check $(FLAKE_DIR)
diff-flake: ## Show changes to flake.nix and flake.lock
	@printf "$(CYAN)📊 Flake Changes\n$(NC)"
	@printf "===============\n"
	@git diff flake.nix flake.lock || printf "$(GREEN)No changes$(NC)\n"

# === Generaciones y Rollback ===

list-generations: ## List system generations
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📋 System Generations                    \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@TOTAL=$$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | wc -l || echo "0"); \
	CURRENT_GEN=$$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -1 | awk '{print $$1}' || echo "N/A"); \
	printf "\n$(BLUE)Total generations:$(NC) $(GREEN)$$TOTAL$(NC)\n"; \
	printf "$(BLUE)Current generation:$(NC) $(GREEN)$$CURRENT_GEN$(NC)\n"
	@printf "\n$(BLUE)All generations:$(NC)\n"
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | \
		sed 's/   (current)/   $(GREEN)(current)$(NC)/' | \
		sed 's/^/  /' || printf "  $(YELLOW)Unable to list generations$(NC)\n"
	@printf "\n"
rollback: ## Rollback to previous generation
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          ⏪ Revertir a Generación Anterior         \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(YELLOW)Revirtiendo a la generación anterior...\n$(NC)"
	@printf "$(BLUE)Esto restaurará la configuración del sistema anterior.\n$(NC)"
	@printf "\n"
	sudo nixos-rebuild switch --rollback
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Rollback completado\n$(NC)"
	@printf "$(BLUE)El sistema ha vuelto a la generación anterior.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
diff-generations: ## Compare current with previous generation
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Comparing Generations                  \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@if command -v nix >/dev/null 2>&1 && nix store diff-closures --help >/dev/null 2>&1; then \
		CURRENT=$$(readlink -f /nix/var/nix/profiles/system 2>/dev/null); \
		if [ -z "$$CURRENT" ]; then \
			printf "$(YELLOW)⚠ Could not determine current generation$(NC)\n"; \
			exit 1; \
		fi; \
		PREVIOUS_LINK=$$(ls -dt /nix/var/nix/profiles/system-*-link 2>/dev/null | tail -2 | head -1); \
		if [ -n "$$PREVIOUS_LINK" ]; then \
			PREVIOUS=$$(readlink -f "$$PREVIOUS_LINK" 2>/dev/null); \
			if [ -n "$$PREVIOUS" ] && [ "$$PREVIOUS" != "$$CURRENT" ]; then \
				printf "\n$(BLUE)Previous → Current$(NC)\n"; \
				printf "$(PURPLE)Comparing:$(NC) $$(basename $$PREVIOUS) → $$(basename $$CURRENT)\n\n"; \
				nix store diff-closures "$$PREVIOUS" "$$CURRENT" 2>/dev/null || \
				nix store diff-closures "$$PREVIOUS" "$$CURRENT"; \
			else \
				printf "\n$(YELLOW)⚠ No previous generation found or same as current$(NC)\n"; \
			fi \
		else \
			printf "\n$(YELLOW)⚠ No previous generation found$(NC)\n"; \
		fi \
	else \
		printf "\n$(YELLOW)⚠ nix store diff-closures not available$(NC)\n"; \
		printf "$(BLUE)Tip:$(NC) Use $(GREEN)make diff-gen GEN1=N GEN2=M$(NC) to compare specific generations\n"; \
	fi
	@printf "\n"
diff-gen: ## Compare two specific generations (use GEN1=N GEN2=M)
	@if [ -z "$(GEN1)" ] || [ -z "$(GEN2)" ]; then \
		printf "$(RED)Error: Specify both generations$(NC)\n"; \
		printf "$(YELLOW)Usage: make diff-gen GEN1=184 GEN2=186$(NC)\n"; \
		exit 1; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Comparing Generations                  \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@GEN1_LINK="/nix/var/nix/profiles/system-$(GEN1)-link"; \
	GEN2_LINK="/nix/var/nix/profiles/system-$(GEN2)-link"; \
	if [ ! -e "$$GEN1_LINK" ] || [ ! -e "$$GEN2_LINK" ]; then \
		printf "\n$(RED)❌ Error: One or both generations not found$(NC)\n"; \
		printf "$(BLUE)Generation $(GEN1):$(NC) $$([ -e "$$GEN1_LINK" ] && echo "$(GREEN)Found$(NC)" || echo "$(RED)Not found$(NC)")\n"; \
		printf "$(BLUE)Generation $(GEN2):$(NC) $$([ -e "$$GEN2_LINK" ] && echo "$(GREEN)Found$(NC)" || echo "$(RED)Not found$(NC)")\n"; \
		exit 1; \
	fi; \
	GEN1_PATH=$$(readlink -f "$$GEN1_LINK" 2>/dev/null); \
	GEN2_PATH=$$(readlink -f "$$GEN2_LINK" 2>/dev/null); \
	if [ -z "$$GEN1_PATH" ] || [ -z "$$GEN2_PATH" ]; then \
		printf "\n$(RED)❌ Error: Could not resolve store paths$(NC)\n"; \
		exit 1; \
	fi; \
	if [ "$$GEN1_PATH" = "$$GEN2_PATH" ]; then \
		printf "\n$(YELLOW)⚠ Generations $(GEN1) and $(GEN2) are the same$(NC)\n"; \
		exit 0; \
	fi; \
	printf "\n$(BLUE)Generation $(GEN1) → Generation $(GEN2)$(NC)\n"; \
	printf "$(PURPLE)Comparing:$(NC) $$(basename $$GEN1_PATH) → $$(basename $$GEN2_PATH)\n\n"; \
	if command -v nix >/dev/null 2>&1 && nix store diff-closures --help >/dev/null 2>&1; then \
		nix store diff-closures "$$GEN1_PATH" "$$GEN2_PATH" 2>/dev/null || \
		nix store diff-closures "$$GEN1_PATH" "$$GEN2_PATH"; \
	else \
		printf "$(YELLOW)⚠ nix store diff-closures not available$(NC)\n"; \
		printf "$(BLUE)Tip:$(NC) Requires Nix 2.4+\n"; \
	fi
	@printf "\n"

generation-sizes: ## Show disk usage per generation
	@printf "$(CYAN)💾 Generation Disk Usage\n$(NC)"
	@printf "=======================\n"
	@if ls /nix/var/nix/profiles/system-*-link >/dev/null 2>&1; then \
		du -sh /nix/var/nix/profiles/system-*-link 2>/dev/null | \
		sort -h | \
		tail -15 | \
		awk '{printf "  %s\t%s\n", $$1, $$2}'; \
		printf "\n$(BLUE)Showing last 15 generations by size$(NC)\n"; \
	else \
		printf "$(YELLOW)No generations found$(NC)\n"; \
	fi

current-generation: ## Show current generation details
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)        📍 Current Generation Details              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1 | sed 's/^/  /'
	@printf "\n$(BLUE)Activation date:$(NC) "
	@stat -c %y /run/current-system 2>/dev/null | cut -d'.' -f1 || echo "N/A"
	@printf "$(BLUE)Closure size:$(NC) "
	@nix path-info -Sh /run/current-system 2>/dev/null | awk '{print $$2}' || echo "N/A"
	@printf "\n"

# === Git y Respaldo ===

git-add: ## Stage all changes for git
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              📝 Staging Changes                   \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Adding all changes to staging area...$(NC)\n"
	@git add .
	@CHANGED=$$(git status --short | wc -l); \
	if [ $$CHANGED -gt 0 ]; then \
		printf "$(GREEN)✅ Staged $$CHANGED file(s)$(NC)\n"; \
		printf "\n$(BLUE)Changes staged:$(NC)\n"; \
		git status --short | sed 's/^/  /'; \
	else \
		printf "$(YELLOW)⚠ No changes to stage$(NC)\n"; \
	fi
	@printf "\n"
git-commit: ## Quick commit with timestamp
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Committing Changes                  \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Staging changes...$(NC)\n"
	@git add .
	@COMMIT_MSG="config: update $$(date '+%Y-%m-%d %H:%M:%S')"; \
	printf "$(BLUE)Creating commit:$(NC) $(GREEN)$$COMMIT_MSG$(NC)\n\n"; \
	git commit -m "$$COMMIT_MSG" || exit 1; \
	COMMIT_HASH=$$(git rev-parse --short HEAD); \
	BRANCH=$$(git branch --show-current); \
	printf "\n$(GREEN)✅ Commit created successfully$(NC)\n"; \
	printf "$(BLUE)Hash:$(NC) $(GREEN)$$COMMIT_HASH$(NC)\n"; \
	printf "$(BLUE)Branch:$(NC) $(GREEN)$$BRANCH$(NC)\n"
	@printf "\n"
git-push: ## Push to remote using GitHub CLI
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              🚀 Pushing to Remote                 \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@BRANCH=$$(git branch --show-current); \
	REMOTE=$$(git remote get-url origin 2>/dev/null | sed -E 's|.*github.com[:/]([^/]+/[^/]+)(\.git)?$$|\1|' | sed 's|\.git$$||'); \
	printf "\n$(BLUE)Branch:$(NC) $(GREEN)$$BRANCH$(NC)\n"; \
	printf "$(BLUE)Remote:$(NC) $(GREEN)$$REMOTE$(NC)\n\n"; \
	printf "$(BLUE)Pushing changes...$(NC)\n"
	@git push || exit 1
	@printf "\n$(GREEN)✅ Successfully pushed to remote$(NC)\n"
	@printf "\n"
git-status: ## Show git status with GitHub CLI
	@printf "$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)           📊 Repository Status                    \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(PURPLE)📍 Configuration$(NC)\n"
	@printf "├─ Host: $(HOSTNAME)\n"
	@printf "├─ Flake: $(PWD)\n"
	@printf "└─ NixOS: $$(nixos-version 2>/dev/null | cut -d' ' -f1 || echo 'N/A')\n"
	@printf "\n$(BLUE)📦 Git Status$(NC)\n"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "├─ Repository: "; \
		REMOTE_URL=$$(git remote get-url origin 2>/dev/null); \
		if [ -n "$$REMOTE_URL" ]; then \
			REPO_NAME=$$(echo "$$REMOTE_URL" | sed -E 's|.*github.com[:/]([^/]+/[^/]+)(\.git)?$$|\1|' | sed 's|\.git$$||'); \
			if [ -n "$$REPO_NAME" ]; then \
				printf "$$REPO_NAME\n"; \
			else \
				printf "$$REMOTE_URL\n"; \
			fi; \
		else \
			printf "$(YELLOW)No remote configured$(NC)\n"; \
		fi; \
		printf "├─ Branch: $$(git branch --show-current)\n"; \
		printf "├─ Status: "; \
		if git diff-index --quiet HEAD -- 2>/dev/null; then \
			printf "$(GREEN)Clean$(NC)\n"; \
		else \
			printf "$(YELLOW)Uncommitted changes$(NC)\n"; \
		fi; \
		printf "\n$(BLUE)Local changes:$(NC)\n"; \
		git status --short; \
	else \
		printf "$(YELLOW)Not a git repository$(NC)\n"; \
	fi
	@printf "\n$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Recent Changes                      \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "\n"; \
		git log --max-count=3 --pretty=format:"%h|%s|%ar%n" 2>/dev/null | \
		while IFS='|' read -r hash subject time; do \
			[ -z "$$hash" ] && continue; \
			SUBJECT_SHORT=$$(echo "$$subject" | cut -c1-55); \
			if [ "$${#subject}" -gt 55 ]; then \
				SUBJECT_SHORT="$$SUBJECT_SHORT..."; \
			fi; \
			printf "  $(GREEN)%-8s$(NC)  %-58s$(BLUE)%15s$(NC)\n" "$$hash" "$$SUBJECT_SHORT" "$$time"; \
		done; \
	fi
	@printf "\n"
save: ## Quick save: add, commit, push, and switch
	@printf "$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              💾 Quick Save Workflow                \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(PURPLE)Executing complete workflow:$(NC)\n"
	@printf "  1. Stage changes\n"
	@printf "  2. Commit changes\n"
	@printf "  3. Push to remote\n"
	@printf "  4. Build and switch\n"
	@printf "\n"
	@$(MAKE) --no-print-directory git-add
	@$(MAKE) --no-print-directory git-commit
	@$(MAKE) --no-print-directory git-push
	@$(MAKE) --no-print-directory switch
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Quick save completed successfully!$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

git-diff: ## Show uncommitted changes to .nix configuration files
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Configuration Changes                  \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@if git diff --quiet -- '*.nix' 2>/dev/null; then \
		printf "\n$(GREEN)✅ No uncommitted changes to .nix files$(NC)\n"; \
		printf "$(BLUE)All configuration files are clean.$(NC)\n"; \
	else \
		printf "\n$(BLUE)📝 Uncommitted changes in .nix files:$(NC)\n\n"; \
		CHANGED_FILES=$$(git diff --name-only -- '*.nix' 2>/dev/null | wc -l); \
		ADDED_LINES=$$(git diff --numstat -- '*.nix' 2>/dev/null | awk '{sum+=$$1} END {print sum+0}'); \
		DELETED_LINES=$$(git diff --numstat -- '*.nix' 2>/dev/null | awk '{sum+=$$2} END {print sum+0}'); \
		printf "$(PURPLE)Summary:$(NC)\n"; \
		printf "├─ $(BLUE)Files changed:$(NC) $(GREEN)$$CHANGED_FILES$(NC)\n"; \
		if [ -n "$$ADDED_LINES" ] && [ "$$ADDED_LINES" != "0" ]; then \
			printf "├─ $(BLUE)Lines added:$(NC) $(GREEN)+$$ADDED_LINES$(NC)\n"; \
		fi; \
		if [ -n "$$DELETED_LINES" ] && [ "$$DELETED_LINES" != "0" ]; then \
			printf "└─ $(BLUE)Lines deleted:$(NC) $(RED)-$$DELETED_LINES$(NC)\n"; \
		fi; \
		printf "\n$(BLUE)📋 File changes:$(NC)\n"; \
		git diff --stat --color=always -- '*.nix' 2>/dev/null || git diff --stat -- '*.nix'; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(CYAN)          📄 Detailed Diff                         \n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)\n"; \
		git diff --color=always -- '*.nix' 2>/dev/null || git diff -- '*.nix'; \
	fi
	@printf "\n"

# === Diagnóstico y Logs ===

health: ## Run comprehensive system health checks
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🏥 System Health Check                    \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)1. Flake validation:$(NC) "
	@if nix flake check . >/dev/null 2>&1; then \
		printf "$(GREEN)✓ Passed$(NC)\n"; \
	else \
		printf "$(RED)✗ Failed$(NC)\n"; \
	fi
	@printf "$(BLUE)2. Disk space (/nix):$(NC) "
	@df -h /nix 2>/dev/null | tail -1 | awk '{printf "%s used (%s free)\n", $$5, $$4}' || printf "$(YELLOW)N/A$(NC)\n"
	@printf "$(BLUE)3. Generations count:$(NC) "
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | wc -l | awk '{print $$1 " generations"}' || printf "$(YELLOW)N/A$(NC)\n"
	@printf "$(BLUE)4. Boot entries:$(NC) "
	@ls /boot/loader/entries/ 2>/dev/null | wc -l | awk '{print $$1 " entries"}' || printf "$(YELLOW)N/A$(NC)\n"
	@printf "$(BLUE)5. Failed services:$(NC) "
	@FAILED=$$(systemctl --failed --no-legend 2>/dev/null | wc -l); \
	if [ $$FAILED -eq 0 ]; then \
		printf "$(GREEN)✓ None$(NC)\n"; \
	else \
		printf "$(RED)✗ $$FAILED failed$(NC)\n"; \
		printf "$(YELLOW)  Run 'systemctl --failed' for details$(NC)\n"; \
	fi
	@printf "$(BLUE)6. Git status:$(NC) "
	@if git diff-index --quiet HEAD -- 2>/dev/null; then \
		printf "$(GREEN)✓ Clean$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠ Uncommitted changes$(NC)\n"; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Health check complete$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# --- Diagnóstico de Red ---
test-network: ## Run comprehensive network diagnostics
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🌐 Network Diagnostics                    \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)1. DNS status (resolved):$(NC)\n"
	@resolvectl status 2>/dev/null | head -60 || printf "$(YELLOW)resolvectl not available$(NC)\n"
	@printf "\n$(BLUE)2. DNS from NetworkManager:$(NC)\n"
	@nmcli device show | grep -E "IP4.DNS|GENERAL.CONNECTION" || true
	@printf "\n$(BLUE)3. Ping (1.1.1.1):$(NC)\n"
	@ping -c 5 1.1.1.1
	@printf "\n$(BLUE)4. Ping (google.com):$(NC)\n"
	@ping -c 5 google.com
	@printf "\n$(BLUE)5. Throughput (Cloudflare 50MB, max 20s):$(NC)\n"
	@curl -L -o /dev/null --max-time 20 -w "Downloaded: %{size_download} bytes, Speed: %{speed_download} B/s, Total: %{time_total}s\n" \
		"https://speed.cloudflare.com/__down?bytes=50000000"
	@printf "\n$(BLUE)6. Speedtest (nearest):$(NC)\n"
	@nix run 'nixpkgs#speedtest-cli' -- --simple 2>/dev/null || printf "$(YELLOW)speedtest-cli failed or not available$(NC)\n"
	@printf "\n$(BLUE)7. Route quality (mtr to 1.1.1.1, 50 probes):$(NC)\n"
	@mtr -rw 1.1.1.1 -c 50 || printf "$(YELLOW)mtr not available$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Network diagnostics complete$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

info: ## Show system information
	@printf "$(YELLOW)⏳ Gathering system information, please wait...\n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)           💻 System Information                    \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Hostname:$(NC)             $(GREEN)$(HOSTNAME)$(NC)\n"
	@printf "$(BLUE)NixOS Version:$(NC)        $(GREEN)$(shell nixos-version 2>/dev/null | cut -d' ' -f1 || echo 'N/A')$(NC)\n"
	@printf "$(BLUE)Flake Location:$(NC)       $(GREEN)$(PWD)$(NC)\n"
	@printf "\n$(BLUE)💾 System Info$(NC)\n"
	@printf "$(BLUE)Store Size:$(NC)           $(GREEN)$(shell du -sh /nix/store 2>/dev/null | cut -f1 || echo 'N/A')$(NC)\n"
	@CURRENT_GEN_INFO=$$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -1 | awk '{print $$1 " (" $$2 " " $$3 ")"}' || echo 'N/A'); \
	CURRENT_GEN=$$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -1 | awk '{print $$1}' || echo 'N/A'); \
	TOTAL_GENS=$$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | wc -l || echo 'N/A'); \
	DISK_USAGE=$$(df -h /nix 2>/dev/null | tail -1 | awk '{print $$5}' || echo 'N/A'); \
	printf "$(BLUE)Current Generation:$(NC)   $(GREEN)%s$(NC)\n" "$$CURRENT_GEN_INFO"; \
	printf "$(BLUE)Total Generations:$(NC)    $(GREEN)%s$(NC)\n" "$$TOTAL_GENS"; \
	printf "$(BLUE)Disk Usage (/nix):$(NC)    $(GREEN)%s$(NC)\n" "$$DISK_USAGE"
	@printf "\n$(BLUE)🔄 Recent Generations$(NC)\n"
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -5 | sed 's/^/  /' || printf "  $(YELLOW)None$(NC)\n"
	@printf "\n$(BLUE)📦 Flake Inputs Versions$(NC)\n"
	@nix flake metadata --json 2>/dev/null | \
		grep -o '"lastModified":[0-9]*' | \
		head -5 | sed 's/"lastModified"://' | sed 's/^/  /' || printf "  $(YELLOW)Unable to read$(NC)\n"
	@printf "\n"
status: git-status ## Show comprehensive system status (alias for git-status)

watch-logs: ## Watch system logs in real-time (follow mode)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Watching System Logs                   \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Press $(GREEN)Ctrl+C$(BLUE) to exit$(NC)\n\n"
	@journalctl -f
logs-boot: ## Show boot logs
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📋 Boot Logs                              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Showing errors and alerts from current boot...$(NC)\n\n"
	@journalctl -b -p err..alert --no-pager | tail -50 || true
	@printf "\n"
logs-errors: ## Show recent error logs
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📋 Recent Error Logs                      \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@ERROR_COUNT=$$(journalctl -p err -n 50 --no-pager 2>/dev/null | wc -l || echo "0"); \
	printf "\n$(BLUE)Showing last 50 error-level messages$(NC)\n"; \
	if [ "$$ERROR_COUNT" -eq 0 ]; then \
		printf "$(GREEN)✅ No recent errors found$(NC)\n"; \
	else \
		printf "$(PURPLE)Found:$(NC) $(GREEN)$$ERROR_COUNT$(NC) error message(s)\n"; \
	fi
	@printf "\n"
	@journalctl -p err -n 50 --no-pager || true
	@printf "\n"
logs-service: ## Show logs for specific service (use SVC=name)
	@if [ -z "$(SVC)" ]; then \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(CYAN)          📋 Service Logs                           \n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n$(RED)❌ Error: SVC variable required$(NC)\n\n"; \
		printf "$(BLUE)Usage:$(NC) make logs-service SVC=<service-name>\n\n"; \
		printf "$(BLUE)Examples:$(NC)\n"; \
		printf "  make logs-service SVC=sshd\n"; \
		printf "  make logs-service SVC=networkmanager\n"; \
		printf "  make logs-service SVC=docker\n\n"; \
		printf "$(BLUE)Common services:$(NC)\n"; \
		if command -v systemctl >/dev/null 2>&1; then \
			systemctl list-units --type=service --state=running --no-pager --no-legend 2>/dev/null | \
			awk '{print "  " $$1}' | head -10 || true; \
		fi; \
		printf "\n$(BLUE)Tip:$(NC) Use $(GREEN)systemctl list-units --type=service$(NC) to see all services\n"; \
		printf "\n"; \
		exit 1; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📋 Service Logs                           \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Service:$(NC) $(GREEN)$(SVC)$(NC)\n"
	@HAS_RECENT=$$(journalctl -u $(SVC) --since "1 hour ago" --no-pager 2>/dev/null | grep -v "^-- No entries --" | grep -q . && echo "yes" || echo "no"); \
	if [ "$$HAS_RECENT" = "yes" ]; then \
		LOG_COUNT=$$(journalctl -u $(SVC) --since "1 hour ago" --no-pager 2>/dev/null | grep -v "^-- No entries --" | wc -l || echo "0"); \
		printf "$(BLUE)Showing logs from last hour ($(GREEN)$$LOG_COUNT$(NC) entries)...$(NC)\n\n"; \
		journalctl -u $(SVC) --since "1 hour ago" -n 100 --no-pager 2>/dev/null | grep -v "^-- No entries --" || true; \
	elif journalctl -u $(SVC) --since today --no-pager 2>/dev/null | grep -v "^-- No entries --" | grep -q . 2>/dev/null; then \
		printf "$(BLUE)No recent logs (last hour), showing logs from today...$(NC)\n\n"; \
		journalctl -u $(SVC) --since today -n 100 --no-pager 2>/dev/null | grep -v "^-- No entries --" || true; \
	else \
		printf "$(BLUE)No logs from today, showing last 100 entries...$(NC)\n\n"; \
		if journalctl -u $(SVC) -n 100 --no-pager 2>/dev/null | grep -q .; then \
			journalctl -u $(SVC) -n 100 --no-pager 2>/dev/null || true; \
		else \
			printf "$(YELLOW)⚠ Service '$(SVC)' not found or no logs available$(NC)\n"; \
		fi \
	fi
	@printf "\n"

# === Análisis y Desarrollo ===

list-hosts: ## List available host configurations
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📋 Available Hosts                         \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@TOTAL=0; CONFIGURED=0; \
	for host in $(AVAILABLE_HOSTS); do \
		TOTAL=$$((TOTAL + 1)); \
		if [ -d "hosts/$$host" ] && [ -f "hosts/$$host/configuration.nix" ]; then \
			CONFIGURED=$$((CONFIGURED + 1)); \
		fi; \
	done; \
	printf "\n$(BLUE)Total hosts:$(NC) $(GREEN)$$TOTAL$(NC)\n"; \
	printf "$(BLUE)Configured:$(NC) $(GREEN)$$CONFIGURED$(NC)\n"
	@printf "\n$(BLUE)Hosts overview:$(NC)\n"
	@for host in $(AVAILABLE_HOSTS); do \
		printf "  $(GREEN)%-15s$(NC) " $$host; \
		if [ -d "hosts/$$host" ] && [ -f "hosts/$$host/configuration.nix" ]; then \
			printf "$(GREEN)✓$(NC) configured"; \
			if [ "$$host" = "$(HOSTNAME)" ]; then \
				printf " $(YELLOW)(current)$(NC)"; \
			fi; \
			printf "\n"; \
		else \
			printf "$(RED)✗$(NC) not found\n"; \
		fi; \
	done
	@printf "\n$(BLUE)Detailed information:$(NC)\n"
	@for host in $(AVAILABLE_HOSTS); do \
		printf "\n  $(GREEN)$${host}$(NC)"; \
		if [ "$$host" = "$(HOSTNAME)" ]; then \
			printf " $(YELLOW)(current)$(NC)"; \
		fi; \
		printf "\n"; \
		if [ -f "hosts/$$host/configuration.nix" ]; then \
			printf "    Status: $(GREEN)✓$(NC) configured\n"; \
			printf "    Path: $(BLUE)hosts/$$host/$(NC)\n"; \
			FILE_COUNT=$$(ls hosts/$$host/ 2>/dev/null | wc -l); \
			printf "    Files: $(GREEN)$$FILE_COUNT$(NC)\n"; \
		else \
			printf "    Status: $(RED)✗$(NC) not found\n"; \
		fi; \
	done
	@printf "\n$(BLUE)Usage:$(NC) make switch HOSTNAME=<host>\n"
	@printf "$(BLUE)Example:$(NC) make switch HOSTNAME=laptop\n"
	@printf "\n"

hosts-info: list-hosts ## Show info about all configured hosts (alias for list-hosts)

search: ## Search for packages in nixpkgs (use PKG=name)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)Error: PKG variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make search PKG=firefox$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)🔍 Searching for: $(PKG)\n$(NC)"
	@printf "================================\n"
	@nix search nixpkgs $(PKG)
search-installed: ## Search in currently installed packages (use PKG=name)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)Error: PKG variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make search-installed PKG=firefox$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)🔍 Searching installed packages for: $(PKG)\n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)1. Executable in PATH:$(NC)\n"
	@if command -v $(PKG) >/dev/null 2>&1; then \
		EXEC_PATH=$$(command -v $(PKG)); \
		printf "  $(GREEN)✓ Found:$(NC) $$EXEC_PATH\n"; \
		PKG_STORE_PATH=$$(readlink -f $$EXEC_PATH 2>/dev/null | sed 's|/bin/.*||' | head -1); \
		if [ -n "$$PKG_STORE_PATH" ]; then \
			printf "  $(BLUE)Store path:$(NC) $$PKG_STORE_PATH\n"; \
		fi; \
	else \
		printf "  $(YELLOW)Not found in PATH$(NC)\n"; \
	fi
	@printf "\n$(BLUE)2. User environment (nix-env):$(NC)\n"
	@USER_PKGS=$$(nix-env -q 2>/dev/null | grep -i "$(PKG)" || true); \
	if [ -n "$$USER_PKGS" ]; then \
		echo "$$USER_PKGS" | sed 's/^/  /'; \
	else \
		printf "  $(YELLOW)Not found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)3. System packages (current-system):$(NC)\n"
	@SYSTEM_PKGS=$$(nix-store -q --references /run/current-system 2>/dev/null | grep -i "$(PKG)" | head -10 || true); \
	if [ -n "$$SYSTEM_PKGS" ]; then \
		echo "$$SYSTEM_PKGS" | sed 's/^/  /'; \
	else \
		printf "  $(YELLOW)Not found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)4. Home Manager profiles:$(NC)\n"
	@if [ -d "/etc/profiles/per-user" ]; then \
		HM_PKGS=$$(find /etc/profiles/per-user -name "$(PKG)" -type f 2>/dev/null | head -5 || true); \
		if [ -n "$$HM_PKGS" ]; then \
			echo "$$HM_PKGS" | sed 's/^/  /'; \
		else \
			printf "  $(YELLOW)Not found$(NC)\n"; \
		fi; \
	else \
		printf "  $(YELLOW)Home Manager profiles not found$(NC)\n"; \
	fi
	@printf "\n"

repl: ## Start nix repl with flake
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧠 Nix REPL - Interactive Shell           \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Starting Nix REPL with flake loaded...$(NC)\n"
	@printf "$(YELLOW)Useful commands:$(NC)\n"
	@printf "  $(GREEN):q$(NC) or $(GREEN):quit$(NC) - Exit REPL\n"
	@printf "  $(GREEN)outputs$(NC) - View flake outputs\n"
	@printf "  $(GREEN)outputs.nixosConfigurations.hydenix$(NC) - View configuration\n"
	@printf "\n"
	@nix repl --extra-experimental-features repl-flake $(FLAKE_DIR)
shell: ## Enter development shell
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🐚 Development Shell                      \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if nix flake show $(FLAKE_DIR) 2>/dev/null | grep -q "devShells"; then \
		printf "$(BLUE)Entering development shell...$(NC)\n"; \
		printf "$(YELLOW)This shell includes development tools from your flake.$(NC)\n"; \
		printf "\n"; \
		nix develop $(FLAKE_DIR); \
	else \
		printf "$(YELLOW)⚠️  No devShells configured in flake$(NC)\n"; \
		printf "$(BLUE)To use this command, add devShells to your flake.nix:$(NC)\n"; \
		printf "\n"; \
		printf "$(CYAN)devShells.x86_64-linux.default = pkgs.mkShell {$(NC)\n"; \
		printf "$(CYAN)  buildInputs = [ /* your tools */ ];$(NC)\n"; \
		printf "$(CYAN)};$(NC)\n"; \
		printf "\n"; \
		printf "$(YELLOW)For now, using basic nix-shell...$(NC)\n"; \
		printf "\n"; \
		nix develop $(FLAKE_DIR) || nix-shell; \
	fi
vm: ## Build and run VM
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🖥️  NixOS Virtual Machine               \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Building VM from current configuration...$(NC)\n"
	@printf "$(YELLOW)This may take a few minutes on first build.$(NC)\n"
	@printf "\n"
	@if nix build '.#vm' 2>&1; then \
		printf "\n$(GREEN)✅ VM built successfully$(NC)\n"; \
		if [ -f "./result/bin/run-hydenix-vm" ]; then \
			VM_SCRIPT="./result/bin/run-hydenix-vm"; \
		elif [ -f "./result/bin/run-nixos-vm" ]; then \
			VM_SCRIPT="./result/bin/run-nixos-vm"; \
		else \
			VM_SCRIPT=$$(find ./result -name "run-*-vm" -type f -executable | head -1); \
			if [ -z "$$VM_SCRIPT" ]; then \
				printf "$(RED)✗ VM script not found$(NC)\n"; \
				printf "$(YELLOW)Checking result directory...$(NC)\n"; \
				ls -la ./result/bin/ 2>/dev/null || find ./result -type f -executable 2>/dev/null | head -5; \
				printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
				printf "\n"; \
				exit 1; \
			fi; \
		fi; \
		printf "$(BLUE)Starting VM...$(NC)\n"; \
		printf "$(YELLOW)Press Ctrl+Alt+G to release mouse/keyboard$(NC)\n"; \
		printf "$(YELLOW)Use 'systemctl poweroff' in VM to shutdown$(NC)\n"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)\n"; \
		$$VM_SCRIPT; \
	else \
		printf "\n$(RED)✗ VM build failed$(NC)\n"; \
		printf "$(YELLOW)Check the error messages above for details.$(NC)\n"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
		exit 1; \
	fi

closure-size: ## Show closure size of current system
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 System Closure Size Analysis          \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Total system closure size:$(NC)\n"
	@SYSTEM_INFO=$$(nix path-info -Sh /run/current-system | head -1); \
	SYSTEM_SIZE=$$(echo "$$SYSTEM_INFO" | awk '{print $$2 " " $$3}'); \
	SYSTEM_PATH=$$(echo "$$SYSTEM_INFO" | awk '{print $$1}'); \
	printf "  $(GREEN)$$SYSTEM_SIZE$(NC)\n"; \
	printf "  $(YELLOW)$$SYSTEM_PATH$(NC)\n"
	@printf "\n$(BLUE)Top 10 largest packages:$(NC)\n"
	@nix path-info -rSh /run/current-system | \
		sort -k2 -h | \
		tail -10 | \
		awk -v GREEN="$(GREEN)" -v YELLOW="$(YELLOW)" -v NC="$(NC)" '{printf "  %s%8s%s  %s%s%s\n", GREEN, $$2, NC, YELLOW, $$1, NC}'
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Analysis complete$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# === Formato, Linting y Estructura ===

format: ## Format nix files
	@printf "$(CYAN)💅 Formatting nix files...\n$(NC)"
	@if command -v nixpkgs-fmt >/dev/null 2>&1; then \
		find . -name "*.nix" -not -path "*/.*" -exec nixpkgs-fmt {} \; ; \
		printf "$(GREEN)✅ Formatting complete\n$(NC)"; \
	elif command -v alejandra >/dev/null 2>&1; then \
		alejandra . ; \
		printf "$(GREEN)✅ Formatting complete (alejandra)\n$(NC)"; \
	else \
		printf "$(YELLOW)⚠️  No formatter found\n$(NC)"; \
		printf "$(BLUE)Install with: nix-shell -p nixpkgs-fmt\n$(NC)"; \
		printf "$(BLUE)Or use: nix fmt (if configured)\n$(NC)"; \
		exit 1; \
	fi
lint: ## Lint nix files (requires statix)
	@printf "$(CYAN)🔍 Linting nix files...\n$(NC)"
	@if command -v statix >/dev/null 2>&1; then \
		statix check . ; \
		if [ $$? -eq 0 ]; then \
			printf "$(GREEN)✅ Linting complete - no issues found\n$(NC)"; \
		else \
			printf "$(YELLOW)⚠️  Linting found issues (see above)\n$(NC)"; \
		fi \
	else \
		printf "$(YELLOW)⚠️  statix not found\n$(NC)"; \
		printf "$(BLUE)Install with: nix-shell -p statix\n$(NC)"; \
		printf "$(BLUE)Or run directly: nix run nixpkgs#statix check .\n$(NC)"; \
		exit 1; \
	fi

tree: ## Show configuration structure
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📁 Configuration Structure                 \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if command -v eza >/dev/null 2>&1; then \
		eza --tree --level=3 --icons --git-ignore --ignore-glob='result|*.tar.gz|node_modules' hosts/ modules/ resources/ 2>/dev/null || \
		eza --tree --level=3 --icons --git-ignore hosts/ modules/ resources/ 2>/dev/null || true; \
	elif command -v tree >/dev/null 2>&1; then \
		tree -L 3 -I '.git|result|*.tar.gz|node_modules' --dirsfirst hosts/ modules/ resources/ 2>/dev/null || true; \
	else \
		printf "$(YELLOW)⚠ Install 'eza' or 'tree' for better output$(NC)\n"; \
		find . -type d -not -path '*/\.*' -not -path '*/result*' -not -path '*/node_modules*' | \
			grep -E '^(\./)?(hosts|modules|resources)' | \
			head -50 | \
			sed 's|[^/]*/| |g'; \
	fi
	@printf "\n"
diff-config: git-diff ## Alias for git-diff (deprecated, use git-diff)

# === Reportes y Exportación ===

git-log: ## Show recent changes from git log
	@printf "$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Recent Changes                      \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "\n"; \
		git log --max-count=15 --pretty=format:"%h|%s|%ar" 2>/dev/null | \
		while IFS='|' read -r hash subject time; do \
			SUBJECT_SHORT=$$(echo "$$subject" | cut -c1-55); \
			if [ "$${#subject}" -gt 55 ]; then \
				SUBJECT_SHORT="$$SUBJECT_SHORT..."; \
			fi; \
			printf "  $(GREEN)%-8s$(NC)  %-58s$(BLUE)%15s$(NC)\n" "$$hash" "$$SUBJECT_SHORT" "$$time"; \
		done; \
	else \
		printf "\n$(YELLOW)Not a git repository$(NC)\n"; \
	fi
	@printf "\n"

# === Plantillas y Otros ===

hardware-scan: ## Re-scan hardware configuration
	@printf "$(BLUE)🔧 Scanning hardware configuration for $(HOSTNAME)...\n$(NC)"
	@sudo nixos-generate-config --show-hardware-config > hosts/$(HOSTNAME)/hardware-configuration-new.nix
	@printf "$(YELLOW)New hardware config saved as:\n$(NC)"
	@printf "  hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To review differences:\n$(NC)"
	@printf "  diff hosts/$(HOSTNAME)/hardware-configuration.nix hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To apply:\n$(NC)"
	@printf "  mv hosts/$(HOSTNAME)/hardware-configuration-new.nix hosts/$(HOSTNAME)/hardware-configuration.nix\n"

fix-permissions: ## Fix common permission issues
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔧 Fix Permissions                        \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Fixing common permission issues...$(NC)\n"
	@printf "$(YELLOW)This requires sudo privileges.$(NC)\n"
	@printf "\n"
	@printf "$(BLUE)1. Fixing ~/.config permissions...$(NC) "
	@if sudo chown -R $$USER:users ~/.config 2>/dev/null; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠️  (skipped)$(NC)\n"; \
	fi
	@printf "$(BLUE)2. Fixing ~/.local permissions...$(NC) "
	@if sudo chown -R $$USER:users ~/.local 2>/dev/null; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠️  (skipped)$(NC)\n"; \
	fi
	@printf "$(BLUE)3. Fixing git repository permissions...$(NC)\n"
	@$(MAKE) --no-print-directory fix-git-permissions
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Permissions fixed$(NC)\n"
	@printf "$(BLUE)Common permission issues have been resolved.$(NC)\n"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
fix-git-permissions: ## Fix git repo ownership issues in flake dir
	@if [ -d "$(FLAKE_DIR)/.git/objects" ]; then \
		if find "$(FLAKE_DIR)/.git/objects" -maxdepth 2 -type d -not -user $$USER 2>/dev/null | grep -q .; then \
			printf "  $(YELLOW)Fixing ownership in $(FLAKE_DIR)/.git...$(NC) "; \
			if sudo chown -R $$USER:users "$(FLAKE_DIR)/.git" 2>/dev/null; then \
				printf "$(GREEN)✓$(NC)\n"; \
			else \
				printf "$(RED)✗$(NC)\n"; \
			fi; \
		else \
			printf "  $(GREEN)✓ Git permissions OK$(NC)\n"; \
		fi; \
	else \
		printf "  $(YELLOW)⚠️  No git repository found at $(FLAKE_DIR)$(NC)\n"; \
	fi
