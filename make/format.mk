# ============================================================================
# Formato, Linting y Estructura
# ============================================================================
# Descripción: Targets para formateo, linting y visualización de estructura
# Targets: 4 targets
# ============================================================================

.PHONY: format lint tree diff-config

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
			grep -E '^(\./)?( hosts|modules|resources)' | \
			head -50 | \
			sed 's|[^/]*/| |g'; \
	fi
	@printf "\n"
diff-config: git-diff ## Alias for git-diff (deprecated, use git-diff)
