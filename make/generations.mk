# ============================================================================
# Generaciones y Rollback
# ============================================================================
# Descripción: Targets para gestionar generaciones del sistema y rollback
# Targets: 7 targets
# ============================================================================

.PHONY: gen-list gen-rollback gen-rollback-commit gen-diff gen-diff-current gen-sizes gen-current

# === Gestión de Generaciones ===

# List all system generations with details
gen-list: ## List all system generations
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📜 Generaciones del Sistema            $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(BLUE)Usa 'make gen-diff' para comparar generaciones\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Rollback to the previous generation
gen-rollback: ## Rollback to previous generation
	@printf "\n"
	@printf "$(RED)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(RED)            ⏪ Rollback de Configuración           $(NC)"
	@printf "\n$(RED)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(YELLOW)¿Estás seguro de que quieres volver a la generación anterior?\n$(NC)"
	@printf "$(BLUE)Esta acción cambiará la configuración actual inmediatamente.\n$(NC)"
	@printf "\n"
	@printf "$(RED)Escribe 'yes' para confirmar rollback: $(NC)"; \
	read -r REPLY; \
	if [ "$REPLY" = "yes" ]; then \
		printf "\n$(YELLOW)Ejecutando rollback...\n$(NC)\n"; \
		sudo nixos-rebuild rollback $(NIX_OPTS); \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Rollback completado exitosamente\n$(NC)"; \
		printf "$(BLUE)Sistema restaurado a la generación anterior.\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "\n$(BLUE)ℹ️  Rollback cancelado. No se realizaron cambios.\n$(NC)\n"; \
	fi

# Rollback to a specific commit and rebuild system
gen-rollback-commit: ## Rollback to specific commit and rebuild (use COMMIT=hash)
	@if [ -z "$$(COMMIT)" ]; then \
		printf "\n$(RED)Error: Se requiere el parámetro COMMIT$(NC)\n"; \
		printf "Uso: make gen-rollback-commit COMMIT=9220122\n"; \
		printf "     make gen-rollback-commit COMMIT=9220122face1b1f71f0cf9b1fcc8536fa0cd2842\n\n"; \
		exit 1; \
	fi
	@printf "\n"
	@printf "$(RED)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(RED)        ⏪ Rollback a Commit Específico y Rebuild        $(NC)"
	@printf "\n$(RED)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Verificando commit: $(YELLOW)$$(COMMIT)$(NC)\n"
	@if ! git rev-parse --verify "$$(COMMIT)" >/dev/null 2>&1; then \
		printf "$(RED)✗ Error: Commit '$$(COMMIT)' no encontrado$(NC)\n"; \
		printf "$(YELLOW)Verifica que el commit existe con: git log --oneline | grep $$(COMMIT)$(NC)\n\n"; \
		exit 1; \
	fi
	@COMMIT_FULL=$$(git rev-parse "$$(COMMIT)"); \
	COMMIT_SHORT=$$(git rev-parse --short "$$(COMMIT)"); \
	COMMIT_MSG=$$(git log -1 --format="%s" "$$(COMMIT)"); \
	COMMIT_DATE=$$(git log -1 --format="%ci" "$$(COMMIT)"); \
	printf "$(GREEN)✓ Commit encontrado:$(NC)\n"; \
	printf "  $(CYAN)Hash completo:$(NC) $$COMMIT_FULL\n"; \
	printf "  $(CYAN)Hash corto:$(NC) $$COMMIT_SHORT\n"; \
	printf "  $(CYAN)Mensaje:$(NC) $$COMMIT_MSG\n"; \
	printf "  $(CYAN)Fecha:$(NC) $$COMMIT_DATE\n\n"; \
	printf "$(YELLOW)Cambios en este commit:$(NC)\n"; \
	git show --stat "$$(COMMIT)" | head -20; \
	printf "\n"; \
	printf "$(RED)⚠️  ADVERTENCIA:$(NC)\n"; \
	printf "$(YELLOW)  - Esto cambiará el HEAD del repositorio a este commit$(NC)\n"; \
	printf "$(YELLOW)  - Se reconstruirá el sistema desde este commit$(NC)\n"; \
	printf "$(YELLOW)  - Cualquier cambio sin commit se perderá$(NC)\n"; \
	printf "$(YELLOW)  - Si tienes cambios sin guardar, usa 'git stash' primero$(NC)\n\n"; \
	printf "$(RED)Escribe 'yes' para confirmar rollback: $(NC)"; \
	read -r REPLY; \
	if [ "$$REPLY" = "yes" ]; then \
		printf "\n$(YELLOW)1/3 Guardando estado actual del repositorio...$(NC)\n"; \
		CURRENT_BRANCH=$$(git branch --show-current 2>/dev/null || echo "detached"); \
		CURRENT_COMMIT=$$(git rev-parse HEAD); \
		printf "$(BLUE)   Branch actual: $(YELLOW)$$CURRENT_BRANCH$(NC)\n"; \
		printf "$(BLUE)   Commit actual: $(YELLOW)$$(git rev-parse --short HEAD)$(NC)\n\n"; \
		printf "$(YELLOW)2/3 Haciendo checkout al commit $$COMMIT_SHORT...$(NC)\n"; \
		if git checkout "$$(COMMIT)" >/dev/null 2>&1; then \
			printf "$(GREEN)   ✓ Checkout exitoso$(NC)\n\n"; \
			printf "$(YELLOW)3/3 Reconstruyendo sistema desde este commit...$(NC)\n"; \
			if $(MAKE) --no-print-directory sys-apply-core; then \
				printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
				printf "$(GREEN)✅ Rollback completado exitosamente$(NC)\n"; \
				printf "$(BLUE)Sistema reconstruido desde commit: $$COMMIT_SHORT$(NC)\n"; \
				printf "$(BLUE)Mensaje: $$COMMIT_MSG$(NC)\n"; \
				printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
				printf "\n$(YELLOW)Nota:$(NC) El repositorio está ahora en el commit $$COMMIT_SHORT\n"; \
				printf "$(YELLOW)Para volver a main:$(NC) git checkout main\n"; \
				printf "$(YELLOW)Para crear una rama:$(NC) git checkout -b rollback-$$COMMIT_SHORT\n\n"; \
			else \
				printf "\n$(RED)✗ Error al reconstruir el sistema$(NC)\n"; \
				printf "$(YELLOW)Revirtiendo checkout...$(NC)\n"; \
				git checkout "$$CURRENT_COMMIT" >/dev/null 2>&1; \
				if [ "$$CURRENT_BRANCH" != "detached" ]; then \
					git checkout "$$CURRENT_BRANCH" >/dev/null 2>&1; \
				fi; \
				printf "$(BLUE)Repositorio restaurado a estado anterior$(NC)\n\n"; \
				exit 1; \
			fi; \
		else \
			printf "$(RED)   ✗ Error al hacer checkout$(NC)\n"; \
			printf "$(YELLOW)Verifica que no hay cambios sin commit: git status$(NC)\n\n"; \
			exit 1; \
		fi; \
	else \
		printf "\n$(BLUE)ℹ️  Rollback cancelado. No se realizaron cambios.\n$(NC)\n"; \
	fi

# Compare any two generations (requires GEN1 and GEN2 variables)
gen-diff: ## Compare two generations (use GEN1=n GEN2=m)
	@if [ -z "$$(GEN1)" ] || [ -z "$$(GEN2)" ]; then \
		printf "\n$(RED)Error: Se requieren GEN1 y GEN2$(NC)\n"; \
		printf "Uso: make gen-diff GEN1=101 GEN2=102\n\n"; \
		exit 1; \
	fi
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📊 Diferencias: Gen $$(GEN1) vs $$(GEN2)      $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Calculando diferencias de paquetes...$(NC)\n"
	nix-diff /nix/var/nix/profiles/system-$(GEN1)-link /nix/var/nix/profiles/system-$(GEN2)-link
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"

# Compare current generation with the previous one
gen-diff-current: ## Compare current generation with previous
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📊 Cambios en la última generación     $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
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
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            💾 Tamaño de Generaciones              $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | \
	awk '{print $1}' | while read -r gen; do \
		SIZE=$(du -sh /nix/var/nix/profiles/system-$gen-link 2>/dev/null | awk '{print $1}'); \
		printf "  Gen %-4s: %s\n" "$gen" "$SIZE"; \
	done
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"

# Show details of the current generation
gen-current: ## Show current generation info
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📌 Generación Actual                   $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
