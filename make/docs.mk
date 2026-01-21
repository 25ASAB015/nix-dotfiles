# ============================================================================
# Ayuda y Documentación
# ============================================================================
# Descripción: Targets para mostrar ayuda, ejemplos y documentación
# Targets: 7 targets
# ============================================================================

.PHONY: help help-examples docs-local doc-dev doc-build doc-install doc-clean

# === Ayuda y Documentación ===

# Main help target - shows all available commands organized by category
# Uses AWK to parse inline comments (##) and display them in a formatted menu
help: ## Show this help message
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)      Ayuda Avanzada y Workflows (Makefile)        $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
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
		print_cat("Ayuda y Documentación", "help help-examples help-aliases docs-local doc-dev doc-build doc-install doc-clean"); \
		print_cat("Gestión del Sistema (Rebuild/Switch)", "sys-apply sys-apply-safe sys-apply-fast sys-test sys-build sys-dry-run sys-boot sys-check sys-debug sys-force sys-doctor sys-fix-git sys-hw-scan sys-deploy"); \
		print_cat("Limpieza y Optimización", "sys-gc sys-purge sys-optimize sys-clean-result sys-fix-store"); \
		print_cat("Actualizaciones y Flakes", "upd-all upd-nixpkgs upd-hydenix upd-input upd-diff upd-upgrade upd-show upd-check"); \
		print_cat("Generaciones y Rollback", "gen-list gen-rollback gen-diff gen-diff-current gen-sizes gen-current"); \
		print_cat("Git y Respaldo", "git-add git-commit git-push git-status git-diff git-log"); \
		print_cat("Diagnóstico y Logs", "sys-status log-net log-watch log-boot log-err log-svc"); \
		print_cat("Análisis y Desarrollo", "dev-hosts dev-search dev-search-inst dev-repl dev-shell dev-vm dev-size"); \
		print_cat("Formato, Linting y Estructura", "fmt-check fmt-lint fmt-tree fmt-diff"); \
		printf "\nWorkflows sugeridos:\n"; \
		printf "  • Flujo Pro:          make fmt-check → make sys-check → make sys-apply\n"; \
		printf "  • Updates seguros:    make upd-all → make upd-diff → make sys-check → make sys-apply\n"; \
		printf "  • Mantenimiento:      make sys-status → make sys-gc → make sys-optimize\n"; \
		printf "  • Recuperación:       make gen-list → make gen-rollback\n"; \
		printf "\nAyuda rápida: make help | make help-examples | make help-aliases | less README.md\n\n"; \
	}' $(MAKEFILE_LIST)

# Show detailed usage examples for commands that require parameters
# Organized by category with practical examples
help-examples: ## Show commands with usage examples
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)        NixOS Commands with Usage Examples         $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(PURPLE)💡 Tip: Commands without parameters can be run directly$(NC)\n"
	@printf "$(PURPLE)   Commands with parameters are shown with examples below$(NC)\n\n"
	@printf "$(GREEN)═══ 🔨 Build & Deploy ═══$(NC)\n"
	@printf "$(BLUE)sys-apply HOSTNAME=<host>$(NC)\n"
	@printf "  → make sys-apply HOSTNAME=laptop\n\n"
	@printf "$(BLUE)sys-deploy$(NC)\n"
	@printf "  → make sys-deploy\n\n"
	@printf "$(GREEN)═══ 🔍 Search & Discovery ═══$(NC)\n"
	@printf "$(BLUE)dev-search PKG=<name>$(NC)\n"
	@printf "  → make dev-search PKG=firefox\n"
	@printf "  → make dev-search PKG=neovim\n\n"
	@printf "$(BLUE)dev-search-inst PKG=<name>$(NC)\n"
	@printf "  → make dev-search-inst PKG=kitty\n"
	@printf "  → make dev-search-inst PKG=docker\n\n"
	@printf "$(GREEN)═══ 📦 Updates ═══$(NC)\n"
	@printf "$(BLUE)upd-input INPUT=<name>$(NC)\n"
	@printf "  → make upd-input INPUT=hydenix\n"
	@printf "  → make upd-input INPUT=nixpkgs\n"
	@printf "  → make upd-input INPUT=zen-browser-flake\n\n"
	@printf "$(GREEN)═══ 💾 Generations ═══$(NC)\n"
	@printf "$(BLUE)gen-diff GEN1=<n> GEN2=<m>$(NC)\n"
	@printf "  → make gen-diff GEN1=184 GEN2=186\n\n"
	@printf "$(GREEN)═══ 📋 Logs & Monitoring ═══$(NC)\n"
	@printf "$(BLUE)log-svc SVC=<service>$(NC)\n"
	@printf "  → make log-svc SVC=sshd\n"
	@printf "  → make log-svc SVC=docker\n"
	@printf "  → make log-svc SVC=networkmanager\n\n"
	@printf "$(GREEN)═══ 📚 Common Commands (No parameters needed) ═══$(NC)\n"
	@printf "$(BLUE)Everyday use:$(NC)\n"
	@printf "  make sys-deploy     → Total sync (add + commit + push + apply)\n"
	@printf "  make sys-apply      → Apply configuration\n"
	@printf "  make sys-apply-fast → Fast switch (skip checks)\n"
	@printf "  make sys-test       → Test without applying\n"
	@printf "  make gen-rollback   → Undo last change\n"
	@printf "  make sys-check      → Check config before applying\n\n"
	@printf "$(BLUE)Information:$(NC)\n"
	@printf "  make sys-status     → System overview (Dashboard + Report)\n"
	@printf "  make dev-hosts      → Show available hosts\n"
	@printf "  make git-log        → Recent changes\n\n"
	@printf "$(BLUE)Maintenance:$(NC)\n"
	@printf "  make sys-gc         → Clean old (30 days)\n"
	@printf "  make sys-optimize   → Optimize store\n"
	@printf "  make gen-sizes      → Show generation sizes\n"
	@printf "  make dev-size       → Show what uses space\n\n"
	@printf "$(BLUE)Troubleshooting:$(NC)\n"
	@printf "  make sys-debug      → Debug rebuild\n"
	@printf "  make log-err        → Show errors\n"
	@printf "  make sys-doctor     → Fix permission issues\n"
	@printf "  make sys-fix-store  → Repair nix store\n\n"
	@printf "$(YELLOW)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n"
	@printf "$(YELLOW)For full command list:$(NC) make help\n"
	@printf "$(YELLOW)For workflows:$(NC) make help\n"
	@printf "$(YELLOW)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n\n"

# List all available documentation files in the project
# Scans for README, tutorials, and docs/ directory
docs-local: ## Show local documentation files
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📚 Local Documentation                   $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if [ -f "README.md" ]; then printf "  $(GREEN)✓$(NC) $(BLUE)README.md$(NC)\n"; fi
	@if [ -d "docs/" ]; then printf "  $(GREEN)✓$(NC) $(BLUE)docs/$(NC)\n"; fi
	@find docs/src/content/docs/makefile/ -name "*.mdx" | sed 's|^|    • |' || true
	@printf "\n"

# Start Astro documentation development server
# Automatically installs dependencies if needed
doc-dev: ## Run documentation dev server
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)        Iniciando servidor de desarrollo...        $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(BLUE)Iniciando servidor de desarrollo de docs...$(NC)\n"
	@cd docs && npm run dev

# Build static documentation site
doc-build: ## Build documentation site
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)        Construyendo documentación estática...     $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(BLUE)Construyendo documentación estática...$(NC)\n"
	@cd docs && npm run build

# Install documentation dependencies
# Run this before using docs-dev or docs-build
doc-install: ## Install documentation dependencies
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)        Instalando dependencias de docs...         $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(BLUE)Instalando dependencias de docs...$(NC)\n"
	@cd docs && npm install

# Clean documentation build artifacts
doc-clean: ## Clean documentation artifacts
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)        Limpiando artefactos de docs...            $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(BLUE)Limpiando artefactos de docs...$(NC)\n"
	@rm -rf docs/dist docs/node_modules
