# ============================================================================
# Limpieza y Optimización
# ============================================================================
# Descripción: Targets para limpiar generaciones antiguas y optimizar el store
# Targets: 7 targets
# ============================================================================

.PHONY: clean clean-week clean-conservative deep-clean optimize clean-result fix-store

# === Limpieza y Optimización ===

clean: ## Clean build artifacts older than 30 days
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Limpieza Estándar (30 días)            \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando artefactos de construcción mayores a 30 días...\n$(NC)"
	@printf "$(YELLOW)Esto eliminará generaciones del sistema y paquetes no referenciados.\n$(NC)"
	@printf "$(BLUE)Se mantendrán las generaciones de los últimos 30 días para rollback.\n$(NC)"
	@printf "\n"
	sudo nix-collect-garbage --delete-older-than 30d
	nix-collect-garbage --delete-older-than 30d
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Limpieza completada (mantenidos últimos 30 días)\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
clean-week: ## Clean build artifacts older than 7 days
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Limpieza Semanal (7 días)              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando artefactos de construcción mayores a 7 días...\n$(NC)"
	@printf "$(YELLOW)⚠️  Solo podrás hacer rollback a generaciones de la última semana.\n$(NC)"
	@printf "$(BLUE)Útil cuando necesitas liberar espacio rápidamente.\n$(NC)"
	@printf "\n"
	sudo nix-collect-garbage --delete-older-than 7d
	nix-collect-garbage --delete-older-than 7d
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Limpieza completada (mantenidos últimos 7 días)\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
clean-conservative: ## Clean build artifacts older than 90 days (very safe)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Limpieza Conservadora (90 días)         \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Limpiando artefactos de construcción mayores a 90 días...\n$(NC)"
	@printf "$(GREEN)✓ Esta es la opción más segura - mantiene 90 días de historial.\n$(NC)"
	@printf "$(BLUE)Recomendado para sistemas de producción o primera limpieza.\n$(NC)"
	@printf "\n"
	sudo nix-collect-garbage --delete-older-than 90d
	nix-collect-garbage --delete-older-than 90d
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Limpieza conservadora completada (mantenidos últimos 90 días)\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
deep-clean: ## Aggressive cleanup (removes ALL old generations)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🗑️  Limpieza Profunda (IRREVERSIBLE)        \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
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
	if [ "$$REPLY" = "yes" ]; then \
		printf "\n$(YELLOW)Ejecutando limpieza profunda...\n$(NC)\n"; \
		sudo nix-collect-garbage -d; \
		nix-collect-garbage -d; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(GREEN)✅ Limpieza profunda completada\n$(NC)"; \
		printf "$(RED)⚠️  TODAS las generaciones antiguas han sido eliminadas\n$(NC)"; \
		printf "$(BLUE)Usa 'make info' para verificar el espacio liberado\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	else \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(BLUE)ℹ️  Limpieza profunda cancelada\n$(NC)"; \
		printf "$(GREEN)✓ No se realizaron cambios en el sistema\n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
	fi
optimize: ## Optimize nix store
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🚀 Optimización del Nix Store             \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Optimizando el Nix store...\n$(NC)"
	@printf "$(YELLOW)Esto encontrará archivos idénticos y los convertirá en hardlinks.\n$(NC)"
	@printf "$(BLUE)Ahorra espacio sin eliminar nada - proceso seguro.\n$(NC)"
	@printf "$(YELLOW)⏱️  Esto puede tomar de 5 a 30 minutos dependiendo del tamaño del store.\n$(NC)"
	@printf "\n"
	sudo nix-store --optimise
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Optimización del store completada\n$(NC)"
	@printf "$(BLUE)Usa 'make info' para verificar el espacio ahorrado\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
clean-result: ## Remove result symlinks
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧹 Clean Result Symlinks                  \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Searching for result symlinks...$(NC)\n"
	@printf "$(YELLOW)These symlinks are created by Nix builds and can be safely removed.$(NC)\n"
	@printf "\n"
	@RESULT_LINKS=$$(find . -maxdepth 2 -name 'result*' -type l 2>/dev/null); \
	if [ -z "$$RESULT_LINKS" ]; then \
		printf "$(GREEN)✓ No result symlinks found$(NC)\n"; \
	else \
		COUNT=$$(echo "$$RESULT_LINKS" | wc -l); \
		printf "$(BLUE)Found $(YELLOW)$$COUNT$(NC) $(BLUE)result symlink(s):$(NC)\n"; \
		echo "$$RESULT_LINKS" | while read -r link; do \
			TARGET=$$(readlink -f "$$link" 2>/dev/null || echo "broken"); \
			printf "  $(YELLOW)$$link$(NC)"; \
			if [ "$$TARGET" != "broken" ]; then \
				printf " → $(GREEN)$$TARGET$(NC)\n"; \
			else \
				printf " → $(RED)(broken link)$(NC)\n"; \
			fi; \
		done; \
		printf "\n$(BLUE)Removing symlinks...$(NC)\n"; \
		find . -maxdepth 2 -name 'result*' -type l -delete 2>/dev/null; \
		printf "$(GREEN)✅ Removed $$COUNT symlink(s)$(NC)\n"; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Cleanup complete$(NC)\n"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
fix-store: ## Attempt to repair nix store
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🔧 Repair Nix Store                       \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
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
