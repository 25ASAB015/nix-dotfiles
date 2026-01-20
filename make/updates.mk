# ============================================================================
# Actualizaciones y Flakes
# ============================================================================
# Descripción: Targets para actualizar inputs del flake y gestionar versiones
# Targets: 7 targets
# ============================================================================

.PHONY: upd-all upd-nixpkgs upd-hydenix upd-input upd-diff upd-upgrade upd-show upd-check

# === Actualización de Flake ===

# Update all flake inputs to their latest versions
upd-all: ## Update all flake inputs
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔄 Actualizando Flake Inputs               \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Actualizando todos los inputs del flake...$(NC)\n"
	nix flake update

upd-nixpkgs: ## Update only nixpkgs input
	nix flake lock --update-input nixpkgs $(FLAKE_DIR)

upd-hydenix: ## Update only hydenix input
	nix flake lock --update-input hydenix $(FLAKE_DIR)

# Allows targeted updates of individual flake dependencies
upd-input: ## Update a specific input (use INPUT=name)
	@if [ -z "$(INPUT)" ]; then \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(CYAN)          📦 Actualizar Input Específico            \n$(NC)"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
		printf "$(RED)✗ Error: Variable INPUT requerida$(NC)\n"; \
		printf "\n"; \
		printf "$(YELLOW)Uso: make upd-input INPUT=<nombre>$(NC)\n"; \
		printf "\n"; \
		printf "$(BLUE)Inputs conocidos:$(NC) nixpkgs, hydenix, nixos-hardware, zen-browser-flake\n"; \
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
	@printf "$(BLUE)Usa 'make upd-diff' para ver los cambios\n$(NC)"
	@printf "$(YELLOW)Recuerda ejecutar 'make sys-apply' para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Show intelligent diff showing what inputs changed in flake.lock
upd-diff: ## Show versions differences in flake.lock
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Flake Changes Analysis                 \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@HAS_LOCK_CHANGES=$(git diff --quiet flake.lock && echo "no" || echo "yes"); \
	if [ "$HAS_LOCK_CHANGES" = "no" ]; then \
		printf "$(GREEN)✓ No uncommitted changes in flake.lock$(NC)\n"; \
		printf "$(BLUE)Tip: Run 'make upd-all' to update flake inputs$(NC)\n"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "$(YELLOW)🔒 Changes in flake.lock (updated inputs):$(NC)\n"; \
		printf "$(CYAN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n$(NC)"; \
		git diff flake.lock; \
		printf "\n"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Changes displayed$(NC)\n"; \
		printf "$(BLUE)Review changes before applying with 'make sys-apply'$(NC)\n"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	fi

# Complete upgrade workflow: update inputs and apply safely
upd-upgrade: ## Update all and apply configuration (safe)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🆙 Actualización Completa (Safe Upgrade)   \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Ejecutando flujo seguro de actualización:\n$(NC)"
	@printf "$(YELLOW)  1. Actualizar todos los inputs del flake\n$(NC)"
	@printf "$(YELLOW)  2. Validar configuración\n$(NC)"
	@printf "$(YELLOW)  3. Aplicar cambios al sistema\n$(NC)"
	@printf "\n"
	@$(MAKE) --no-print-directory upd-all
	@$(MAKE) --no-print-directory sys-apply-safe
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Upgrade completo finalizado$(NC)\n"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Display all available outputs from the flake
upd-show: ## Show flake outputs and metadata
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📄 Flake Outputs Structure                \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@nix flake show $(FLAKE_DIR) 2>&1 | grep -v "^warning:" || nix flake show $(FLAKE_DIR) 2>/dev/null || true
	@printf "\n"

# Validate flake syntax and structure without building
upd-check: ## Check flake consistency
	@printf "$(CYAN)📋 Checking flake syntax...\n$(NC)"
	nix flake check $(FLAKE_DIR)
