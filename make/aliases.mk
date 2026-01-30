# ============================================================================
# Aliases de Compatibilidad (Legacy)
# ============================================================================
# Descripción: Redirecciones de comandos antiguos a la nueva nomenclatura
# Estos comandos se mantienen por compatibilidad pero están marcados como 
# obsoletos (deprecated). Se recomienda usar los nuevos prefijos.
# ============================================================================

.PHONY: switch switch-safe switch-fast test build dry-run boot validate debug emergency \
        fix-permissions hardware-scan sync deploy clean deep-clean update update-nixpkgs \
        update-hydenix update-dots update-input flake-diff upgrade show flake-check generations \
        rollback diff-gens diff-current gen-size health status test-network watch-logs \
        logs-service boot-logs error-logs hosts search search-inst repl shell vm closure-size \
        format lint tree diff-config docs-local docs-dev docs-build docs-install docs-clean \
        help-aliases

# === Ayuda de Aliases ===
help-aliases: ## Show list of legacy aliases and their modern equivalents
	@printf "\n"
	@printf "$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)      Legacy Aliases & Modern Equivalents          $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(YELLOW)Estos comandos se mantienen por compatibilidad.$(NC)\n"
	@printf "$(YELLOW)Se recomienda usar la nueva nomenclatura.$(NC)\n\n"
	@printf "$(BLUE)%-20s %-25s %s$(NC)\n" "LEGACY ALIAS" "MODERN COMMAND" "CATEGORY"
	@printf "$(CYAN)%-20s %-25s %s$(NC)\n" "------------" "--------------" "--------"
	@printf "%-20s %-25s %s\n" "switch" "sys-apply" "System"
	@printf "%-20s %-25s %s\n" "switch-safe" "sys-apply-safe" "System"
	@printf "%-20s %-25s %s\n" "switch-fast" "sys-apply-fast" "System"
	@printf "%-20s %-25s %s\n" "test" "sys-test" "System"
	@printf "%-20s %-25s %s\n" "build" "sys-build" "System"
	@printf "%-20s %-25s %s\n" "dry-run" "sys-dry-run" "System"
	@printf "%-20s %-25s %s\n" "boot" "sys-boot" "System"
	@printf "%-20s %-25s %s\n" "validate" "sys-check" "System"
	@printf "%-20s %-25s %s\n" "debug" "sys-debug" "System"
	@printf "%-20s %-25s %s\n" "emergency" "sys-force" "System"
	@printf "%-20s %-25s %s\n" "fix-permissions" "sys-doctor" "System"
	@printf "%-20s %-25s %s\n" "hardware-scan" "sys-hw-scan" "System"
	@printf "%-20s %-25s %s\n" "sync/deploy" "sys-deploy" "Deployment"
	@printf "%-20s %-25s %s\n" "clean" "sys-gc" "Cleanup"
	@printf "%-20s %-25s %s\n" "deep-clean" "sys-purge" "Cleanup"
	@printf "%-20s %-25s %s\n" "update" "upd-all" "Updates"
	@printf "%-20s %-25s %s\n" "update-nixpkgs" "upd-nixpkgs" "Updates"
	@printf "%-20s %-25s %s\n" "update-hydenix" "upd-hydenix" "Updates"
	@printf "%-20s %-25s %s\n" "update-input" "upd-input" "Updates"
	@printf "%-20s %-25s %s\n" "flake-diff" "upd-diff" "Updates"
	@printf "%-20s %-25s %s\n" "upgrade" "upd-upgrade" "Updates"
	@printf "%-20s %-25s %s\n" "show" "upd-show" "Updates"
	@printf "%-20s %-25s %s\n" "flake-check" "upd-check" "Updates"
	@printf "%-20s %-25s %s\n" "generations" "gen-list" "Generations"
	@printf "%-20s %-25s %s\n" "rollback" "gen-rollback" "Generations"
	@printf "%-20s %-25s %s\n" "diff-gens" "gen-diff" "Generations"
	@printf "%-20s %-25s %s\n" "diff-current" "gen-diff-current" "Generations"
	@printf "%-20s %-25s %s\n" "gen-size" "gen-sizes" "Generations"
	@printf "%-20s %-25s %s\n" "health/status" "sys-status" "Logs"
	@printf "%-20s %-25s %s\n" "test-network" "log-net" "Logs"
	@printf "%-20s %-25s %s\n" "watch-logs" "log-watch" "Logs"
	@printf "%-20s %-25s %s\n" "logs-service" "log-svc" "Logs"
	@printf "%-20s %-25s %s\n" "boot-logs" "log-boot" "Logs"
	@printf "%-20s %-25s %s\n" "error-logs" "log-err" "Logs"
	@printf "%-20s %-25s %s\n" "hosts" "dev-hosts" "Dev"
	@printf "%-20s %-25s %s\n" "search" "dev-search" "Dev"
	@printf "%-20s %-25s %s\n" "search-inst" "dev-search-inst" "Dev"
	@printf "%-20s %-25s %s\n" "repl" "dev-repl" "Dev"
	@printf "%-20s %-25s %s\n" "shell" "dev-shell" "Dev"
	@printf "%-20s %-25s %s\n" "vm" "dev-vm" "Dev"
	@printf "%-20s %-25s %s\n" "closure-size" "dev-size" "Dev"
	@printf "%-20s %-25s %s\n" "format" "fmt-check" "Format"
	@printf "%-20s %-25s %s\n" "lint" "fmt-lint" "Format"
	@printf "%-20s %-25s %s\n" "tree" "fmt-tree" "Format"
	@printf "%-20s %-25s %s\n" "diff-config" "fmt-diff" "Format"
	@printf "%-20s %-25s %s\n" "docs-*" "doc-*" "Docs"
	@printf "\n$(BLUE)Tip:$(NC) Run $(GREEN)make help$(NC) to see all modern commands.\n\n"

# === Sistema (sys-) ===
switch: sys-apply
switch-safe: sys-apply-safe
switch-fast: sys-apply-fast
test: sys-test
build: sys-build
dry-run: sys-dry-run
boot: sys-boot
validate: sys-check
debug: sys-debug
emergency: sys-force
fix-permissions: sys-doctor
hardware-scan: sys-hw-scan

# === Deploy y Sincronización ===
sync: sys-deploy
deploy: sys-deploy

# === Limpieza (sys-) ===
clean: sys-gc
deep-clean: sys-purge

# === Actualizaciones (upd-) ===
update: upd-all
update-nixpkgs: upd-nixpkgs
update-hydenix: upd-hydenix
update-input: upd-input
update-dots: upd-dots
flake-diff: upd-diff
upgrade: upd-upgrade
show: upd-show
flake-check: upd-check

# === Generaciones (gen-) ===
generations: gen-list
rollback: gen-rollback
diff-gens: gen-diff
diff-current: gen-diff-current
gen-size: gen-sizes

# === Logs y Diagnóstico (log-) ===
health: sys-status
status: sys-status
test-network: log-net
watch-logs: log-watch
logs-service: log-svc
boot-logs: log-boot
error-logs: log-err

# === Desarrollo (dev-) ===
hosts: dev-hosts
search: dev-search
search-inst: dev-search-inst
repl: dev-repl
shell: dev-shell
vm: dev-vm
closure-size: dev-size

# === Formato y Estructura (fmt-) ===
format: fmt-check
lint: fmt-lint
tree: fmt-tree
diff-config: fmt-diff

# === Documentación (doc-) ===
docs-local: doc-local
docs-dev: doc-dev
docs-build: doc-build
docs-install: doc-install
docs-clean: doc-clean
