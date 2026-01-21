# ============================================================================
# Análisis y Desarrollo
# ============================================================================
# Descripción: Targets para desarrollo, búsqueda de paquetes y análisis
# Targets: 7 targets
# ============================================================================

.PHONY: dev-hosts dev-search dev-search-inst dev-repl dev-shell dev-vm dev-size

# === Análisis y Desarrollo ===

# List all available hosts defined in the flake
dev-hosts: ## List all available hosts
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              🖥️  NixOS Hosts in Flake                  $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Searching for host configurations in $(FLAKE_DIR)/hosts...$(NC)\n\n"
	@if [ -d "hosts" ]; then \
		find hosts -maxdepth 1 -mindepth 1 -type d -not -path '*/.*' | sed 's|^hosts/|  • |'; \
	else \
		printf "$(RED)✗ hosts/ directory not found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)💡 Tip:$(NC) Use 'make sys-apply HOSTNAME=<name>' to deploy a specific host\n"
	@printf "\n"

# Search for a package in nixpkgs using nix-search
dev-search: ## Search nixpkgs for package (use PKG=name)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)✗ Error: PKG parameter is required$(NC)\n"; \
		printf "$(YELLOW)Usage: make dev-search PKG=<package-name>$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(BLUE)Searching for '$(PKG)' in nixpkgs...$(NC)\n"
	nix search nixpkgs $(PKG)

# Search for a package in currently installed system/user profiles
dev-search-inst: ## Search installed packages (use PKG=name)
	@if [ -z "$$(PKG)" ]; then \
		printf "$(RED)✗ Error: PKG parameter is required$(NC)\n"; \
		printf "$(YELLOW)Usage: make dev-search-inst PKG=<package-name>$(NC)\n"; \
		exit 1; \
	fi
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🔍 Searching Installed Packages        $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)1. In PATH (which):$(NC)\n"
	@PKG_PATH=$(which $(PKG) 2>/dev/null || true); \
	if [ -n "$PKG_PATH" ]; then \
		printf "  $(GREEN)✓ Found:$(NC) $PKG_PATH\n"; \
		PKG_STORE_PATH=$(readlink -f "$PKG_PATH" 2>/dev/null || true); \
		if [ -n "$PKG_STORE_PATH" ]; then \
			printf "  $(BLUE)Store path:$(NC) $PKG_STORE_PATH\n"; \
		fi; \
	else \
		printf "  $(YELLOW)Not found in PATH$(NC)\n"; \
	fi
	@printf "\n$(BLUE)2. User environment (nix-env):$(NC)\n"
	@USER_PKGS=$(nix-env -q 2>/dev/null | grep -i "$(PKG)" || true); \
	if [ -n "$USER_PKGS" ]; then \
		echo "$USER_PKGS" | sed 's/^/  /'; \
	else \
		printf "  $(YELLOW)Not found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)3. System packages (current-system):$(NC)\n"
	@SYSTEM_PKGS=$(nix-store -q --references /run/current-system 2>/dev/null | grep -i "$(PKG)" | head -10 || true); \
	if [ -n "$SYSTEM_PKGS" ]; then \
		echo "$SYSTEM_PKGS" | sed 's/^/  /'; \
	else \
		printf "  $(YELLOW)Not found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)4. Home Manager profiles:$(NC)\n"
	@if [ -d "/etc/profiles/per-user" ]; then \
		HM_PKGS=$(find /etc/profiles/per-user -name "$(PKG)" -type f 2>/dev/null | head -5 || true); \
		if [ -n "$HM_PKGS" ]; then \
			echo "$HM_PKGS" | sed 's/^/  /'; \
		else \
			printf "  $(YELLOW)Not found$(NC)\n"; \
		fi; \
	else \
		printf "  $(YELLOW)Home Manager profiles not found$(NC)\n"; \
	fi
	@printf "\n"

# Start nix repl with the current flake loaded
dev-repl: ## Start nix repl with flake
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧠 Nix REPL - Interactive Shell          $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Starting Nix REPL with flake loaded...$(NC)\n"
	@printf "$(YELLOW)Useful commands:$(NC)\n"
	@printf "  $(GREEN):q$(NC) or $(GREEN):quit$(NC) - Exit REPL\n"
	@printf "  $(GREEN)outputs$(NC) - View flake outputs\n"
	@printf "  $(GREEN)outputs.nixosConfigurations.$(HOSTNAME)$(NC) - View configuration\n"
	@printf "\n"
	@nix repl --extra-experimental-features repl-flake $(FLAKE_DIR)

# Enter a development shell (uses flake's devShells or basic nix-shell)
dev-shell: ## Enter development shell
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🐚 Development Shell                     $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if nix flake show $(FLAKE_DIR) 2>/dev/null | grep -q "devShells"; then \
		printf "$(BLUE)Entering development shell...$(NC)\n"; \
		nix develop $(FLAKE_DIR); \
	else \
		printf "$(YELLOW)⚠️  No devShells configured in flake, using nix-shell...$(NC)\n"; \
		nix-shell; \
	fi

# Build and run a VM for testing configuration
dev-vm: ## Build and run VM (use HOST=name)
	@HOST=$${HOST:-$(HOSTNAME)}; \
	printf "\n"; \
	printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"; \
	printf "$(CYAN)            🖥️  NixOS Virtual Machine ($$HOST)        $(NC)"; \
	printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Building VM from configuration for $$HOST...$(NC)\n"
	@if nix build ".#nixosConfigurations.$$HOST.config.system.build.vm" 2>/dev/null; then \
		printf "\n$(GREEN)✅ VM built successfully$(NC)\n"; \
		printf "$(BLUE)Starting VM...$(NC)\n"; \
		./result/bin/run-*-vm; \
	else \
		printf "\n$(RED)✗ VM build failed$(NC)\n"; \
		exit 1; \
	fi

# Show closure size of a host or current system
dev-size: ## Show closure size (use HOST=name)
	@HOST_PATH=$${HOST:+$(FLAKE_DIR)#nixosConfigurations.$$HOST.config.system.build.toplevel}; \
	HOST_PATH=$${HOST_PATH:-/run/current-system}; \
	printf "\n"; \
	printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"; \
	printf "$(CYAN)            📊 System Closure Size Analysis        $(NC)"; \
	printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Closure size for $$HOST_PATH:$(NC)\n"
	@nix path-info -Sh $$HOST_PATH
	@printf "\n$(BLUE)Top 10 largest packages:$(NC)\n"
	@nix path-info -rSh $$HOST_PATH | sort -k2 -h | tail -10
	@printf "\n"
