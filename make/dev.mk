# ============================================================================
# Análisis y Desarrollo
# ============================================================================
# Descripción: Targets para desarrollo, búsqueda de paquetes y análisis
# Targets: 8 targets
# ============================================================================

.PHONY: list-hosts hosts-info search search-installed repl shell vm closure-size

# === Análisis y Desarrollo ===

list-hosts: ## List available host configurations
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📋 Available Hosts                         \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@TOTAL=0; CONFIGURED=0; \
	for host in $(AVAILABLE_HOSTS); do \
		TOTAL=$$((TOTAL + 1)); \
		if [ -d "hosts/$$host" ] && [ -f "hosts/$$host/configuration.nix" ]; then \
			CONFIGURED=$$((CONFIGURED + 1)); \
		fi; \
	done; \
	printf "\n$(BLUE)Total hosts:$(NC) $(GREEN)$$TOTAL$(NC)\n"; \
	printf "$(BLUE)Configured:$(NC) $(GREEN)$$CONFIGURED$(NC)\n"
	@printf "\n$(BLUE)Hosts overview:$(NC)\n"
	@for host in $(AVAILABLE_HOSTS); do \
		printf "  $(GREEN)%-15s$(NC) " $$host; \
		if [ -d "hosts/$$host" ] && [ -f "hosts/$$host/configuration.nix" ]; then \
			printf "$(GREEN)✓$(NC) configured"; \
			if [ "$$host" = "$(HOSTNAME)" ]; then \
				printf " $(YELLOW)(current)$(NC)"; \
			fi; \
			printf "\n"; \
		else \
			printf "$(RED)✗$(NC) not found\n"; \
		fi; \
	done
	@printf "\n$(BLUE)Detailed information:$(NC)\n"
	@for host in $(AVAILABLE_HOSTS); do \
		printf "\n  $(GREEN)$${host}$(NC)"; \
		if [ "$$host" = "$(HOSTNAME)" ]; then \
			printf " $(YELLOW)(current)$(NC)"; \
		fi; \
		printf "\n"; \
		if [ -f "hosts/$$host/configuration.nix" ]; then \
			printf "    Status: $(GREEN)✓$(NC) configured\n"; \
			printf "    Path: $(BLUE)hosts/$$host/$(NC)\n"; \
			FILE_COUNT=$$(ls hosts/$$host/ 2>/dev/null | wc -l); \
			printf "    Files: $(GREEN)$$FILE_COUNT$(NC)\n"; \
		else \
			printf "    Status: $(RED)✗$(NC) not found\n"; \
		fi; \
	done
	@printf "\n$(BLUE)Usage:$(NC) make switch HOSTNAME=<host>\n"
	@printf "$(BLUE)Example:$(NC) make switch HOSTNAME=laptop\n"
	@printf "\n"

hosts-info: list-hosts ## Show info about all configured hosts (alias for list-hosts)

search: ## Search for packages in nixpkgs (use PKG=name)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)Error: PKG variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make search PKG=firefox$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)🔍 Searching for: $(PKG)\n$(NC)"
	@printf "================================\n"
	@nix search nixpkgs $(PKG)
search-installed: ## Search in currently installed packages (use PKG=name)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)Error: PKG variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make search-installed PKG=firefox$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)🔍 Searching installed packages for: $(PKG)\n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)1. Executable in PATH:$(NC)\n"
	@if command -v $(PKG) >/dev/null 2>&1; then \
		EXEC_PATH=$$(command -v $(PKG)); \
		printf "  $(GREEN)✓ Found:$(NC) $$EXEC_PATH\n"; \
		PKG_STORE_PATH=$$(readlink -f $$EXEC_PATH 2>/dev/null | sed 's|/bin/.*||' | head -1); \
		if [ -n "$$PKG_STORE_PATH" ]; then \
			printf "  $(BLUE)Store path:$(NC) $$PKG_STORE_PATH\n"; \
		fi; \
	else \
		printf "  $(YELLOW)Not found in PATH$(NC)\n"; \
	fi
	@printf "\n$(BLUE)2. User environment (nix-env):$(NC)\n"
	@USER_PKGS=$$(nix-env -q 2>/dev/null | grep -i "$(PKG)" || true); \
	if [ -n "$$USER_PKGS" ]; then \
		echo "$$USER_PKGS" | sed 's/^/  /'; \
	else \
		printf "  $(YELLOW)Not found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)3. System packages (current-system):$(NC)\n"
	@SYSTEM_PKGS=$$(nix-store -q --references /run/current-system 2>/dev/null | grep -i "$(PKG)" | head -10 || true); \
	if [ -n "$$SYSTEM_PKGS" ]; then \
		echo "$$SYSTEM_PKGS" | sed 's/^/  /'; \
	else \
		printf "  $(YELLOW)Not found$(NC)\n"; \
	fi
	@printf "\n$(BLUE)4. Home Manager profiles:$(NC)\n"
	@if [ -d "/etc/profiles/per-user" ]; then \
		HM_PKGS=$$(find /etc/profiles/per-user -name "$(PKG)" -type f 2>/dev/null | head -5 || true); \
		if [ -n "$$HM_PKGS" ]; then \
			echo "$$HM_PKGS" | sed 's/^/  /'; \
		else \
			printf "  $(YELLOW)Not found$(NC)\n"; \
		fi; \
	else \
		printf "  $(YELLOW)Home Manager profiles not found$(NC)\n"; \
	fi
	@printf "\n"

repl: ## Start nix repl with flake
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🧠 Nix REPL - Interactive Shell           \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Starting Nix REPL with flake loaded...$(NC)\n"
	@printf "$(YELLOW)Useful commands:$(NC)\n"
	@printf "  $(GREEN):q$(NC) or $(GREEN):quit$(NC) - Exit REPL\n"
	@printf "  $(GREEN)outputs$(NC) - View flake outputs\n"
	@printf "  $(GREEN)outputs.nixosConfigurations.hydenix$(NC) - View configuration\n"
	@printf "\n"
	@nix repl --extra-experimental-features repl-flake $(FLAKE_DIR)
shell: ## Enter development shell
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🐚 Development Shell                      \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@if nix flake show $(FLAKE_DIR) 2>/dev/null | grep -q "devShells"; then \
		printf "$(BLUE)Entering development shell...$(NC)\n"; \
		printf "$(YELLOW)This shell includes development tools from your flake.$(NC)\n"; \
		printf "\n"; \
		nix develop $(FLAKE_DIR); \
	else \
		printf "$(YELLOW)⚠️  No devShells configured in flake$(NC)\n"; \
		printf "$(BLUE)To use this command, add devShells to your flake.nix:$(NC)\n"; \
		printf "\n"; \
		printf "$(CYAN)devShells.x86_64-linux.default = pkgs.mkShell {$(NC)\n"; \
		printf "$(CYAN)  buildInputs = [ /* your tools */ ];$(NC)\n"; \
		printf "$(CYAN)};$(NC)\n"; \
		printf "\n"; \
		printf "$(YELLOW)For now, using basic nix-shell...$(NC)\n"; \
		printf "\n"; \
		nix develop $(FLAKE_DIR) || nix-shell; \
	fi
vm: ## Build and run VM
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          🖥️  NixOS Virtual Machine               \n$(NC)"
	@printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Building VM from current configuration...$(NC)\n"
	@printf "$(YELLOW)This may take a few minutes on first build.$(NC)\n"
	@printf "\n"
	@if nix build '.#vm' 2>&1; then \
		printf "\n$(GREEN)✅ VM built successfully$(NC)\n"; \
		if [ -f "./result/bin/run-hydenix-vm" ]; then \
			VM_SCRIPT="./result/bin/run-hydenix-vm"; \
		elif [ -f "./result/bin/run-nixos-vm" ]; then \
			VM_SCRIPT="./result/bin/run-nixos-vm"; \
		else \
			VM_SCRIPT=$$(find ./result -name "run-*-vm" -type f -executable | head -1); \
			if [ -z "$$VM_SCRIPT" ]; then \
				printf "$(RED)✗ VM script not found$(NC)\n"; \
				printf "$(YELLOW)Checking result directory...$(NC)\n"; \
				ls -la ./result/bin/ 2>/dev/null || find ./result -type f -executable 2>/dev/null | head -5; \
				printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
				printf "\n"; \
				exit 1; \
			fi; \
		fi; \
		printf "$(BLUE)Starting VM...$(NC)\n"; \
		printf "$(YELLOW)Press Ctrl+Alt+G to release mouse/keyboard$(NC)\n"; \
		printf "$(YELLOW)Use 'systemctl poweroff' in VM to shutdown$(NC)\n"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)\n"; \
		$$VM_SCRIPT; \
	else \
		printf "\n$(RED)✗ VM build failed$(NC)\n"; \
		printf "$(YELLOW)Check the error messages above for details.$(NC)\n"; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n"; \
		exit 1; \
	fi

closure-size: ## Show closure size of current system
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 System Closure Size Analysis          \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "$(BLUE)Total system closure size:$(NC)\n"
	@SYSTEM_INFO=$$(nix path-info -Sh /run/current-system | head -1); \
	SYSTEM_SIZE=$$(echo "$$SYSTEM_INFO" | awk '{print $$2 " " $$3}'); \
	SYSTEM_PATH=$$(echo "$$SYSTEM_INFO" | awk '{print $$1}'); \
	printf "  $(GREEN)$$SYSTEM_SIZE$(NC)\n"; \
	printf "  $(YELLOW)$$SYSTEM_PATH$(NC)\n"
	@printf "\n$(BLUE)Top 10 largest packages:$(NC)\n"
	@nix path-info -rSh /run/current-system | \
		sort -k2 -h | \
		tail -10 | \
		awk -v GREEN="$(GREEN)" -v YELLOW="$(YELLOW)" -v NC="$(NC)" '{printf "  %s%8s%s  %s%s%s\n", GREEN, $$2, NC, YELLOW, $$1, NC}'
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Analysis complete$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
