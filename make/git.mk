# ============================================================================
# Git y Respaldo
# ============================================================================
# Descripción: Targets para operaciones de git, commits y respaldo
# Targets: 6 targets
# ============================================================================

.PHONY: git-add git-commit git-push git-status git-diff git-log

# === Git y Publicación ===

git-add: ## Stage all changes for git
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              📝 Staging Changes                   $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Adding all changes to staging area...$(NC)\n"
	@git add .
	@CHANGED=$$(git status --short | wc -l); \
	if [ $$CHANGED -gt 0 ]; then \
		printf "$(GREEN)✅ Staged $$CHANGED file(s)$(NC)\n"; \
		printf "\n$(BLUE)Changes staged:$(NC)\n"; \
		git status --short | sed 's/^/  /'; \
	else \
		printf "$(YELLOW)⚠ No changes to stage$(NC)\n"; \
	fi
	@printf "\n"

git-commit: ## Quick commit with timestamp
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Committing Changes                  $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Staging changes...$(NC)\n"
	@git add .
	@COMMIT_MSG="config: update $$(date '+%Y-%m-%d %H:%M:%S')"; \
	printf "$(BLUE)Creating commit:$(NC) $(GREEN)$$COMMIT_MSG$(NC)\n\n"; \
	git commit -m "$$COMMIT_MSG" || exit 1; \
	COMMIT_HASH=$$(git rev-parse --short HEAD); \
	BRANCH=$$(git branch --show-current); \
	printf "\n$(GREEN)✅ Commit created successfully$(NC)\n"; \
	printf "$(BLUE)Hash:$(NC) $(GREEN)$$COMMIT_HASH$(NC)\n"; \
	printf "$(BLUE)Branch:$(NC) $(GREEN)$$BRANCH$(NC)\n"
	@printf "\n"

git-push: ## Push to remote using GitHub CLI
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              🚀 Pushing to Remote                 $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@BRANCH=$$(git branch --show-current); \
	REMOTE=$$(git remote get-url origin 2>/dev/null | sed -E 's|.*github.com[:/]([^/]+/[^/]+)(\.git)?$$|\1|' | sed 's|\.git$$||'); \
	printf "\n$(BLUE)Branch:$(NC) $(GREEN)$$BRANCH$(NC)\n"; \
	printf "$(BLUE)Remote:$(NC) $(GREEN)$$REMOTE$(NC)\n\n"; \
	printf "$(BLUE)Pushing changes...$(NC)\n"
	@git push || exit 1
	@printf "\n$(GREEN)✅ Successfully pushed to remote$(NC)\n"
	@printf "\n"

git-status: ## Show git status with GitHub CLI
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)           📊 Repository Status                    $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(PURPLE)📍 Configuration$(NC)\n"
	@printf "├─ Host: $(HOSTNAME)\n"
	@printf "├─ Flake: $(PWD)\n"
	@printf "└─ NixOS: $$(nixos-version 2>/dev/null | cut -d' ' -f1 || echo 'N/A')\n"
	@printf "\n$(BLUE)📦 Git Status$(NC)\n"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "├─ Repository: "; \
		REMOTE_URL=$$(git remote get-url origin 2>/dev/null); \
		if [ -n "$$REMOTE_URL" ]; then \
			REPO_NAME=$$(echo "$$REMOTE_URL" | sed -E 's|.*github.com[:/]([^/]+/[^/]+)(\.git)?$$|\1|' | sed 's|\.git$$||'); \
			if [ -n "$$REPO_NAME" ]; then \
				printf "$$REPO_NAME\n"; \
			else \
				printf "$$REMOTE_URL\n"; \
			fi; \
		else \
			printf "$(YELLOW)No remote configured$(NC)\n"; \
		fi; \
		printf "├─ Branch: $$(git branch --show-current)\n"; \
		printf "├─ Status: "; \
		if git diff-index --quiet HEAD -- 2>/dev/null; then \
			printf "$(GREEN)Clean$(NC)\n"; \
		else \
			printf "$(YELLOW)Uncommitted changes$(NC)\n"; \
		fi; \
		printf "\n$(BLUE)Local changes:$(NC)\n"; \
		git status --short; \
	else \
		printf "$(YELLOW)Not a git repository$(NC)\n"; \
	fi
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Recent Changes                      $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "\n"; \
		git log --max-count=3 --pretty=format:"  %C(green)%h%C(reset)  %<(58,trunc)%s  %C(blue)%<(15)%ar%C(reset)" 2>/dev/null; \
	fi
	@printf "\n"

git-diff: ## Show uncommitted changes to .nix configuration files
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Configuration Changes                  $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@if git diff --quiet -- '*.nix' 2>/dev/null; then \
		printf "\n$(GREEN)✅ No uncommitted changes to .nix files$(NC)\n"; \
		printf "$(BLUE)All configuration files are clean.$(NC)\n"; \
	else \
		printf "\n$(BLUE)📝 Uncommitted changes in .nix files:$(NC)\n\n"; \
		CHANGED_FILES=$$(git diff --name-only -- '*.nix' 2>/dev/null | wc -l); \
		ADDED_LINES=$$(git diff --numstat -- '*.nix' 2>/dev/null | awk '{sum+=$$1} END {print sum+0}'); \
		DELETED_LINES=$$(git diff --numstat -- '*.nix' 2>/dev/null | awk '{sum+=$$2} END {print sum+0}'); \
		printf "$(PURPLE)Summary:$(NC)\n"; \
		printf "├─ $(BLUE)Files changed:$(NC) $(GREEN)$$CHANGED_FILES$(NC)\n"; \
		if [ -n "$$ADDED_LINES" ] && [ "$$ADDED_LINES" != "0" ]; then \
			printf "├─ $(BLUE)Lines added:$(NC) $(GREEN)+$$ADDED_LINES$(NC)\n"; \
		fi; \
		if [ -n "$$DELETED_LINES" ] && [ "$$DELETED_LINES" != "0" ]; then \
			printf "└─ $(BLUE)Lines deleted:$(NC) $(RED)-$$DELETED_LINES$(NC)\n"; \
		fi; \
		printf "\n$(BLUE)📋 File changes:$(NC)\n"; \
		git diff --stat --color=always -- '*.nix' 2>/dev/null || git diff --stat -- '*.nix'; \
		printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(CYAN)          📄 Detailed Diff                         \n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)\n"; \
		git diff --color=always -- '*.nix' 2>/dev/null || git diff -- '*.nix'; \
	fi
	@printf "\n"

git-log: ## Show recent changes from git log
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Recent Changes                      $(NC)"
	@printf "\n$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "\n"; \
		git log --max-count=15 --pretty=format:"  %C(green)%h%C(reset)  %<(58,trunc)%s  %C(blue)%<(15)%ar%C(reset)" 2>/dev/null; \
	else \
		printf "\n$(YELLOW)Not a git repository$(NC)\n"; \
	fi
	@printf "\n"
