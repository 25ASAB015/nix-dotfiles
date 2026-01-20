# ============================================================================
# Generaciones y Rollback
# ============================================================================
# Descripción: Targets para gestionar generaciones del sistema y rollback
# Targets: 6 targets
# ============================================================================

.PHONY: gen-list gen-rollback gen-diff gen-diff-current gen-sizes gen-current

# === Gestión de Generaciones ===

# List all system generations with details
gen-list: ## List all system generations
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📜 Generaciones del Sistema               \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(BLUE)Usa 'make gen-diff' para comparar generaciones\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Rollback to the previous generation
gen-rollback: ## Rollback to previous generation
	@printf "\n$(RED)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(RED)          ⏪ Rollback de Configuración              \n$(NC)"
	@printf "\n$(RED)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(YELLOW)¿Estás seguro de que quieres volver a la generación anterior?\n$(NC)"
	@printf "$(BLUE)Esta acción cambiará la configuración actual inmediatamente.\n$(NC)"
	@printf "\n"
	@printf "$(RED)Escribe 'yes' para confirmar rollback: $(NC)"; \
	read -r REPLY; \
	if [ "$REPLY" = "yes" ]; then \
		printf "\n$(YELLOW)Ejecutando rollback...\n$(NC)\n"; \
		sudo nixos-rebuild rollback; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Rollback completado exitosamente\n$(NC)"; \
		printf "$(BLUE)Sistema restaurado a la generación anterior.\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "\n$(BLUE)ℹ️  Rollback cancelado. No se realizaron cambios.\n$(NC)\n"; \
	fi

# Compare any two generations (requires GEN1 and GEN2 variables)
gen-diff: ## Compare two generations (use GEN1=n GEN2=m)
	@if [ -z "$(GEN1)" ] || [ -z "$(GEN2)" ]; then \
		printf "\n$(RED)Error: Se requieren GEN1 y GEN2$(NC)\n"; \
		printf "Uso: make gen-diff GEN1=101 GEN2=102\n\n"; \
		exit 1; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Diferencias: Gen $(GEN1) vs $(GEN2)          \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Calculando diferencias de paquetes...$(NC)\n"
	nix-diff /nix/var/nix/profiles/system-$(GEN1)-link /nix/var/nix/profiles/system-$(GEN2)-link
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"

# Compare current generation with the previous one
gen-diff-current: ## Compare current generation with previous
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Cambios en la última generación        \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@CURRENT=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current | awk '{print $1}'); \
	PREVIOUS=$((CURRENT - 1)); \
	if [ $PREVIOUS -gt 0 ]; then \
		printf "$(BLUE)Comparando Gen $PREVIOUS (anterior) con Gen $CURRENT (actual)...$(NC)\n\n"; \
		nix-diff /nix/var/nix/profiles/system-$PREVIOUS-link /nix/var/nix/profiles/system-$CURRENT-link; \
	else \
		printf "$(YELLOW)No hay generación anterior para comparar.$(NC)\n"; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"

# Show disk usage for all generations
gen-sizes: ## Show size of generations
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          💾 Tamaño de Generaciones                 \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | \
	awk '{print $1}' | while read -r gen; do \
		SIZE=$(du -sh /nix/var/nix/profiles/system-$gen-link 2>/dev/null | awk '{print $1}'); \
		printf "  Gen %-4s: %s\n" "$gen" "$SIZE"; \
	done
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"

# Show details of the current generation
gen-current: ## Show current generation info
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📌 Generación Actual                       \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
