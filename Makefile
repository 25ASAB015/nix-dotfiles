# NixOS Management Makefile
# Place this in your flake directory (where flake.nix is located)

.PHONY: help help-advanced help-examples rebuild switch test build clean gc update check format lint backup restore test-network

# Default target
.DEFAULT_GOAL := help

# Configuration
FLAKE_DIR := .
HOSTNAME ?= hydenix
BACKUP_DIR := ~/nixos-backups
AVAILABLE_HOSTS := hydenix laptop vm

# Colors for pretty output
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color

help: ## Show this help message
	@printf "$(CYAN)NixOS Management Commands\n$(NC)"
	@printf "==========================\n"
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "$(GREEN)%-20s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

help-advanced: ## Show detailed help with examples and workflows
	@printf "$(CYAN)╔════════════════════════════════════════════════════╗\n$(NC)"
	@printf "$(CYAN)║   NixOS Management - Advanced Help & Workflows    ║\n$(NC)"
	@printf "$(CYAN)╚════════════════════════════════════════════════════╝\n$(NC)"
	@printf "\n$(GREEN)📚 Common Workflows:$(NC)\n"
	@printf "  $(BLUE)Daily Development:$(NC)\n"
	@printf "    make test              → Test changes without commitment\n"
	@printf "    make switch            → Apply changes permanently\n"
	@printf "    make rollback          → Undo if something breaks\n"
	@printf "\n  $(BLUE)Safe Updates:$(NC)\n"
	@printf "    make backup            → Create backup first\n"
	@printf "    make update            → Update flake inputs\n"
	@printf "    make diff-update       → See what changed\n"
	@printf "    make validate          → Validate config\n"
	@printf "    make test              → Test new config\n"
	@printf "    make switch            → Apply if all good\n"
	@printf "\n  $(BLUE)Maintenance:$(NC)\n"
	@printf "    make health            → Check system health\n"
	@printf "    make clean             → Clean old generations\n"
	@printf "    make optimize          → Optimize store\n"
	@printf "    make generation-sizes  → See space usage\n"
	@printf "\n  $(BLUE)Multi-Host:$(NC)\n"
	@printf "    make list-hosts        → See available hosts\n"
	@printf "    make switch HOSTNAME=laptop  → Deploy to laptop\n"
	@printf "\n$(GREEN)🔍 Discovery:$(NC)\n"
	@printf "  make search PKG=neovim     → Search packages\n"
	@printf "  make info                  → System information\n"
	@printf "  make status                → Comprehensive status\n"
	@printf "\n$(GREEN)🐛 Troubleshooting:$(NC)\n"
	@printf "  make debug                 → Rebuild with full trace\n"
	@printf "  make validate              → Check for issues\n"
	@printf "  make watch-logs            → Monitor system logs\n"
	@printf "  make emergency             → Maximum verbosity rebuild\n"
	@printf "\n$(YELLOW)For full command list:$(NC) make help\n"
	@printf "$(YELLOW)For commands with examples:$(NC) make help-examples\n"
	@printf "$(YELLOW)For tutorial:$(NC) less MAKEFILE_TUTORIAL.md\n\n"

help-examples: ## Show commands with usage examples
	@printf "$(CYAN)╔════════════════════════════════════════════════════╗\n$(NC)"
	@printf "$(CYAN)║        NixOS Commands with Usage Examples          ║\n$(NC)"
	@printf "$(CYAN)╚════════════════════════════════════════════════════╝\n$(NC)"
	@printf "\n$(PURPLE)💡 Tip: Commands without parameters can be run directly$(NC)\n"
	@printf "$(PURPLE)   Commands with parameters are shown with examples below$(NC)\n\n"
	@printf "$(GREEN)═══ 🔨 Build & Deploy ═══$(NC)\n"
	@printf "$(BLUE)switch HOSTNAME=<host>$(NC)\n"
	@printf "  → make switch HOSTNAME=laptop\n\n"
	@printf "$(GREEN)═══ 🔍 Search & Discovery ═══$(NC)\n"
	@printf "$(BLUE)search PKG=<name>$(NC)\n"
	@printf "  → make search PKG=firefox\n"
	@printf "  → make search PKG=neovim\n\n"
	@printf "$(BLUE)search-installed PKG=<name>$(NC)\n"
	@printf "  → make search-installed PKG=kitty\n"
	@printf "  → make search-installed PKG=docker\n\n"
	@printf "$(GREEN)═══ 📦 Updates ═══$(NC)\n"
	@printf "$(BLUE)update-input INPUT=<name>$(NC)\n"
	@printf "  → make update-input INPUT=hydenix\n"
	@printf "  → make update-input INPUT=nixpkgs\n"
	@printf "  → make update-input INPUT=zen-browser-flake\n\n"
	@printf "$(GREEN)═══ 💾 Backup & Generations ═══$(NC)\n"
	@printf "$(BLUE)diff-gen GEN1=<n> GEN2=<m>$(NC)\n"
	@printf "  → make diff-gen GEN1=20 GEN2=25\n"
	@printf "  → make diff-gen GEN1=184 GEN2=186\n\n"
	@printf "$(GREEN)═══ 📋 Logs & Monitoring ═══$(NC)\n"
	@printf "$(BLUE)logs-service SVC=<service>$(NC)\n"
	@printf "  → make logs-service SVC=sshd\n"
	@printf "  → make logs-service SVC=docker\n"
	@printf "  → make logs-service SVC=networkmanager\n\n"
	@printf "$(GREEN)═══ 🛠️ Templates ═══$(NC)\n"
	@printf "$(BLUE)new-host HOST=<name>$(NC)\n"
	@printf "  → make new-host HOST=mylaptop\n"
	@printf "  → make new-host HOST=server\n"
	@printf "  → make new-host HOST=workstation\n\n"
	@printf "$(BLUE)new-module MODULE=<path/name>$(NC)\n"
	@printf "  → make new-module MODULE=hm/programs/terminal/alacritty\n"
	@printf "  → make new-module MODULE=system/services/backup\n\n"
	@printf "$(GREEN)═══ 📊 Diff & Compare ═══$(NC)\n"
	@printf "$(BLUE)compare-hosts HOST1=<a> HOST2=<b>$(NC)\n"
	@printf "  → make compare-hosts HOST1=hydenix HOST2=laptop\n"
	@printf "  → make compare-hosts HOST1=laptop HOST2=vm\n\n"
	@printf "$(GREEN)═══ 🔍 Build Analysis ═══$(NC)\n"
	@printf "$(BLUE)why-depends PKG=<name>$(NC)\n"
	@printf "  → make why-depends PKG=firefox\n"
	@printf "  → make why-depends PKG=systemd\n"
	@printf "  → make why-depends PKG=gcc\n\n"
	@printf "$(GREEN)═══ 📚 Common Commands (No parameters needed) ═══$(NC)\n"
	@printf "$(BLUE)Everyday use:$(NC)\n"
	@printf "  make switch         → Apply configuration\n"
	@printf "  make test           → Test without applying\n"
	@printf "  make rollback       → Undo last change\n"
	@printf "  make validate       → Check config before applying\n\n"
	@printf "$(BLUE)Information:$(NC)\n"
	@printf "  make status         → System overview\n"
	@printf "  make health         → Health check\n"
	@printf "  make version        → System versions\n"
	@printf "  make list-hosts     → Show available hosts\n"
	@printf "  make changelog      → Recent changes\n\n"
	@printf "$(BLUE)Maintenance:$(NC)\n"
	@printf "  make clean          → Clean old (30 days)\n"
	@printf "  make optimize       → Optimize store\n"
	@printf "  make generation-sizes → Show generation sizes\n"
	@printf "  make closure-size   → Show what uses space\n\n"
	@printf "$(BLUE)Troubleshooting:$(NC)\n"
	@printf "  make debug          → Debug rebuild\n"
	@printf "  make logs-errors    → Show errors\n"
	@printf "  make fix-permissions → Fix permission issues\n"
	@printf "  make fix-store      → Repair nix store\n\n"
	@printf "$(YELLOW)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n"
	@printf "$(YELLOW)For full command list:$(NC) make help\n"
	@printf "$(YELLOW)For workflows:$(NC) make help-advanced\n"
	@printf "$(YELLOW)For complete guide:$(NC) make tutorial\n"
	@printf "$(YELLOW)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)\n\n"

# === Building and Switching ===

rebuild: ## Full rebuild and switch (alias for switch)
	@printf "$(BLUE)🔄 Rebuilding NixOS configuration...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME)

switch: ## Build and switch to new configuration
	@printf "$(BLUE)🔄 Git add, Building and switching to new configuration...\n$(NC)"
	git add .
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME)

safe-switch: validate switch ## Validate then switch (safest option)

test: ## Build and test configuration (no switch)
	@printf "$(YELLOW)🧪 Testing configuration (no switch)...\n$(NC)"
	sudo nixos-rebuild test --flake $(FLAKE_DIR)#$(HOSTNAME)

build: ## Build configuration without switching
	@printf "$(BLUE)🔨 Building configuration...\n$(NC)"
	sudo nixos-rebuild build --flake $(FLAKE_DIR)#$(HOSTNAME)

dry-run: ## Show what would be built/changed
	@printf "$(CYAN)🔍 Dry run - showing what would change...\n$(NC)"
	sudo nixos-rebuild dry-run --flake $(FLAKE_DIR)#$(HOSTNAME)

boot: ## Build and set as boot default (no immediate switch)
	@printf "$(PURPLE)🥾 Setting configuration for next boot...\n$(NC)"
	sudo nixos-rebuild boot --flake $(FLAKE_DIR)#$(HOSTNAME)

# === Multi-Host Support ===

list-hosts: ## List available host configurations
	@printf "$(CYAN)📋 Available Hosts\n$(NC)"
	@printf "=================\n"
	@for host in $(AVAILABLE_HOSTS); do \
		printf "  $(GREEN)%-15s$(NC) " $$host; \
		if [ -d "hosts/$$host" ]; then \
			printf "✓ configured"; \
			if [ "$$host" = "$(HOSTNAME)" ]; then \
				printf " $(YELLOW)(current)$(NC)"; \
			fi; \
			printf "\n"; \
		else \
			printf "$(RED)✗ not found$(NC)\n"; \
		fi \
	done
	@printf "\n$(BLUE)Usage:$(NC) make switch HOSTNAME=<host>\n"
	@printf "$(BLUE)Example:$(NC) make switch HOSTNAME=laptop\n"

# === Validation ===

validate: ## Validate configuration before switching
	@printf "$(CYAN)🔍 Validation Checks\n$(NC)"
	@printf "===================\n\n"
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
			printf "$(YELLOW)⚠$(NC) (warnings found, see 'make lint')\n"; \
		fi \
	else \
		printf "$(YELLOW)⊘$(NC) (statix not installed)\n"; \
	fi
	@printf "\n$(GREEN)✅ Validation passed\n$(NC)"

health: ## Run comprehensive system health checks
	@printf "$(CYAN)🏥 System Health Check\n$(NC)"
	@printf "=====================\n\n"
	@printf "$(BLUE)1. Flake validation:$(NC) "
	@if nix flake check . >/dev/null 2>&1; then \
		printf "$(GREEN)✓ Passed$(NC)\n"; \
	else \
		printf "$(RED)✗ Failed$(NC)\n"; \
	fi
	@printf "$(BLUE)2. Store consistency:$(NC) "
	@if nix-store --verify --check-contents >/dev/null 2>&1; then \
		printf "$(GREEN)✓ Healthy$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠ Issues detected$(NC)\n"; \
	fi
	@printf "$(BLUE)3. Disk space (/nix):$(NC) "
	@df -h /nix 2>/dev/null | tail -1 | awk '{printf "%s used (%s free)\n", $$5, $$4}'
	@printf "$(BLUE)4. Generations count:$(NC) "
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | wc -l | awk '{print $$1 " generations"}'
	@printf "$(BLUE)5. Boot entries:$(NC) "
	@ls /boot/loader/entries/ 2>/dev/null | wc -l | awk '{print $$1 " entries"}' || printf "$(YELLOW)N/A$(NC)\n"
	@printf "$(BLUE)6. Failed services:$(NC) "
	@FAILED=$$(systemctl --failed --no-legend 2>/dev/null | wc -l); \
	if [ $$FAILED -eq 0 ]; then \
		printf "$(GREEN)✓ None$(NC)\n"; \
	else \
		printf "$(RED)✗ $$FAILED failed$(NC)\n"; \
		printf "$(YELLOW)  Run 'systemctl --failed' for details$(NC)\n"; \
	fi
	@printf "$(BLUE)7. Git status:$(NC) "
	@if git diff-index --quiet HEAD -- 2>/dev/null; then \
		printf "$(GREEN)✓ Clean$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠ Uncommitted changes$(NC)\n"; \
	fi
	@printf "\n$(GREEN)Health check complete$(NC)\n"

# === Network Tests ===

test-network: ## Run comprehensive network diagnostics
	@printf "$(CYAN)🌐 Network Diagnostics\n$(NC)"
	@printf "=====================\n\n"
	@printf "$(BLUE)1. DNS status (resolved):$(NC)\n"
	@resolvectl status 2>/dev/null | head -60 || printf "$(YELLOW)resolvectl not available$(NC)\n"
	@printf "\n$(BLUE)2. DNS from NetworkManager:$(NC)\n"
	@nmcli device show | grep -E "IP4.DNS|GENERAL.CONNECTION" || true
	@printf "\n$(BLUE)3. Ping (1.1.1.1):$(NC)\n"
	@ping -c 5 1.1.1.1
	@printf "\n$(BLUE)4. Ping (google.com):$(NC)\n"
	@ping -c 5 google.com
	@printf "\n$(BLUE)5. Throughput (Cloudflare 50MB, max 20s):$(NC)\n"
	@curl -L -o /dev/null --max-time 20 -w "Downloaded: %{size_download} bytes, Speed: %{speed_download} B/s, Total: %{time_total}s\n" \
		"https://speed.cloudflare.com/__down?bytes=50000000"
	@printf "\n$(BLUE)6. Speedtest (nearest):$(NC)\n"
	@nix run 'nixpkgs#speedtest-cli' -- --simple 2>/dev/null || printf "$(YELLOW)speedtest-cli failed or not available$(NC)\n"
	@printf "\n$(BLUE)7. Route quality (mtr to 1.1.1.1, 50 probes):$(NC)\n"
	@mtr -rw 1.1.1.1 -c 50 || printf "$(YELLOW)mtr not available$(NC)\n"
	@printf "\n$(GREEN)✅ Network diagnostics complete$(NC)\n"

# === Debugging ===

debug: ## Rebuild with verbose output and trace
	@printf "$(RED)🐛 Debug rebuild with full trace...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --show-trace --verbose

check-syntax: ## Check flake syntax without building
	@printf "$(CYAN)📋 Checking flake syntax...\n$(NC)"
	nix flake check $(FLAKE_DIR)

show: ## Show flake outputs
	@printf "$(CYAN)📄 Showing flake outputs...\n$(NC)"
	nix flake show $(FLAKE_DIR)

# === Maintenance and Cleanup ===

clean: ## Clean build artifacts older than 30 days
	@printf "$(YELLOW)🧹 Cleaning build artifacts older than 30 days...\n$(NC)"
	sudo nix-collect-garbage --delete-older-than 30d
	nix-collect-garbage --delete-older-than 30d
	@printf "$(GREEN)✅ Cleanup complete (kept last 30 days)\n$(NC)"

clean-week: ## Clean build artifacts older than 7 days
	@printf "$(YELLOW)🧹 Cleaning build artifacts older than 7 days...\n$(NC)"
	sudo nix-collect-garbage --delete-older-than 7d
	nix-collect-garbage --delete-older-than 7d
	@printf "$(GREEN)✅ Cleanup complete (kept last 7 days)\n$(NC)"

clean-conservative: ## Clean build artifacts older than 90 days (very safe)
	@printf "$(YELLOW)🧹 Conservative cleanup - removing items older than 90 days...\n$(NC)"
	sudo nix-collect-garbage --delete-older-than 90d
	nix-collect-garbage --delete-older-than 90d
	@printf "$(GREEN)✅ Conservative cleanup complete (kept last 90 days)\n$(NC)"

deep-clean: ## Aggressive cleanup (removes ALL old generations)
	@printf "$(RED)🗑️  Performing deep cleanup...\n$(NC)"
	@printf "$(YELLOW)⚠️  WARNING: This will remove ALL old system generations!\n$(NC)"
	@printf "$(YELLOW)This is irreversible and you won't be able to rollback!\n$(NC)"
	@printf "Type 'yes' to continue: "; \
	read -r REPLY; \
	if [ "$$REPLY" = "yes" ]; then \
		sudo nix-collect-garbage -d; \
		nix-collect-garbage -d; \
		printf "$(GREEN)✅ Deep cleanup complete (ALL generations removed)\n$(NC)"; \
	else \
		printf "$(BLUE)ℹ️  Deep cleanup cancelled\n$(NC)"; \
	fi

clean-generations: ## Remove system generations older than 14 days (keeps ability to rollback recent changes)
	@printf "$(YELLOW)🗑️  Removing system generations older than 14 days...\n$(NC)"
	@printf "$(BLUE)ℹ️  This keeps recent generations for rollback capability\n$(NC)"
	sudo nix-env --delete-generations --profile /nix/var/nix/profiles/system +14
	sudo nix-collect-garbage
	@printf "$(GREEN)✅ Old generations cleaned (kept last 14 days)\n$(NC)"

gc: ## Garbage collect (alias for clean)
	@make clean

optimize: ## Optimize nix store
	@printf "$(BLUE)🚀 Optimizing nix store...\n$(NC)"
	sudo nix-store --optimise
	@printf "$(GREEN)✅ Store optimization complete\n$(NC)"

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

# === Updates ===

update: ## Update flake inputs
	@printf "$(BLUE)📦 Updating flake inputs...\n$(NC)"
	nix flake update $(FLAKE_DIR)
	@printf "$(GREEN)✅ Flake inputs updated\n$(NC)"

update-nixpkgs: ## Update only nixpkgs input
	@printf "$(BLUE)📦 Updating nixpkgs...\n$(NC)"
	nix flake lock --update-input nixpkgs $(FLAKE_DIR)

update-hydenix: ## Update only hydenix input
	@printf "$(BLUE)📦 Updating hydenix...\n$(NC)"
	nix flake lock --update-input hydenix $(FLAKE_DIR)

update-input: ## Update specific flake input (use INPUT=name)
	@if [ -z "$(INPUT)" ]; then \
		printf "$(RED)Error: INPUT variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make update-input INPUT=hydenix$(NC)\n"; \
		printf "$(BLUE)Available inputs:$(NC)\n"; \
		printf "  - nixpkgs\n"; \
		printf "  - hydenix\n"; \
		printf "  - nixos-hardware\n"; \
		printf "  - mynixpkgs\n"; \
		printf "  - opencode\n"; \
		printf "  - zen-browser-flake\n"; \
		exit 1; \
	fi
	@printf "$(BLUE)📦 Updating input: $(INPUT)\n$(NC)"
	nix flake lock --update-input $(INPUT)
	@printf "$(GREEN)✅ Input '$(INPUT)' updated\n$(NC)"
	@printf "$(YELLOW)Run 'make diff-update' to see changes$(NC)\n"

update-info: ## Show current flake input information
	@printf "$(CYAN)📦 Current Flake Inputs\n$(NC)"
	@printf "======================\n"
	@nix flake metadata --json | \
		grep -E '"(url|lastModified)"' | \
		sed 's/"//g' | \
		sed 's/,//g' | \
		awk '{print $$1, $$2}'
	@printf "\n$(BLUE)To update:$(NC) make update\n"
	@printf "$(BLUE)To update specific input:$(NC) make update-input INPUT=<name>\n"

diff-update: ## Show changes in flake.lock after update
	@printf "$(CYAN)📊 Flake Lock Differences\n$(NC)"
	@printf "=========================\n"
	@if git diff --quiet flake.lock; then \
		printf "$(YELLOW)No changes in flake.lock\n$(NC)"; \
		printf "$(BLUE)Tip: Run 'make update' first\n$(NC)"; \
	else \
		git diff flake.lock; \
	fi

upgrade: ## Update and rebuild
	@printf "$(BLUE)🆙 Updating and rebuilding...\n$(NC)"
	@make update
	@make switch

# === Formatting and Linting ===

format: ## Format nix files
	@printf "$(CYAN)💅 Formatting nix files...\n$(NC)"
	@if command -v nixpkgs-fmt >/dev/null 2>&1; then \
		find . -name "*.nix" -not -path "*/.*" -exec nixpkgs-fmt {} \; ; \
		printf "$(GREEN)✅ Formatting complete\n$(NC)"; \
	elif command -v alejandra >/dev/null 2>&1; then \
		alejandra . ; \
		printf "$(GREEN)✅ Formatting complete (alejandra)\n$(NC)"; \
	else \
		printf "$(YELLOW)⚠️  No formatter found\n$(NC)"; \
		printf "$(BLUE)Install with: nix-shell -p nixpkgs-fmt\n$(NC)"; \
		printf "$(BLUE)Or use: nix fmt (if configured)\n$(NC)"; \
		exit 1; \
	fi

lint: ## Lint nix files (requires statix)
	@printf "$(CYAN)🔍 Linting nix files...\n$(NC)"
	@if command -v statix >/dev/null 2>&1; then \
		statix check . ; \
		if [ $$? -eq 0 ]; then \
			printf "$(GREEN)✅ Linting complete - no issues found\n$(NC)"; \
		else \
			printf "$(YELLOW)⚠️  Linting found issues (see above)\n$(NC)"; \
		fi \
	else \
		printf "$(YELLOW)⚠️  statix not found\n$(NC)"; \
		printf "$(BLUE)Install with: nix-shell -p statix\n$(NC)"; \
		printf "$(BLUE)Or run directly: nix run nixpkgs#statix check .\n$(NC)"; \
		exit 1; \
	fi

# === Backup and Restore ===

backup: ## Backup current configuration
	@printf "$(BLUE)💾 Backing up configuration...\n$(NC)"
	@mkdir -p $(BACKUP_DIR)
	@cp -r $(FLAKE_DIR) $(BACKUP_DIR)/backup-$(shell date +%Y%m%d-%H%M%S)
	@printf "$(GREEN)✅ Backup saved to $(BACKUP_DIR)\n$(NC)"

list-generations: ## List system generations
	@printf "$(CYAN)📋 System generations:\n$(NC)"
	sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

rollback: ## Rollback to previous generation
	@printf "$(YELLOW)⏪ Rolling back to previous generation...\n$(NC)"
	sudo nixos-rebuild switch --rollback

diff-generations: ## Compare current with previous generation
	@printf "$(CYAN)📊 Comparing Generations\n$(NC)"
	@printf "========================\n"
	@if command -v nix >/dev/null 2>&1 && nix store diff-closures --help >/dev/null 2>&1; then \
		CURRENT=$$(readlink /nix/var/nix/profiles/system); \
		PREVIOUS=$$(readlink /nix/var/nix/profiles/system-*-link 2>/dev/null | tail -2 | head -1); \
		if [ -n "$$PREVIOUS" ]; then \
			printf "$(BLUE)Previous → Current$(NC)\n"; \
			nix store diff-closures $$PREVIOUS $$CURRENT; \
		else \
			printf "$(YELLOW)No previous generation found$(NC)\n"; \
		fi \
	else \
		printf "$(YELLOW)nix store diff-closures not available$(NC)\n"; \
	fi

diff-gen: ## Compare two specific generations (use GEN1=N GEN2=M)
	@if [ -z "$(GEN1)" ] || [ -z "$(GEN2)" ]; then \
		printf "$(RED)Error: Specify both generations$(NC)\n"; \
		printf "$(YELLOW)Usage: make diff-gen GEN1=184 GEN2=186$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)📊 Comparing Generation $(GEN1) → $(GEN2)\n$(NC)"
	@GEN1_PATH=$$(ls /nix/var/nix/profiles/system-$(GEN1)-link 2>/dev/null); \
	GEN2_PATH=$$(ls /nix/var/nix/profiles/system-$(GEN2)-link 2>/dev/null); \
	if [ -n "$$GEN1_PATH" ] && [ -n "$$GEN2_PATH" ]; then \
		nix store diff-closures $$GEN1_PATH $$GEN2_PATH; \
	else \
		printf "$(RED)One or both generations not found$(NC)\n"; \
	fi

# === Git Integration (with GitHub CLI) ===

git-add: ## Stage all changes for git
	@printf "$(BLUE)📝 Staging changes...\n$(NC)"
	git add .

git-commit: ## Quick commit with timestamp
	@printf "$(BLUE)📝 Committing changes...\n$(NC)"
	git add .
	git commit -m "config: update $(shell date '+%Y-%m-%d %H:%M:%S')"

git-push: ## Push to remote using GitHub CLI
	@printf "$(BLUE)🚀 Pushing to remote...\n$(NC)"
	git push

git-status: ## Show git status with GitHub CLI
	@printf "$(CYAN)📊 Repository Status:\n$(NC)"
	@gh repo view --json nameWithOwner -q .nameWithOwner 2>/dev/null || printf "$(YELLOW)Not a GitHub repo$(NC)\n"
	@printf "\n$(BLUE)Local changes:\n$(NC)"
	@git status --short

save: ## Quick save: add, commit, push, and rebuild
	@printf "$(PURPLE)💾 Quick save: staging, committing, pushing, and rebuilding...\n$(NC)"
	@make git-add
	@make git-commit
	@make git-push
	@make switch

# === System Information ===

info: ## Show system information
	@printf "$(CYAN)💻 System Information\n$(NC)"
	@printf "===================\n"
	@printf "$(BLUE)Hostname:$(NC) $(HOSTNAME)\n"
	@printf "$(BLUE)NixOS Version:$(NC) $(shell nixos-version 2>/dev/null || echo 'N/A')\n"
	@printf "$(BLUE)Current Generation:$(NC) $(shell sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -1 || echo 'N/A')\n"
	@printf "$(BLUE)Flake Location:$(NC) $(PWD)\n"
	@printf "$(BLUE)Store Size:$(NC) $(shell du -sh /nix/store 2>/dev/null | cut -f1 || echo 'N/A')\n"

status: ## Show comprehensive system status
	@printf "$(CYAN)╔══════════════════════════════════════╗\n$(NC)"
	@printf "$(CYAN)║      SYSTEM STATUS OVERVIEW          ║\n$(NC)"
	@printf "$(CYAN)╚══════════════════════════════════════╝\n$(NC)"
	@printf "\n$(PURPLE)📍 Configuration$(NC)\n"
	@printf "├─ Host: $(HOSTNAME)\n"
	@printf "├─ Flake: $(PWD)\n"
	@printf "└─ NixOS: $$(nixos-version 2>/dev/null || echo 'N/A')\n"
	@printf "\n$(BLUE)📦 Git Status$(NC)\n"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "├─ Branch: $$(git branch --show-current)\n"; \
		printf "├─ Status: "; \
		if git diff-index --quiet HEAD -- 2>/dev/null; then \
			printf "$(GREEN)Clean$(NC)\n"; \
		else \
			printf "$(YELLOW)Uncommitted changes$(NC)\n"; \
		fi; \
		git status --short | head -5 | sed 's/^/│  /'; \
		printf "└─ Last 3 commits:\n"; \
		git log --oneline -3 | sed 's/^/   /'; \
	else \
		printf "$(YELLOW)Not a git repository$(NC)\n"; \
	fi
	@printf "\n$(BLUE)💾 System Info$(NC)\n"
	@printf "├─ Store size: $$(du -sh /nix/store 2>/dev/null | cut -f1 || echo 'N/A')\n"
	@printf "├─ Current gen: $$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -1 | awk '{print $$1}' || echo 'N/A')\n"
	@printf "├─ Total gens: $$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | wc -l || echo 'N/A')\n"
	@printf "└─ Disk usage: $$(df -h /nix 2>/dev/null | tail -1 | awk '{print $$5 " used"}' || echo 'N/A')\n"
	@printf "\n$(BLUE)🔄 Recent Generations$(NC)\n"
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null | tail -5 | sed 's/^/  /' || printf "  $(YELLOW)None$(NC)\n"
	@printf "\n"

# === Search and Discovery ===

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
	@nix-env -q | grep -i "$(PKG)" || printf "$(YELLOW)Not found in user environment$(NC)\n"
	@printf "\n$(BLUE)System packages:$(NC)\n"
	@nix-store -q --references /run/current-system | grep -i "$(PKG)" | head -20 || printf "$(YELLOW)Not found in system$(NC)\n"

# === Quick Actions ===

quick: ## Quick rebuild (skip checks)
	@printf "$(BLUE)⚡ Quick rebuild...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --fast

emergency: ## Emergency rebuild with maximum verbosity
	@printf "$(RED)🚨 Emergency rebuild with full debugging...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --show-trace --verbose --option eval-cache false

benchmark: ## Time the rebuild process (build only)
	@printf "$(BLUE)⏱️  Benchmarking Build Process\n$(NC)"
	@printf "================================\n"
	@printf "$(YELLOW)Starting benchmark...\n$(NC)"
	@START=$$(date +%s); \
	sudo nixos-rebuild build --flake $(FLAKE_DIR)#$(HOSTNAME); \
	END=$$(date +%s); \
	DURATION=$$((END - START)); \
	printf "\n$(GREEN)✅ Benchmark Complete\n$(NC)"; \
	printf "$(CYAN)Total time: $${DURATION}s ($$((DURATION / 60))m $$((DURATION % 60))s)\n$(NC)"

# === Hardware ===

hardware-scan: ## Re-scan hardware configuration
	@printf "$(BLUE)🔧 Scanning hardware configuration for $(HOSTNAME)...\n$(NC)"
	@sudo nixos-generate-config --show-hardware-config > hosts/$(HOSTNAME)/hardware-configuration-new.nix
	@printf "$(YELLOW)New hardware config saved as:\n$(NC)"
	@printf "  hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To review differences:\n$(NC)"
	@printf "  diff hosts/$(HOSTNAME)/hardware-configuration.nix hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To apply:\n$(NC)"
	@printf "  mv hosts/$(HOSTNAME)/hardware-configuration-new.nix hosts/$(HOSTNAME)/hardware-configuration.nix\n"

# === Monitoring ===

watch-logs: ## Watch system logs during rebuild
	@printf "$(CYAN)📊 Watching system logs...\n$(NC)"
	journalctl -f

watch-rebuild: ## Watch rebuild process
	watch -n 1 'sudo nixos-rebuild switch --flake . --dry-run | tail -20'

# === Advanced ===

repl: ## Start nix repl with flake
	@printf "$(CYAN)🧠 Starting nix repl...\n$(NC)"
	nix repl --extra-experimental-features repl-flake $(FLAKE_DIR)

shell: ## Enter development shell
	@printf "$(CYAN)🐚 Entering development shell...\n$(NC)"
	nix develop $(FLAKE_DIR)

vm: ## Build and run VM
	@printf "$(BLUE)🖥️  Building VM...\n$(NC)"
	nix build .#vm
	@printf "$(GREEN)✅ VM built successfully\n$(NC)"
	@printf "$(CYAN)Starting VM...\n$(NC)"
	./result/bin/run-nixos-vm

# === Changelog and History ===

changelog: ## Show recent changes from git log
	@printf "$(CYAN)📝 Recent Changes\n$(NC)"
	@printf "================\n\n"
	@git log --pretty=format:"$(GREEN)%h$(NC) - %s $(BLUE)(%ar by %an)$(NC)" --max-count=20 2>/dev/null || \
		printf "$(YELLOW)Not a git repository$(NC)\n"

changelog-detailed: ## Show detailed changelog with diffs
	@printf "$(CYAN)📝 Detailed Changelog (Last 10 commits)\n$(NC)"
	@printf "======================================\n\n"
	@git log --pretty=format:"$(GREEN)%h$(NC) - %s%n$(BLUE)Date: %ad | Author: %an$(NC)%n" \
		--date=short --max-count=10 2>/dev/null || \
		printf "$(YELLOW)Not a git repository$(NC)\n"

# === Package Information ===

packages: ## List all installed packages
	@printf "$(CYAN)📦 Installed Packages\n$(NC)"
	@printf "====================\n\n"
	@printf "$(BLUE)User packages:$(NC)\n"
	@nix-env -q | sort | sed 's/^/  /' || printf "  $(YELLOW)None$(NC)\n"
	@printf "\n$(BLUE)System packages (count):$(NC) "
	@nix-store -q --references /run/current-system | wc -l
	@printf "\n$(YELLOW)Tip: Use 'make search-installed PKG=name' to find specific package$(NC)\n"

version: ## Show NixOS and flake versions
	@printf "$(CYAN)📌 Version Information\n$(NC)"
	@printf "=====================\n"
	@printf "$(BLUE)NixOS:$(NC) $$(nixos-version 2>/dev/null || echo 'N/A')\n"
	@printf "$(BLUE)Nix:$(NC) $$(nix --version 2>/dev/null || echo 'N/A')\n"
	@printf "$(BLUE)Hostname:$(NC) $(HOSTNAME)\n"
	@printf "$(BLUE)System:$(NC) $$(uname -sm)\n"
	@printf "\n$(BLUE)Flake inputs versions:$(NC)\n"
	@nix flake metadata --json 2>/dev/null | \
		grep -o '"lastModified":[0-9]*' | \
		head -5 || printf "  $(YELLOW)Unable to read$(NC)\n"

current-generation: ## Show current generation details
	@printf "$(CYAN)📍 Current Generation\n$(NC)"
	@printf "====================\n"
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1
	@printf "\n$(BLUE)Activation date:$(NC) "
	@stat -c %y /run/current-system 2>/dev/null | cut -d'.' -f1 || echo "N/A"
	@printf "$(BLUE)Closure size:$(NC) "
	@nix path-info -Sh /run/current-system 2>/dev/null | awk '{print $$2}' || echo "N/A"

hosts-info: ## Show info about all configured hosts
	@printf "$(CYAN)📋 Configured Hosts\n$(NC)"
	@printf "===================\n"
	@for host in $(AVAILABLE_HOSTS); do \
		printf "\n$(GREEN)$${host}$(NC)"; \
		if [ "$$host" = "$(HOSTNAME)" ]; then \
			printf " $(YELLOW)(current)$(NC)"; \
		fi; \
		printf "\n"; \
		if [ -f "hosts/$$host/configuration.nix" ]; then \
			printf "  Status: $(GREEN)✓$(NC) configured\n"; \
			printf "  Path: hosts/$$host/\n"; \
			printf "  Files: "; \
			ls hosts/$$host/ 2>/dev/null | wc -l; \
		else \
			printf "  Status: $(RED)✗$(NC) not found\n"; \
		fi; \
	done

# === Logs and Monitoring ===

logs-boot: ## Show boot logs
	@printf "$(CYAN)📋 Boot Logs\n$(NC)"
	@printf "===========\n"
	@journalctl -b -p err..alert --no-pager | tail -50

logs-errors: ## Show recent error logs
	@printf "$(CYAN)📋 Recent Errors\n$(NC)"
	@printf "===============\n"
	@journalctl -p err -n 50 --no-pager

logs-service: ## Show logs for specific service (use SVC=name)
	@if [ -z "$(SVC)" ]; then \
		printf "$(RED)Error: SVC variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make logs-service SVC=sshd$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)📋 Logs for service: $(SVC)\n$(NC)"
	@journalctl -u $(SVC) -n 100 --no-pager

# === Export and Import ===

export-config: ## Export configuration to timestamped tarball
	@printf "$(BLUE)📦 Exporting configuration...\n$(NC)"
	@EXPORT_NAME="nixos-config-$$(date +%Y%m%d-%H%M%S).tar.gz"; \
	tar -czf $$EXPORT_NAME \
		--exclude='.git' \
		--exclude='result' \
		--exclude='*.tar.gz' \
		--exclude='.direnv' \
		. ; \
	printf "$(GREEN)✅ Exported to: $$EXPORT_NAME\n$(NC)"; \
	printf "$(BLUE)Size: $$(du -h $$EXPORT_NAME | cut -f1)\n$(NC)"

export-minimal: ## Export only essential files (flake.nix, hosts/, modules/)
	@printf "$(BLUE)📦 Exporting minimal configuration...\n$(NC)"
	@EXPORT_NAME="nixos-config-minimal-$$(date +%Y%m%d).tar.gz"; \
	tar -czf $$EXPORT_NAME \
		flake.nix \
		flake.lock \
		hosts/ \
		modules/ \
		Makefile \
		README.md 2>/dev/null; \
	printf "$(GREEN)✅ Minimal config exported to: $$EXPORT_NAME\n$(NC)"; \
	printf "$(BLUE)Size: $$(du -h $$EXPORT_NAME | cut -f1)\n$(NC)"

# === Documentation ===

docs-local: ## Show local documentation files
	@printf "$(CYAN)📚 Local Documentation\n$(NC)"
	@printf "=====================\n"
	@if [ -f "README.md" ]; then printf "  $(GREEN)✓$(NC) README.md\n"; fi
	@if [ -f "MAKEFILE_TUTORIAL.md" ]; then printf "  $(GREEN)✓$(NC) MAKEFILE_TUTORIAL.md\n"; fi
	@if [ -f "MAKEFILE_IMPROVEMENTS_PLAN.md" ]; then printf "  $(GREEN)✓$(NC) MAKEFILE_IMPROVEMENTS_PLAN.md\n"; fi
	@if [ -f "AGENTS.md" ]; then printf "  $(GREEN)✓$(NC) AGENTS.md\n"; fi
	@if [ -d "docs/" ]; then \
		printf "  $(GREEN)✓$(NC) docs/\n"; \
		ls docs/*.md 2>/dev/null | sed 's/^/    /'; \
	fi
	@printf "\n$(BLUE)View with:$(NC) less <file> or cat <file>\n"

readme: ## Show README in terminal
	@if [ -f "README.md" ]; then \
		less README.md; \
	else \
		printf "$(YELLOW)README.md not found$(NC)\n"; \
	fi

tutorial: ## Show Makefile tutorial
	@if [ -f "MAKEFILE_TUTORIAL.md" ]; then \
		less MAKEFILE_TUTORIAL.md; \
	else \
		printf "$(YELLOW)MAKEFILE_TUTORIAL.md not found$(NC)\n"; \
	fi

# === Configuration Templates ===

new-host: ## Create new host configuration template (use HOST=name)
	@if [ -z "$(HOST)" ]; then \
		printf "$(RED)Error: HOST variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make new-host HOST=mylaptop$(NC)\n"; \
		exit 1; \
	fi
	@if [ -d "hosts/$(HOST)" ]; then \
		printf "$(RED)Error: Host '$(HOST)' already exists$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(BLUE)📝 Creating host configuration: $(HOST)\n$(NC)"
	@mkdir -p hosts/$(HOST)
	@printf "# Configuration for $(HOST)\n{ inputs, ... }: {\n  imports = [ ../default.nix ];\n\n  networking.hostName = \"$(HOST)\";\n}\n" \
		> hosts/$(HOST)/configuration.nix
	@printf "# User configuration for $(HOST)\n{ inputs, ... }: {\n  # Add user-specific config here\n}\n" \
		> hosts/$(HOST)/user.nix
	@printf "$(GREEN)✅ Host template created at: hosts/$(HOST)/$(NC)\n"
	@printf "$(YELLOW)Remember to:$(NC)\n"
	@printf "  1. Run: sudo nixos-generate-config --show-hardware-config > hosts/$(HOST)/hardware-configuration.nix\n"
	@printf "  2. Add to flake.nix outputs\n"
	@printf "  3. Update AVAILABLE_HOSTS in Makefile\n"

new-module: ## Create new module template (use MODULE=path/name)
	@if [ -z "$(MODULE)" ]; then \
		printf "$(RED)Error: MODULE variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make new-module MODULE=hm/programs/terminal/alacritty$(NC)\n"; \
		exit 1; \
	fi
	@MODULE_PATH="modules/$(MODULE).nix"; \
	if [ -f "$$MODULE_PATH" ]; then \
		printf "$(RED)Error: Module already exists: $$MODULE_PATH$(NC)\n"; \
		exit 1; \
	fi; \
	mkdir -p "$$(dirname $$MODULE_PATH)"; \
	printf "# Module: $(MODULE)\n{ config, lib, pkgs, ... }:\n\n{\n  # Add your configuration here\n}\n" \
		> "$$MODULE_PATH"; \
	printf "$(GREEN)✅ Module created: $$MODULE_PATH$(NC)\n"; \
	printf "$(YELLOW)Remember to import it in the appropriate default.nix$(NC)\n"

# === Diff Tools ===

diff-config: ## Show uncommitted changes to .nix files
	@printf "$(CYAN)📊 Configuration Changes\n$(NC)"
	@printf "=======================\n"
	@if git diff --quiet -- '*.nix'; then \
		printf "$(GREEN)No changes to .nix files$(NC)\n"; \
	else \
		git diff --stat -- '*.nix'; \
		printf "\n$(BLUE)Detailed diff:$(NC)\n"; \
		git diff -- '*.nix'; \
	fi

diff-flake: ## Show changes to flake.nix and flake.lock
	@printf "$(CYAN)📊 Flake Changes\n$(NC)"
	@printf "===============\n"
	@git diff flake.nix flake.lock || printf "$(GREEN)No changes$(NC)\n"

compare-hosts: ## Compare two host configurations (use HOST1=a HOST2=b)
	@if [ -z "$(HOST1)" ] || [ -z "$(HOST2)" ]; then \
		printf "$(RED)Error: Both HOST1 and HOST2 required$(NC)\n"; \
		printf "$(YELLOW)Usage: make compare-hosts HOST1=hydenix HOST2=laptop$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)📊 Comparing $(HOST1) vs $(HOST2)\n$(NC)"
	@printf "=====================================\n"
	@diff -u hosts/$(HOST1)/configuration.nix hosts/$(HOST2)/configuration.nix || true

# === Build Analysis ===

why-depends: ## Show why system depends on a package (use PKG=name)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)Error: PKG variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make why-depends PKG=firefox$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)🔍 Dependency Chain for: $(PKG)\n$(NC)"
	@printf "================================\n"
	@PKG_PATH=$$(nix-store -q --references /run/current-system | grep -i "$(PKG)" | head -1); \
	if [ -n "$$PKG_PATH" ]; then \
		nix why-depends /run/current-system $$PKG_PATH; \
	else \
		printf "$(YELLOW)Package not found in current system$(NC)\n"; \
		printf "$(BLUE)Searching in store...$(NC)\n"; \
		nix-store -q --references /run/current-system | grep -i "$(PKG)" | head -5; \
	fi

build-trace: ## Show what would be built with full derivation info
	@printf "$(CYAN)🔨 Build Trace\n$(NC)"
	@printf "=============\n"
	@nix build .#nixosConfigurations.$(HOSTNAME).config.system.build.toplevel --dry-run --show-trace 2>&1 | \
		grep -E "(will be built|will be fetched|evaluating)" | \
		head -50

closure-size: ## Show closure size of current system
	@printf "$(CYAN)📊 System Closure Size\n$(NC)"
	@printf "======================\n"
	@nix path-info -Sh /run/current-system | head -1
	@printf "\n$(BLUE)Top 10 largest packages:$(NC)\n"
	@nix path-info -rSh /run/current-system | \
		sort -k2 -h | \
		tail -10 | \
		awk '{printf "  %8s  %s\n", $$2, $$1}'

# === Quick Fixes ===

fix-permissions: ## Fix common permission issues
	@printf "$(CYAN)🔧 Fixing Permissions\n$(NC)"
	@printf "====================\n"
	@printf "$(YELLOW)This requires sudo...$(NC)\n"
	@sudo chown -R $$USER:users ~/.config 2>/dev/null || true
	@sudo chown -R $$USER:users ~/.local 2>/dev/null || true
	@printf "$(GREEN)✅ Permissions fixed$(NC)\n"

fix-store: ## Attempt to repair nix store
	@printf "$(CYAN)🔧 Repairing Nix Store\n$(NC)"
	@printf "=====================\n"
	@printf "$(YELLOW)This will verify and repair the store...$(NC)\n"
	@nix-store --verify --check-contents --repair
	@printf "$(GREEN)✅ Store repair complete\n$(NC)"

# === Utilities ===

clean-result: ## Remove result symlinks
	@printf "$(CYAN)🧹 Cleaning result symlinks\n$(NC)"
	@find . -maxdepth 2 -name 'result*' -type l -delete 2>/dev/null || true
	@printf "$(GREEN)✅ Result symlinks removed\n$(NC)"

tree: ## Show configuration structure
	@printf "$(CYAN)📁 Configuration Structure\n$(NC)"
	@printf "=========================\n"
	@if command -v tree >/dev/null 2>&1; then \
		tree -L 3 -I '.git|result|*.tar.gz' --dirsfirst; \
	else \
		find . -type d -not -path '*/\.*' -not -path '*/result*' | \
			head -50 | \
			sed 's|[^/]*/| |g'; \
	fi

# === Migration Helpers ===

progress: ## Show migration progress from AGENTS.md
	@printf "$(CYAN)📊 Migration Progress:\n$(NC)"
	@grep -A 7 "## 📊 Métricas de Progreso" AGENTS.md || printf "AGENTS.md not found\n"

phases: ## Show current phase tasks
	@printf "$(CYAN)📋 Current Phase Tasks:\n$(NC)"
	@grep -A 20 "### 🔄" AGENTS.md | head -25 || printf "No current phase found\n"
