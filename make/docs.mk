# ============================================================================
# Ayuda y Documentación
# ============================================================================
# Descripción: Targets para mostrar ayuda, ejemplos y documentación
# Targets: 7 targets
# ============================================================================

.PHONY: help help-examples docs-local docs-dev docs-build docs-install docs-clean

# === Ayuda y Documentación ===

# Main help target - shows all available commands organized by category
# Uses AWK to parse inline comments (##) and display them in a formatted menu
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
		print_cat("Gestión del Sistema (Rebuild/Switch)", "switch safe-switch switch-fast test build dry-run boot validate debug emergency fix-permissions fix-git-permissions hardware-scan"); \
		print_cat("Limpieza y Optimización", "clean clean-week clean-conservative deep-clean optimize clean-result fix-store"); \
		print_cat("Actualizaciones y Flakes", "update update-nixpkgs update-hydenix update-input flake-diff upgrade show flake-check"); \
		print_cat("Generaciones y Rollback", "list-generations rollback diff-generations diff-gen generation-sizes current-generation"); \
		print_cat("Git y Respaldo", "git-add git-commit git-push git-status git-diff sync git-log"); \
		print_cat("Diagnóstico y Logs", "health test-network info status watch-logs logs-boot logs-errors logs-service"); \
		print_cat("Análisis y Desarrollo", "list-hosts search search-installed repl shell vm closure-size"); \
		print_cat("Formato, Linting y Estructura", "format lint tree"); \
		printf "\nWorkflows sugeridos:\n"; \
		printf "  • Desarrollo diario:  make test → make switch → make rollback\n"; \
		printf "  • Updates seguros:    make update → make diff-update → make validate → make test → make switch\n"; \
		printf "  • Mantenimiento:      make health → make clean → make optimize → make generation-sizes\n"; \
		printf "  • Multi-host:         make list-hosts → make switch HOSTNAME=laptop\n"; \
		printf "\nAyuda rápida: make help | make help-examples | less MAKEFILE_TUTORIAL.md\n\n"; \
	}' $(MAKEFILE_LIST)

# Show detailed usage examples for commands that require parameters
# Organized by category with practical examples
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
	@printf "  make sync           → Total sync (commit + push + switch)\n"
	@printf "  make switch         → Apply configuration\n"
	@printf "  make switch-fast    → Fast switch (skip checks)\n"
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

# List all available documentation files in the project
# Scans for README, tutorials, and docs/ directory
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

# Start Astro documentation development server
# Automatically installs dependencies if needed
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

# Build documentation for production deployment
# Creates optimized static files in docs/dist/
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

# Remove node_modules to free up disk space
# Run this if you need to clean up documentation dependencies
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

# Install or update npm dependencies for documentation
# Run this before using docs-dev or docs-build
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
