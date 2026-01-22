# ============================================================================
# Diagnóstico y Logs
# ============================================================================
# Descripción: Targets para diagnóstico del sistema, logs y monitoreo
# Targets: 6 targets
# ============================================================================

.PHONY: sys-status log-net log-watch log-boot log-err log-svc

# === Salud y Diagnóstico ===

# Combined dashboard and detailed system status
sys-status: ## Dashboard y reporte completo de salud del sistema
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🏥 Dashboard de Salud (Vuelo)          $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
	@printf "  $(BLUE)Estructura Flake:$(NC)  "
	@if nix flake metadata --json . >/dev/null 2>&1; then \
		printf "$(GREEN)✓ OK (metadata)$(NC)\n"; \
	else \
		printf "$(RED)✗ ERROR$(NC)\n"; \
	fi
	@printf "  $(BLUE)Espacio /nix:$(NC)      "
	@df -h /nix 2>/dev/null | tail -1 | awk '{ \
		usage=$5; sub(/%/, "", usage); \
		if (usage > 90) color="$(RED)"; \
		else if (usage > 75) color="$(YELLOW)"; \
		else color="$(GREEN)"; \
		printf "%s%s usado (%s libre)$(NC)\n", color, $5, $4 \
	}'
	@printf "  $(BLUE)Servicios:$(NC)          "
	@FAILED_COUNT=$(systemctl --failed --no-legend 2>/dev/null | wc -l); \
	if [ $FAILED_COUNT -eq 0 ]; then \
		printf "$(GREEN)✓ OK$(NC)\n"; \
	else \
		FAILED_LIST=$(systemctl --failed --no-legend --plain 2>/dev/null | head -n 3 | awk '{print $1}' | tr '\n' ' ' | sed 's/ $//' | sed 's/ /, /g'); \
		if [ $FAILED_COUNT -gt 3 ]; then FAILED_LIST="$FAILED_LIST..."; fi; \
		printf "$(RED)✗ $FAILED_COUNT fallidos ($FAILED_LIST)$(NC)\n"; \
	fi
	@printf "  $(BLUE)Git Status:$(NC)         "
	@if git diff-index --quiet HEAD -- 2>/dev/null; then \
		printf "$(GREEN)✓ Clean$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠ Pendiente$(NC)\n"; \
	fi
	@printf "  $(BLUE)Generaciones:$(NC)       "
	@find /nix/var/nix/profiles/ -maxdepth 1 -name "system-*-link" 2>/dev/null | wc -l
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)          📊 Reporte de Estado del Sistema          \n$(NC)"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(PURPLE)📍 Información de Base$(NC)\n"
	@printf "  $(BLUE)Hostname:$(NC)     $(GREEN)$(HOSTNAME)$(NC)\n"
	@printf "  $(BLUE)NixOS:$(NC)        $(GREEN)$(nixos-version 2>/dev/null | cut -d' ' -f1 || echo 'N/A')$(NC)\n"
	@printf "  $(BLUE)Flake:$(NC)        $(GREEN)$(PWD)$(NC)\n"
	@STORE_SIZE=$(df -h /nix 2>/dev/null | tail -1 | awk '{print $3}' || echo 'N/A'); \
	printf "  $(BLUE)Store Size:$(NC)   $(GREEN)%s (partition used)$(NC)\n" "$STORE_SIZE"
	@printf "\n$(PURPLE)💾 Almacenamiento y Generaciones$(NC)\n"
	@DISK=$(df -h /nix 2>/dev/null | tail -1 | awk '{print $5 " usado (" $4 " libre)"}' || echo 'N/A'); \
	printf "  $(BLUE)Disco (/nix):$(NC) $(GREEN)%s$(NC)\n" "$DISK"; \
	GENS_OUT=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system 2>/dev/null); \
	if [ -z "$GENS_OUT" ]; then \
		printf "  $(BLUE)Total Gens:$(NC)   $(YELLOW)Sin acceso (requiere sudo)$(NC)\n"; \
	else \
		TOTAL_GENS=$(echo "$GENS_OUT" | grep -c . || echo '0'); \
		CURRENT_GEN=$(echo "$GENS_OUT" | tail -1 | awk '{print $1 " (" $2 " " $3 ")"}' || echo 'N/A'); \
		printf "  $(BLUE)Total Gens:$(NC)   $(GREEN)%s$(NC)\n" "$TOTAL_GENS"; \
		printf "  $(BLUE)Generación:$(NC)   $(GREEN)%s$(NC)\n" "$CURRENT_GEN"; \
		printf "\n$(BLUE)  Últimas 5 generaciones:$(NC)\n"; \
		echo "$GENS_OUT" | tail -5 | sed 's/^/    /' || true; \
	fi
	@printf "\n$(PURPLE)🔄 Estado de Componentes$(NC)\n"
	@printf "  $(BLUE)Git Repo:$(NC)     "
	@if git diff-index --quiet HEAD -- 2>/dev/null; then \
		printf "$(GREEN)✓ Clean$(NC)\n"; \
	else \
		printf "$(YELLOW)⚠ Cambios pendientes$(NC)\n"; \
	fi
	@printf "  $(BLUE)Servicios:$(NC)    "
	@FAILED=$(systemctl --failed --no-legend 2>/dev/null | wc -l); \
	if [ $FAILED -eq 0 ]; then \
		printf "$(GREEN)✓ OK$(NC)\n"; \
	else \
		printf "$(RED)✗ $FAILED fallidos$(NC) (ejecuta 'systemctl --failed')\n"; \
	fi
	@printf "\n$(PURPLE)📦 Flake Inputs (Top 5)$(NC)\n"
	@nix flake metadata --json 2>/dev/null | grep -o '"lastModified":[0-9]*' | head -5 | sed 's/"lastModified"://' | sed 's/^/    /' || printf "    $(YELLOW)No disponible$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Reporte finalizado$(NC)\n"
	@printf "\n"

# --- Diagnóstico de Red ---

# Comprehensive network diagnostics including DNS, connectivity, and performance tests
# Tests DNS resolution, ping connectivity, and network throughput
log-net: ## Run comprehensive network diagnostics
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            🌐 Network Diagnostics                 $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"
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
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "$(GREEN)✅ Network diagnostics complete$(NC)\n"
	@printf "\n$(CYAN)════════════════════════════════════════════════════\n$(NC)"
	@printf "\n"

# Monitor system logs in real-time using journalctl follow mode
# Continuously displays new log entries as they are written
log-watch: ## Watch system logs in real-time (follow mode)
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📊 Watching System Logs                $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Press $(GREEN)Ctrl+C$(BLUE) to exit$(NC)\n\n"
	@journalctl -f

# Display error and alert logs from the current boot session
# Shows systemd logs with priority err and alert from current boot
log-boot: ## Show boot logs
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📋 Boot Logs                           $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Showing errors and alerts from current boot...$(NC)\n\n"
	@journalctl -b -p err..alert --no-pager | tail -50 || true
	@printf "\n"

# Display recent error-level logs from systemd journal
# Shows the last 50 error messages with timestamps
log-err: ## Show recent error logs
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📋 Recent Error Logs                   $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@ERROR_COUNT=$(journalctl -p err -n 50 --no-pager 2>/dev/null | wc -l || echo "0"); \
	printf "\n$(BLUE)Showing last 50 error-level messages$(NC)\n"; \
	if [ $ERROR_COUNT -eq 0 ]; then \
		printf "$(GREEN)✅ No recent errors found$(NC)\n"; \
	else \
		printf "$(PURPLE)Found:$(NC) $(GREEN)$ERROR_COUNT$(NC) error message(s)\n"; \
	fi
	@printf "\n"
	@journalctl -p err -n 50 --no-pager || true
	@printf "\n"

# Display logs for a specific systemd service using journalctl
# Shows recent logs for the specified service (use SVC=name parameter)
log-svc: ## Show logs for specific service (use SVC=name)
	@if [ -z "$(SVC)" ]; then \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "$(CYAN)          📋 Service Logs                           \n$(NC)"; \
		printf "$(CYAN)════════════════════════════════════════════════════\n$(NC)"; \
		printf "\n$(RED)❌ Error: SVC variable required$(NC)\n\n"; \
		printf "$(BLUE)Usage:$(NC) make log-svc SVC=<service-name>\n\n"; \
		printf "$(BLUE)Examples:$(NC)\n"; \
		printf "  make log-svc SVC=sshd\n"; \
		printf "  make log-svc SVC=networkmanager\n"; \
		printf "  make log-svc SVC=docker\n\n"; \
		printf "$(BLUE)Common services:$(NC)\n"; \
		if command -v systemctl >/dev/null 2>&1; then \
			systemctl list-units --type=service --state=running --no-pager --no-legend 2>/dev/null | \
			awk '{print "  " $1}' | head -10 || true; \
		fi; \
		printf "\n$(BLUE)Tip:$(NC) Use $(GREEN)systemctl list-units --type=service$(NC) to see all services\n"; \
		printf "\n"; \
		exit 1; \
	fi
	@printf "\n"
	@printf "$(CYAN)  ═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "$(CYAN)            📋 Service Logs                        $(NC)"
	@printf "\n$(CYAN)═════════════════════════════════════════════════════════════════════════════════\n$(NC)"
	@printf "\n$(BLUE)Service:$(NC) $(GREEN)$(SVC)$(NC)\n"
	@HAS_RECENT=$(journalctl -u $(SVC) --since "1 hour ago" --no-pager 2>/dev/null | grep -v "^-- No entries --" | grep -q . && echo "yes" || echo "no"); \
	if [ "$HAS_RECENT" = "yes" ]; then \
		LOG_COUNT=$(journalctl -u $(SVC) --since "1 hour ago" --no-pager 2>/dev/null | grep -v "^-- No entries --" | wc -l || echo "0"); \
		printf "$(BLUE)Showing logs from last hour ($(GREEN)$LOG_COUNT$(NC) entries)...$(NC)\n\n"; \
		journalctl -u $(SVC) --since "1 hour ago" -n 100 --no-pager 2>/dev/null | grep -v "^-- No entries --" || true; \
	elif journalctl -u $(SVC) --since today --no-pager 2>/dev/null | grep -v "^-- No entries --" | grep -q . 2>/dev/null; then \
		printf "$(BLUE)No recent logs (last hour), showing logs from today...$(NC)\n\n"; \
		journalctl -u $(SVC) --since today -n 100 --no-pager 2>/dev/null | grep -v "^-- No entries --" || true; \
	else \
		printf "$(BLUE)No logs from today, showing last 100 entries...$(NC)\n\n"; \
		if journalctl -u $(SVC) -n 100 --no-pager 2>/dev/null | grep -q .; then \
			journalctl -u $(SVC) -n 100 --no-pager 2>/dev/null || true; \
		else \
			printf "$(YELLOW)⚠ Service '$(SVC)' not found or no logs available$(NC)\n"; \
		fi \
	fi
	@printf "\n"
