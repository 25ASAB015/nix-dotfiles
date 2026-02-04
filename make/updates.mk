# ============================================================================
# Actualizaciones y Flakes
# ============================================================================
# Descripción: Targets para actualizar inputs del flake y gestionar versiones
# Targets: 8 targets
# ============================================================================

.PHONY: upd-all upd-nixpkgs upd-hydenix upd-input upd-ai upd-diff upd-upgrade upd-show upd-check upd-dots .upd-externals

# === Actualización de Flake ===

# Update all flake inputs to their latest versions
upd-all: ## Update all flake inputs
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🔄 Update All Inputs                   $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Actualizando todos los inputs del flake...$(NC)\n"
	nix flake update

upd-nixpkgs: ## Update only nixpkgs input
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📦 Update Nixpkgs                      $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	nix flake update nixpkgs --flake $(FLAKE_DIR)

upd-hydenix: ## Update only hydenix input
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📦 Update Hydenix                      $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	nix flake update hydenix --flake $(FLAKE_DIR)

# Update OpenCode + Cursor/Antigravity (nixpkgs-unstable) and apply in one go
upd-ai: ## Update OpenCode, Cursor and Antigravity, then apply (update + sys-apply)
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🤖 Update AI tools + Apply (OpenCode + Cursor + Antigravity)  $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)  1/2 Actualizando opencode y nixpkgs-unstable...$(NC)\n"
	nix flake update --flake $(FLAKE_DIR) opencode nixpkgs-unstable llm-agents
	@printf "\n$(BLUE)  2/2 Aplicando configuración...$(NC)\n"
	@$(MAKE) --no-print-directory sys-apply
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ OpenCode, Cursor y Antigravity actualizados y aplicados\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Allows targeted updates of individual flake dependencies
upd-input: ## Update a specific input (use INPUT=name)
	@if [ -z "$(INPUT)" ]; then \
		printf "\n"
		printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(CYAN)            📦 Update Specific Input               $(NC)"; \
		printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"; \
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
	fi
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📦 Update Specific Input               $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Actualizando input: $(INPUT)\n$(NC)"
	@printf "$(YELLOW)Esto actualizará solo este input específico.\n$(NC)"
	@printf "\n"
	nix flake update $(INPUT) --flake $(FLAKE_DIR)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Input '$(INPUT)' actualizado\n$(NC)"
	@printf "$(BLUE)Usa 'make upd-diff' para ver los cambios\n$(NC)"
	@printf "$(YELLOW)Recuerda ejecutar 'make sys-apply' para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Show intelligent diff showing what inputs changed in flake.lock
upd-diff: ## Show versions differences in flake.lock
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📊 Flake Changes Analysis              $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
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
# Complete upgrade workflow: sync everything and apply
upd-upgrade: ## [MASTER] Update EVERYTHING (Submodules + Flakes + Apply)
	@$(MAKE) --no-print-directory .upd-externals
	@$(MAKE) --no-print-directory upd-all
	@$(MAKE) --no-print-directory sys-apply-safe
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Sistema actualizado a la última versión (Total Sync)\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Display all available outputs from the flake
upd-show: ## Show flake outputs and metadata
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📄 Flake Outputs Structure             $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@nix flake show $(FLAKE_DIR) 2>&1 | grep -v "^warning:" || nix flake show $(FLAKE_DIR) 2>/dev/null || true
	@printf "\n"

# Validate flake syntax and structure without building
upd-check: ## Check flake consistency
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📋 Check Flake Consistency             $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)📋 Checking flake syntax...\n$(NC)"
	nix flake check $(FLAKE_DIR)
# Update dotfiles submodules and sync configs
upd-dots: .upd-externals ## Update submodules and sync oh-my-tmux

.upd-externals:
	@./make/sync-externals.sh
