# ============================================================================
# Formato, Linting y Estructura
# ============================================================================
# Descripción: Targets para formateo, linting y visualización de estructura
# Targets: 4 targets
# ============================================================================

.PHONY: fmt-check fmt-lint fmt-tree fmt-diff

# === Formateo y Estructura ===

# Format all Nix files using nixpkgs-fmt or alejandra
fmt-check: ## Format all nix files
	@printf "$(BLUE)Formateando archivos Nix...\n$(NC)"
	@if command -v alejandra >/dev/null 2>&1; then \
		alejandra .; \
	elif command -v nixpkgs-fmt >/dev/null 2>&1; then \
		nixpkgs-fmt .; \
	else \
		printf "$(YELLOW)⚠ No se encontró formateador (alejandra o nixpkgs-fmt)$(NC)\n"; \
	fi

# Lint Nix files for common issues using statix
fmt-lint: ## Check nix files for common issues
	@printf "$(BLUE)Analizando archivos Nix con statix...\n$(NC)"
	@if command -v statix >/dev/null 2>&1; then \
		statix check .; \
	else \
		printf "$(YELLOW)⚠ No se encontró statix para linting$(NC)\n"; \
	fi

# Show project structure tree
fmt-tree: ## Show project structure tree
	@printf "$(BLUE)Estructura del proyecto:\n$(NC)"
	@if command -v tree >/dev/null 2>&1; then \
		tree -L 2 -I "result*|node_modules|.git"; \
	else \
		find . -maxdepth 2 -not -path '*/.*' -not -path './result*' -not -path './docs/node_modules*'; \
	fi

# Show diff between local and system config
fmt-diff: ## Show diff between local and system config
	@printf "$(BLUE)Diferencia con la configuración actual del sistema:\n$(NC)"
	@if [ -d "/etc/nixos" ]; then \
		diff -r . /etc/nixos --exclude=".git" --exclude="result*" || true; \
	else \
		printf "$(RED)✗ /etc/nixos no encontrado$(NC)\n"; \
	fi
