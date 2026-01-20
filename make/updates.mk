# ============================================================================
# Actualizaciones y Flakes
# ============================================================================
# Descripción: Targets para actualizar inputs del flake y gestionar versiones
# Targets: 9 targets
# ============================================================================

.PHONY: update update-nixpkgs update-hydenix update-input diff-update upgrade show flake-check diff-flake

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
