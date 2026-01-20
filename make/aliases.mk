# ============================================================================
# Aliases de Compatibilidad (Legacy)
# ============================================================================
# Descripción: Redirecciones de comandos antiguos a la nueva nomenclatura
# Estos comandos se mantienen por compatibilidad pero están marcados como 
# obsoletos (deprecated). Se recomienda usar los nuevos prefijos.
# ============================================================================

.PHONY: switch switch-safe switch-fast test build dry-run boot validate debug emergency \
        fix-permissions hardware-scan sync deploy clean deep-clean update update-nixpkgs \
        update-hydenix update-input flake-diff upgrade show flake-check generations \
        rollback diff-gens diff-current gen-size health status test-network watch-logs \
        logs-service boot-logs error-logs hosts search search-inst repl shell vm closure-size \
        format lint tree diff-config docs-local docs-dev docs-build docs-install docs-clean \
        help-aliases

# === Ayuda de Aliases ===
help-aliases: ## Show list of legacy aliases and their modern equivalents
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)      Legacy Aliases & Modern Equivalents          \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(YELLOW)Estos comandos se mantienen por compatibilidad.$(NC)\n"
	@printf "$(YELLOW)Se recomienda usar la nueva nomenclatura.$(NC)\n\n"
	@printf "$(BLUE)%-20s %-25s %s$(NC)\n" "LEGACY ALIAS" "MODERN COMMAND" "CATEGORY"
	@printf "$(CYAN)%-20s %-25s %s$(NC)\n" "------------" "--------------" "--------"
	@printf "%-20s %-25s %s\n" "switch" "sys-apply" "System"
	@printf "%-20s %-25s %s\n" "sync/deploy" "sys-deploy" "System"
	@printf "%-20s %-25s %s\n" "validate" "sys-check" "System"
	@printf "%-20s %-25s %s\n" "clean" "sys-gc" "Cleanup"
	@printf "%-20s %-25s %s\n" "update" "upd-all" "Updates"
	@printf "%-20s %-25s %s\n" "rollback" "gen-rollback" "Generations"
	@printf "%-20s %-25s %s\n" "health/status" "sys-status" "Logs"
	@printf "%-20s %-25s %s\n" "search" "dev-search" "Dev"
	@printf "%-20s %-25s %s\n" "format" "fmt-check" "Format"
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
