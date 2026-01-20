# ============================================================================
# Git y Respaldo
# ============================================================================
# Descripción: Targets para operaciones de git, commits y respaldo
# Targets: 7 targets
# ============================================================================

.PHONY: git-add git-commit git-push git-status git-diff sync git-log

# === Git y Respaldo ===

git-add: ## Stage all changes for git
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              📝 Staging Changes                   \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
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
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Committing Changes                  \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
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
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              🚀 Pushing to Remote                 \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@BRANCH=$$(git branch --show-current); \
	REMOTE=$$(git remote get-url origin 2>/dev/null | sed -E 's|.*github.com[:/]([^/]+/[^/]+)(\.git)?$$|\1|' | sed 's|\.git$$||'); \
	printf "\n$(BLUE)Branch:$(NC) $(GREEN)$$BRANCH$(NC)\n"; \
	printf "$(BLUE)Remote:$(NC) $(GREEN)$$REMOTE$(NC)\n\n"; \
	printf "$(BLUE)Pushing changes...$(NC)\n"
	@git push || exit 1
	@printf "\n$(GREEN)✅ Successfully pushed to remote$(NC)\n"
	@printf "\n"

# Show comprehensive git status with repository information
# Displays branch, remote, uncommitted changes, and recent commits
git-status: ## Show git status with GitHub CLI
	@printf "$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)           📊 Repository Status                    \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
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
	@printf "\n$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Recent Changes                      \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "\n"; \
		git log --max-count=3 --pretty=format:"%h|%s|%ar%n" 2>/dev/null | \
		while IFS='|' read -r hash subject time; do \
			[ -z "$$hash" ] && continue; \
			SUBJECT_SHORT=$$(echo "$$subject" | cut -c1-55); \
			if [ "$${#subject}" -gt 55 ]; then \
				SUBJECT_SHORT="$$SUBJECT_SHORT..."; \
			fi; \
			printf "  $(GREEN)%-8s$(NC)  %-58s$(BLUE)%15s$(NC)\n" "$$hash" "$$SUBJECT_SHORT" "$$time"; \
		done; \
	fi
	@printf "\n"

# Complete workflow: stage, commit, push, and switch to new configuration
# Automated sequence that performs all git operations and applies changes
sync: ## Total synchronization: add, commit, push, and switch
	@printf "$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)              🔄 Total Synchronization              \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(PURPLE)Executing complete sync workflow:$(NC)\n"
	@printf "  1. Stage changes (git add)\n"
	@printf "  2. Commit changes (timestamped)\n"
	@printf "  3. Push to remote (git push)\n"
	@printf "  4. Build and switch (nixos-rebuild)\n"
	@printf "\n"
	@$(MAKE) --no-print-directory git-add
	@$(MAKE) --no-print-directory git-commit
	@$(MAKE) --no-print-directory git-push
	@$(MAKE) --no-print-directory switch
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Synchronization completed successfully!$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Show detailed diff of uncommitted changes to .nix configuration files
# Displays additions, deletions, and affected files with statistics
git-diff: ## Show uncommitted changes to .nix configuration files
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Configuration Changes                  \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
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

# === Reportes y Exportación ===

git-log: ## Show recent changes from git log
	@printf "$(CYAN) ════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📝 Recent Changes                      \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@if git rev-parse --git-dir > /dev/null 2>&1; then \
		printf "\n"; \
		git log --max-count=15 --pretty=format:"%h|%s|%ar" 2>/dev/null | \
		while IFS='|' read -r hash subject time; do \
			SUBJECT_SHORT=$$(echo "$$subject" | cut -c1-55); \
			if [ "$${#subject}" -gt 55 ]; then \
				SUBJECT_SHORT="$$SUBJECT_SHORT..."; \
			fi; \
			printf "  $(GREEN)%-8s$(NC)  %-58s$(BLUE)%15s$(NC)\n" "$$hash" "$$SUBJECT_SHORT" "$$time"; \
		done; \
	else \
		printf "\n$(YELLOW)Not a git repository$(NC)\n"; \
	fi
	@printf "\n"
