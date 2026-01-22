# ============================================================================
# Gestión del Sistema
# ============================================================================
# Descripción: Targets para rebuild, switch, validación y gestión del sistema
# Targets: 14 targets
# ============================================================================

.PHONY: sys-apply sys-apply-safe sys-apply-fast sys-test sys-build sys-dry-run sys-boot sys-check sys-debug sys-force sys-doctor sys-fix-git sys-hw-scan sys-deploy

# === Operaciones del Sistema ===

# Build and activate new system configuration for the current hostname
sys-apply: ## Build and switch to new configuration
	@$(MAKE) --no-print-directory sys-fix-git
	@$(MAKE) --no-print-directory sys-apply-core

sys-apply-core:
	@printf "\n"
	@printf "$(CYAN)                            🔄 Apply (Build & Switch)                            $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@if [ "$$(id -u)" -eq 0 ]; then \
		if [ -n "$$SUDO_USER" ]; then \
			sudo -u "$$SUDO_USER" git add .; \
		else \
			printf "$(RED)✗ Do not run 'make sys-apply' as root (no SUDO_USER)\n$(NC)"; \
			exit 1; \
		fi; \
	else \
		git add .; \
	fi	
	@printf "\n$(BLUE)===================================== Build =====================================\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME)
	@printf "\n$(BLUE)===================== ✅ Deployment completed successfully! =====================\n$(NC)"

# Validate configuration and then apply (recommended safe workflow)
sys-apply-safe: sys-check sys-apply ## Validate then switch (safest option)

# Fast rebuild skipping internal nixos-rebuild checks for speed
sys-apply-fast: ## Quick rebuild (skip checks)
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            ⚡ Rebuild Rápido (Apply Fast)         $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Ejecutando switch rápido omitiendo verificaciones...\n$(NC)"
	@printf "$(YELLOW)⚠️  Este comando usa '--fast' para acelerar el proceso.\n$(NC)"
	@printf "$(BLUE)Útil cuando estás seguro de tu configuración y necesitas velocidad.\n$(NC)"
	@printf "\n"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --fast
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Switch rápido completado\n$(NC)"
	@printf "$(BLUE)Configuración aplicada exitosamente\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Build and test configuration without activating it
sys-test: ## Build and test configuration (no switch)
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🧪 Test Configuration                  $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(YELLOW)🧪 Testing configuration (no switch)...\n$(NC)"
	sudo nixos-rebuild test --flake $(FLAKE_DIR)#$(HOSTNAME)

# Build configuration without activating it and show build statistics
sys-build: ## Build configuration without switching
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🔨 Build Configuration                 $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Building configuration without applying changes...$(NC)\n"
	@printf "$(YELLOW)This will compile but not activate the new generation.$(NC)\n"
	@printf "\n"
	@START=$(date +%s); \
	sudo nixos-rebuild build --flake $(FLAKE_DIR)#$(HOSTNAME); \
	BUILD_EXIT=$?; \
	END=$(date +%s); \
	DURATION=$((END - START)); \
	MINUTES=$((DURATION / 60)); \
	SECONDS=$((DURATION % 60)); \
	printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
	if [ $BUILD_EXIT -eq 0 ]; then \
		printf "$(GREEN)✅ Build completed successfully$(NC)\n"; \
		printf "$(BLUE)Configuration compiled but not activated.$(NC)\n"; \
		printf "$(YELLOW)Use 'make sys-apply' to apply changes.$(NC)\n"; \
		printf "\n$(BLUE)Build Statistics:$(NC)\n"; \
		if [ $MINUTES -gt 0 ]; then \
		printf "  $(GREEN)Build time:$(NC) $(YELLOW)$${MINUTES}m $${SECONDS}s$(NC) ($(YELLOW)$${DURATION}s$(NC) total)\n"; \
		else \
		printf "  $(GREEN)Build time:$(NC) $(YELLOW)$${SECONDS}s$(NC)\n"; \
		fi; \
	else \
		printf "$(RED)✗ Build failed$(NC)\n"; \
		printf "$(YELLOW)Build time: $${DURATION}s$(NC)\n"; \
	fi; \
	printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
	printf "\n"
	exit $BUILD_EXIT

# Preview what would be built or changed without actually building
sys-dry-run: ## Show what would be built/changed
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🔍 Dry Run - Preview Changes           $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Showing what would be built/changed without applying...$(NC)\n\n"
	@sudo nixos-rebuild dry-run --flake $(FLAKE_DIR)#$(HOSTNAME)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Dry run completed$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Build configuration and set it as default for next boot
sys-boot: ## Build and set as boot default (no immediate switch)
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🥾 Configurar para Próximo Arranque    $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Compilando y configurando para el próximo arranque...\n$(NC)"
	@printf "$(YELLOW)Los cambios se aplicarán al reiniciar el sistema.\n$(NC)"
	@printf "$(YELLOW)La sesión actual no se verá afectada.\n$(NC)"
	@printf "\n"
	sudo nixos-rebuild boot --flake $(FLAKE_DIR)#$(HOSTNAME)
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Configuración preparada para próximo arranque\n$(NC)"
	@printf "$(BLUE)Reinicia el sistema para aplicar los cambios.\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Validate flake syntax and configuration before applying changes
sys-check: ## Validate configuration before applying
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🔍 Validation Checks (sys-check)       $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)1/3 Checking flake syntax...$(NC) "
	@if nix flake check $(FLAKE_DIR) >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
		nix flake check $(FLAKE_DIR); \
		exit 1; \
	fi
	@printf "$(BLUE)2/3 Checking configuration evaluation...$(NC) "
	@if nix eval .#nixosConfigurations.$(HOSTNAME).config.system.build.toplevel >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
		nix eval .#nixosConfigurations.$(HOSTNAME).config.system.build.toplevel --show-trace; \
		exit 1; \
	fi
	@printf "$(BLUE)3/3 Checking for common issues...$(NC) "
	@if command -v statix >/dev/null 2>&1; then \
		if statix check . >/dev/null 2>&1; then \
			printf "$(GREEN)✓$(NC)\n"; \
		else \
			printf "$(YELLOW)⚠$(NC) (warnings found, see 'make fmt-lint')\n"; \
		fi \
	else \
		printf "$(YELLOW)⊘$(NC) (statix not installed)\n"; \
	fi
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Validation passed$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Rebuild with maximum verbosity and debug tracing enabled
sys-debug: ## Rebuild with verbose output and trace
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🐛 Debug Rebuild (Verbose)             $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(RED)🐛 Debug rebuild with full trace...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --show-trace --verbose

# Emergency rebuild with maximum debugging and cache disabled
sys-force: ## Emergency rebuild with maximum verbosity
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🚨 Rebuild Forzado (Debug Extremo)     $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(RED)⚠️  MODO DE RECONSTRUCCIÓN FORZADA ACTIVADO\n$(NC)"
	@printf "$(YELLOW)Este comando ejecuta rebuild con máxima verbosidad y debugging.\n$(NC)"
	@printf "$(YELLOW)Desactiva caché de evaluación para forzar reconstrucción completa.\n$(NC)"
	@printf "$(BLUE)Útil cuando el sistema no arranca o hay problemas críticos.\n$(NC)"
	@printf "$(RED)⚠️  Este proceso puede tomar mucho más tiempo que un rebuild normal.\n$(NC)"
	@printf "\n"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --show-trace --verbose --option eval-cache false
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Rebuild forzado completado\n$(NC)"
	@printf "$(BLUE)Revisa el output arriba para diagnosticar problemas\n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Complete workflow: stage, commit, push, and apply (deploy)
sys-deploy: ## Total sync (add + commit + push + apply)
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)                          🔄 Total Deployment (Ship it!)                           $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(PURPLE)Executing complete deployment workflow:$(NC)\n"
	@printf "  1. Fix permissions (sys-fix-git)\n"
	@printf "  2. Stage changes (git add)\n"
	@printf "  3. Commit changes (timestamped)\n"
	@printf "  4. Push to remote (git push)\n"
	@printf "  5. Build and apply (sys-apply)\n"
	@printf "\n"
	@$(MAKE) --no-print-directory sys-fix-git
	@$(MAKE) --no-print-directory git-add
	@$(MAKE) --no-print-directory git-commit
	@$(MAKE) --no-print-directory git-push
	@$(MAKE) --no-print-directory sys-apply-core
	@printf "\n"

# === Mantenimiento y Otros ===

# Generate new hardware configuration for the current hostname
sys-hw-scan: ## Re-scan hardware configuration
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🔧 Hardware Scan                       $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(BLUE)🔧 Scanning hardware configuration for $(HOSTNAME)...\n$(NC)"
	@sudo nixos-generate-config --show-hardware-config > hosts/$(HOSTNAME)/hardware-configuration-new.nix
	@printf "$(YELLOW)New hardware config saved as:\n$(NC)"
	@printf "  hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To review differences:\n$(NC)"
	@printf "  diff hosts/$(HOSTNAME)/hardware-configuration.nix hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To apply:\n$(NC)"
	@printf "  mv hosts/$(HOSTNAME)/hardware-configuration-new.nix hosts/$(HOSTNAME)/hardware-configuration.nix\n"

# Fix common permission issues in user directories and git repository
sys-doctor: ## Fix common permission issues (doctor)
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            👨‍⚕️ System Doctor (Permissions)        $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Fixing common permission issues...$(NC)\n"
	@printf "$(YELLOW)This requires sudo privileges.$(NC)\n"
	@printf "\n"
	@printf "$(BLUE)1. Fixing ~/.config permissions...$(NC) "
	@if sudo chown -R $USER:users ~/.config 2>/dev/null; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠️  (skipped)$(NC)\n"; \
	fi
	@printf "$(BLUE)2. Fixing ~/.local permissions...$(NC) "
	@if sudo chown -R $USER:users ~/.local 2>/dev/null; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠️  (skipped)$(NC)\n"; \
	fi
	@printf "$(BLUE)3. Fixing git repository permissions...$(NC)\n"
	@$(MAKE) --no-print-directory sys-fix-git
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Doctor: Permissions fixed$(NC)\n"
	@printf "$(BLUE)Common permission issues have been resolved.$(NC)\n"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Fix git repository ownership issues in the flake directory
sys-fix-git: ## Fix git repo ownership issues in flake dir
	@printf "\n"	
	@printf "$(CYAN)                              🔧 Fix Git Permissions                             $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@if [ -d "$(FLAKE_DIR)/.git/objects" ]; then \
		if find "$(FLAKE_DIR)/.git/objects" -maxdepth 2 -type d -not -user $USER 2>/dev/null | grep -q .; then \
			printf "  $(YELLOW)Fixing ownership in $(FLAKE_DIR)/.git...$(NC) "; \
			if sudo chown -R $USER:users "$(FLAKE_DIR)/.git" 2>/dev/null; then \
				printf "\n"; \
				printf "$(GREEN)✓$(NC)\n"; \
			else \
				printf "\n"; \
				printf "$(RED)✗$(NC)\n"; \
			fi; \
		else \
			printf "\n"; \
			printf "  $(GREEN)✓ Git permissions OK$(NC)\n"; \
		fi; \
	else \
		printf "\n"; \
		printf "  $(YELLOW)⚠️  No git repository found at $(FLAKE_DIR)$(NC)\n"; \
	fi
