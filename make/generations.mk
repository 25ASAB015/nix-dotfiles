# ============================================================================
# Generaciones y Rollback
# ============================================================================
# Descripción: Targets para gestionar generaciones del sistema y rollback
# Targets: 6 targets
# ============================================================================

.PHONY: list-generations rollback diff-generations diff-gen generation-sizes current-generation

# === Generaciones y Rollback ===

# List all system generations with current generation highlighted
# Shows total count and marks the active generation
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

# Rollback to the previous system generation
# Reverts all system changes to the last known good state
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

# Compare current generation with the previous one
# Shows package changes, additions, and removals
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

# Compare two specific generations by number
# Requires GEN1 and GEN2 parameters (e.g., make diff-gen GEN1=184 GEN2=186)
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

# Show disk usage for each generation
# Helps identify which generations are consuming the most space
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

# Display detailed information about the current active generation
# Shows generation number, activation date, and closure size
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
