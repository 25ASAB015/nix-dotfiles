# ============================================================================
# Limpieza y Optimización
# ============================================================================
# Descripción: Targets para limpiar generaciones antiguas y optimizar el store
# Targets: 5 targets
# ============================================================================

.PHONY: sys-gc sys-purge sys-optimize sys-clean-result sys-fix-store

# === Mantenimiento y Espacio ===

# Flexible cleanup - removes generations older than specified days (default: 30)
# Usage: make sys-gc [DAYS=n]
DAYS ?= 30
sys-gc: ## Clean build artifacts older than specified days (default: 30)
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@if [ "$(DAYS)" -eq 7 ]; then \
		printf "$(CYAN)          🧹 Limpieza Semanal (7 días)             $(NC)\n"; \
	elif [ "$(DAYS)" -eq 30 ]; then \
		printf "$(CYAN)          🧹 Limpieza Estándar (30 días)           $(NC)\n"; \
	elif [ "$(DAYS)" -eq 90 ]; then \
		printf "$(CYAN)          🧹 Limpieza Conservadora (90 días)       $(NC)\n"; \
	else \
		printf "$(CYAN)          🧹 Limpieza del Sistema ($(DAYS) días)          $(NC)\n"; \
	fi
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando artefactos de construcción mayores a $(DAYS) días...\n$(NC)"
	@if [ "$(DAYS)" -lt 15 ]; then \
		printf "$(YELLOW)⚠️  Advertencia: Solo se mantendrán $(DAYS) días de historial para rollback.\n$(NC)"; \
	else \
		printf "$(BLUE)Se mantendrán las generaciones de los últimos $(DAYS) días.\n$(NC)"; \
	fi
	@printf "\n"
	sudo nix-collect-garbage --delete-older-than $(DAYS)d
	nix-collect-garbage --delete-older-than $(DAYS)d
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Limpieza completada (mantenidos últimos $(DAYS) días)\n$(NC)"
	@printf "$(BLUE)Usa 'make sys-status' para verificar el espacio liberado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"


# Deep clean - removes ALL old generations (IRREVERSIBLE!)
# Use with extreme caution - requires confirmation
sys-purge: ## Aggressive cleanup (removes ALL old generations)
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🗑️  Purga Profunda (IRREVERSIBLE)          $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(RED)⚠️  ADVERTENCIA CRÍTICA ⚠️\n$(NC)"
	@printf "$(RED)Este comando eliminará TODAS las generaciones antiguas del sistema.\n$(NC)"
	@printf "$(RED)Esta acción es IRREVERSIBLE y NO podrás hacer rollback.\n$(NC)"
	@printf "\n"
	@printf "$(YELLOW)¿Qué se eliminará?\n$(NC)"
	@printf "$(YELLOW)  • TODAS las generaciones del sistema (excepto la actual)\n$(NC)"
	@printf "$(YELLOW)  • TODAS las generaciones de usuario\n$(NC)"
	@printf "$(YELLOW)  • TODOS los paquetes no referenciados\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Espacio que se liberará: Máximo posible (típicamente 20-100+ GB)\n$(NC)"
	@printf "\n"
	@printf "$(RED)¿Estás ABSOLUTAMENTE seguro? Escribe 'yes' para continuar: $(NC)"; \
	read -r REPLY; \
	if [ "$REPLY" = "yes" ]; then \
		printf "\n$(YELLOW)Ejecutando purga profunda...\n$(NC)\n"; \
		sudo nix-collect-garbage -d; \
		nix-collect-garbage -d; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Purga profunda completada\n$(NC)"; \
		printf "$(RED)⚠️  TODAS las generaciones antiguas han sido eliminadas\n$(NC)"; \
		printf "$(BLUE)Usa 'make sys-status' para verificar el espacio liberado\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(BLUE)ℹ️  Purga profunda cancelada\n$(NC)"; \
		printf "$(GREEN)✓ No se realizaron cambios en el sistema\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	fi

# Optimize Nix store by creating hardlinks for identical files
sys-optimize: ## Optimize nix store
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🚀 Optimización del Nix Store            $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Optimizando el Nix store...\n$(NC)"
	@printf "$(YELLOW)Esto encontrará archivos idénticos y los convertirá en hardlinks.\n$(NC)"
	@printf "$(BLUE)Ahorra espacio sin eliminar nada - proceso seguro.\n$(NC)"
	@printf "$(YELLOW)⏱️  Esto puede tomar de 5 a 30 minutos dependiendo del tamaño del store.\n$(NC)"
	@printf "\n"
	sudo nix-store --optimise
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Optimización del store completada\n$(NC)"
	@printf "$(BLUE)Usa 'make sys-status' para verificar el espacio ahorrado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Remove result symlinks created by nix build commands
sys-clean-result: ## Remove result symlinks
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Clean Result Symlinks                 $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Searching for result symlinks...$(NC)\n"
	@printf "$(YELLOW)These symlinks are created by Nix builds and can be safely removed.$(NC)\n"
	@printf "\n"
	@RESULT_LINKS=$(find . -maxdepth 2 -name 'result*' -type l 2>/dev/null); \
	if [ -z "$RESULT_LINKS" ]; then \
		printf "$(GREEN)✓ No result symlinks found$(NC)\n"; \
	else \
		COUNT=$(echo "$RESULT_LINKS" | wc -l); \
		printf "$(BLUE)Found $(YELLOW)$COUNT$(NC) $(BLUE)result symlink(s):$(NC)\n"; \
		echo "$RESULT_LINKS" | while read -r link; do \
			TARGET=$(readlink -f "$link" 2>/dev/null || echo "broken"); \
			printf "  $(YELLOW)$link$(NC)"; \
			if [ "$TARGET" != "broken" ]; then \
				printf " → $(GREEN)$TARGET$(NC)\n"; \
			else \
				printf " → $(RED)(broken link)$(NC)\n"; \
			fi; \
		done; \
		printf "\n$(BLUE)Removing symlinks...$(NC)\n"; \
		find . -maxdepth 2 -name 'result*' -type l -delete 2>/dev/null; \
		printf "$(GREEN)✅ Removed $COUNT symlink(s)$(NC)\n"; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Cleanup complete$(NC)\n"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Verify and repair the Nix store for corruption
sys-fix-store: ## Attempt to repair nix store
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔧 Repair Nix Store                      $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Verifying and repairing Nix store...$(NC)\n"
	@printf "$(YELLOW)⚠️  This may take a long time (minutes to hours) on large systems.$(NC)\n"
	@printf "$(YELLOW)The store will be checked for corruption and repaired if needed.$(NC)\n"
	@printf "\n"
	@if nix-store --verify --check-contents --repair; then \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Store repair complete$(NC)\n"; \
		printf "$(BLUE)All store paths verified and repaired.$(NC)\n"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(RED)✗ Store repair encountered errors$(NC)\n"; \
		printf "$(YELLOW)Check the output above for details.$(NC)\n"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
		exit 1; \
	fi
