# NixOS Management Makefile
# Place this in your flake directory (where flake.nix is located)

.PHONY: help rebuild switch test build clean gc update check format lint backup restore

# Default target
.DEFAULT_GOAL := help

# Configuration
FLAKE_DIR := .
HOSTNAME := hydenix
BACKUP_DIR := ~/nixos-backups

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
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ { printf "$(GREEN)%-15s$(NC) %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

# === Building and Switching ===

rebuild: ## Full rebuild and switch (alias for switch)
	@printf "$(BLUE)🔄 Rebuilding NixOS configuration...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME)

switch: ## Build and switch to new configuration
	@printf "$(BLUE)🔄 Git add, Building and switching to new configuration...\n$(NC)"
	git add .
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME)

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
	@read -p "Are you absolutely sure? Type 'yes' to continue: " -r; \
	printf "\n"; \
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

upgrade: ## Update and rebuild
	@printf "$(BLUE)🆙 Updating and rebuilding...\n$(NC)"
	@make update
	@make switch

# === Formatting and Linting ===

format: ## Format nix files
	@printf "$(CYAN)💅 Formatting nix files...\n$(NC)"
	find . -name "*.nix" -not -path "*/.*" -exec nixpkgs-fmt {} \;
	@printf "$(GREEN)✅ Formatting complete\n$(NC)"

lint: ## Lint nix files
	@printf "$(CYAN)🔍 Linting nix files...\n$(NC)"
	find . -name "*.nix" -not -path "*/.*" -exec statix check {} \; || printf "$(YELLOW)Note: Install 'statix' for linting\n$(NC)"

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
	@gh repo view --json nameWithOwner -q .nameWithOwner
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

status: ## Show git and system status
	@printf "$(CYAN)📊 Status Overview\n$(NC)"
	@printf "==================\n"
	@printf "$(BLUE)Git Status:\n$(NC)"
	@git status --short || printf "Not a git repository\n"
	@printf "\n$(BLUE)Uncommitted Changes:\n$(NC)"
	@git diff --name-only || printf "Not a git repository\n"
	@printf "\n"
	@make info

# === Quick Actions ===

quick: ## Quick rebuild (skip checks)
	@printf "$(BLUE)⚡ Quick rebuild...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --fast

emergency: ## Emergency rebuild with maximum verbosity
	@printf "$(RED)🚨 Emergency rebuild with full debugging...\n$(NC)"
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME) --show-trace --verbose --option eval-cache false

# === Hardware ===

hardware-scan: ## Re-scan hardware configuration
	@printf "$(BLUE)🔧 Scanning hardware configuration...\n$(NC)"
	sudo nixos-generate-config --show-hardware-config > hardware-configuration-new.nix
	@printf "$(YELLOW)New hardware config saved as hardware-configuration-new.nix\n$(NC)"
	@printf "$(YELLOW)Review and replace hardware-configuration.nix if needed\n$(NC)"

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

vm: ## Build and run VM (if configured)
	@printf "$(BLUE)🖥️  Building and starting VM...\n$(NC)"
	nixos-rebuild build-vm --flake $(FLAKE_DIR)#$(HOSTNAME)
	./result/bin/run-*-vm

# === Migration Helpers ===

progress: ## Show migration progress from AGENTS.md
	@printf "$(CYAN)📊 Migration Progress:\n$(NC)"
	@grep -A 7 "## 📊 Métricas de Progreso" AGENTS.md || printf "AGENTS.md not found\n"

phases: ## Show current phase tasks
	@printf "$(CYAN)📋 Current Phase Tasks:\n$(NC)"
	@grep -A 20 "### 🔄" AGENTS.md | head -25 || printf "No current phase found\n"

