# 📋 Plan de Mejoras para Makefile

**Fecha de creación:** 2026-01-11  
**Última actualización:** 2026-01-11  
**Estado:** ✅ FASES 1, 2 y 3 COMPLETADAS - IMPLEMENTACIÓN FINALIZADA  
**Progreso:** 25/32 tareas completadas (78%)

---

## 🎯 Objetivo

Mejorar y corregir el Makefile del sistema NixOS Hydenix basado en análisis exhaustivo, implementando correcciones críticas, mejoras importantes y ampliaciones útiles.

---

## 📊 Resumen por Prioridad

- 🔴 **Crítico:** 4 correcciones (deben hacerse primero)
- 🟡 **Importante:** 8 mejoras (alta prioridad)
- 🟢 **Nice-to-have:** 20 ampliaciones (implementar según necesidad)

**Total:** 32 cambios propuestos

---

## 🔴 FASE 1: CORRECCIONES CRÍTICAS (4 tareas)

### ❌ Problema 1: Comando `deep-clean` con Interactive Read Roto
**Archivo:** Makefile (líneas 89-101)  
**Estado:** [ ] Pendiente

**Problema actual:**
```makefile
@read -p "Are you absolutely sure? Type 'yes' to continue: " -r; \
```
El comando `read` con `-p` no funciona correctamente en Makefiles.

**Solución:**
```makefile
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
```

**Testing:**
```bash
make deep-clean
# Debe pedir confirmación correctamente
# Typing "yes" → ejecuta
# Typing "no" → cancela
```

---

### ❌ Problema 2: Comando `format` Referencia Herramienta No Instalada
**Archivo:** Makefile (líneas 140-143)  
**Estado:** [ ] Pendiente

**Problema actual:**
```makefile
find . -name "*.nix" -not -path "*/.*" -exec nixpkgs-fmt {} \;
```
`nixpkgs-fmt` no está instalado en el sistema.

**Solución (Opción A - Usar nix fmt built-in):**
```makefile
format: ## Format nix files with nix fmt
	@printf "$(CYAN)💅 Formatting nix files...\n$(NC)"
	nix fmt
	@printf "$(GREEN)✅ Formatting complete\n$(NC)"
```

**Solución (Opción B - Detectar herramienta):**
```makefile
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
```

**Decisión pendiente:** Elegir Opción A o B

**Testing:**
```bash
make format
# Debe formatear archivos .nix sin error
```

---

### ❌ Problema 3: Comando `lint` Referencia Herramienta No Instalada
**Archivo:** Makefile (líneas 145-147)  
**Estado:** [ ] Pendiente

**Problema actual:**
```makefile
find . -name "*.nix" -not -path "*/.*" -exec statix check {} \; || printf "$(YELLOW)Note: Install 'statix' for linting\n$(NC)"
```
`statix` no está instalado, el error se oculta con `||`.

**Solución:**
```makefile
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
```

**Testing:**
```bash
make lint
# Debe mostrar mensaje claro si statix no está instalado
# O ejecutar correctamente si está instalado
```

---

### ❌ Problema 4: Comando `vm` No Coincide con Estructura del Flake
**Archivo:** Makefile (líneas 251-254)  
**Estado:** [ ] Pendiente

**Problema actual:**
```makefile
nixos-rebuild build-vm --flake $(FLAKE_DIR)#$(HOSTNAME)
./result/bin/run-*-vm
```
La VM está definida en `packages."x86_64-linux".vm` en el flake, no en nixosConfigurations.

**Solución:**
```makefile
vm: ## Build and run VM
	@printf "$(BLUE)🖥️  Building VM...\n$(NC)"
	nix build .#vm
	@printf "$(GREEN)✅ VM built successfully\n$(NC)"
	@printf "$(CYAN)Starting VM...\n$(NC)"
	./result/bin/run-nixos-vm
```

**Testing:**
```bash
make vm
# Debe construir y ejecutar la VM correctamente
```

---

### ❌ Problema 5: Comando `hardware-scan` Genera Archivo en Ubicación Incorrecta
**Archivo:** Makefile (líneas 226-230)  
**Estado:** [ ] Pendiente

**Problema actual:**
```makefile
sudo nixos-generate-config --show-hardware-config > hardware-configuration-new.nix
```
Genera en root del flake, pero la estructura usa `hosts/hydenix/`.

**Solución:**
```makefile
hardware-scan: ## Re-scan hardware configuration
	@printf "$(BLUE)🔧 Scanning hardware configuration for $(HOSTNAME)...\n$(NC)"
	@sudo nixos-generate-config --show-hardware-config > hosts/$(HOSTNAME)/hardware-configuration-new.nix
	@printf "$(YELLOW)New hardware config saved as:\n$(NC)"
	@printf "  hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To review differences:\n$(NC)"
	@printf "  diff hosts/$(HOSTNAME)/hardware-configuration.nix hosts/$(HOSTNAME)/hardware-configuration-new.nix\n"
	@printf "$(CYAN)To apply:\n$(NC)"
	@printf "  mv hosts/$(HOSTNAME)/hardware-configuration-new.nix hosts/$(HOSTNAME)/hardware-configuration.nix\n"
```

**Testing:**
```bash
make hardware-scan
# Debe generar archivo en hosts/hydenix/hardware-configuration-new.nix
ls -la hosts/hydenix/hardware-configuration-new.nix
```

---

## 🟡 FASE 2: MEJORAS IMPORTANTES (8 tareas)

### 🔧 Mejora 1: Soporte Multi-Host
**Estado:** [ ] Pendiente

**Cambios necesarios:**

1. **Variables (líneas 10-12):**
```makefile
# Configuration
FLAKE_DIR := .
HOSTNAME ?= hydenix  # Can be overridden: make switch HOSTNAME=laptop
BACKUP_DIR := ~/nixos-backups
AVAILABLE_HOSTS := hydenix laptop vm
```

2. **Nuevo comando `list-hosts`:**
```makefile
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
```

**Testing:**
```bash
make list-hosts
# Debe mostrar hydenix (current), laptop, vm

make switch HOSTNAME=laptop
# Debe intentar build para laptop
```

---

### 🔧 Mejora 2: Comando de Validación Pre-Switch
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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
	@if nix eval .#nixosConfigurations.$(HOSTNAME).config.system.build.toplevel --show-trace >/dev/null 2>&1; then \
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

safe-switch: validate switch ## Validate then switch (safest option)
```

**Testing:**
```bash
make validate
# Debe pasar todos los checks

make safe-switch
# Debe validar y luego hacer switch
```

---

### 🔧 Mejora 3: Info de Update
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
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
```

**Testing:**
```bash
make update-info
# Debe mostrar inputs actuales

make update
make diff-update
# Debe mostrar diferencias en flake.lock
```

---

### 🔧 Mejora 4: Health Check del Sistema
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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
```

**Testing:**
```bash
make health
# Debe mostrar estado de todos los checks
```

---

### 🔧 Mejora 5: Benchmark de Rebuild
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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

benchmark-full: ## Time full rebuild with switch
	@printf "$(BLUE)⏱️  Benchmarking Full Rebuild\n$(NC)"
	@printf "================================\n"
	@printf "$(YELLOW)Starting full benchmark...\n$(NC)"
	@START=$$(date +%s); \
	sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME); \
	END=$$(date +%s); \
	DURATION=$$((END - START)); \
	printf "\n$(GREEN)✅ Full Rebuild Complete\n$(NC)"; \
	printf "$(CYAN)Total time: $${DURATION}s ($$((DURATION / 60))m $$((DURATION % 60))s)\n$(NC)"
```

**Testing:**
```bash
make benchmark
# Debe medir tiempo de build

make benchmark-full
# Debe medir tiempo de switch completo
```

---

### 🔧 Mejora 6: Tamaño de Generaciones
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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
```

**Testing:**
```bash
make generation-sizes
# Debe mostrar tamaño de cada generación
```

---

### 🔧 Mejora 7: Status Mejorado
**Estado:** [ ] Pendiente

**Reemplazar comando actual (líneas 204-212):**
```makefile
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
```

**Testing:**
```bash
make status
# Debe mostrar overview completo y organizado
```

---

### 🔧 Mejora 8: Comparación entre Generaciones
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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
```

**Testing:**
```bash
make diff-generations
# Debe comparar última con anterior

make diff-gen GEN1=184 GEN2=186
# Debe comparar generaciones específicas
```

---

## 🟢 FASE 3: AMPLIACIONES NICE-TO-HAVE (20 tareas)

### 🎨 Ampliación 1: Update de Input Específico
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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
```

**Testing:**
```bash
make update-input INPUT=hydenix
# Debe actualizar solo hydenix
```

---

### 🎨 Ampliación 2: Búsqueda de Paquetes
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
search: ## Search for packages in nixpkgs (use PKG=name)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)Error: PKG variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make search PKG=firefox$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)🔍 Searching for: $(PKG)\n$(NC)"
	@printf "================================\n"
	@nix search nixpkgs $(PKG) --json | \
		jq -r 'to_entries[] | "$(GREEN)\(.key)$(NC)\n  Version: \(.value.version // "N/A")\n  Description: \(.value.description // "N/A")\n"' | \
		head -50 || nix search nixpkgs $(PKG)

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
```

**Testing:**
```bash
make search PKG=neovim
# Debe buscar en nixpkgs

make search-installed PKG=kitty
# Debe buscar en paquetes instalados
```

---

### 🎨 Ampliación 3: Changelog Automático
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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

changelog-file: ## Export changelog to file
	@printf "$(BLUE)📄 Generating CHANGELOG.md...\n$(NC)"
	@echo "# Changelog" > CHANGELOG.md
	@echo "" >> CHANGELOG.md
	@echo "Generated: $$(date '+%Y-%m-%d %H:%M:%S')" >> CHANGELOG.md
	@echo "" >> CHANGELOG.md
	@git log --pretty=format:"## %h - %s%n%nDate: %ad%nAuthor: %an%n" \
		--date=short >> CHANGELOG.md 2>/dev/null || \
		echo "Not a git repository" >> CHANGELOG.md
	@printf "$(GREEN)✅ CHANGELOG.md created\n$(NC)"
```

**Testing:**
```bash
make changelog
# Debe mostrar últimos 20 commits

make changelog-file
# Debe crear CHANGELOG.md
```

---

### 🎨 Ampliación 4: Export/Import de Configuración
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
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
```

**Testing:**
```bash
make export-config
# Debe crear tarball con todo

make export-minimal
# Debe crear tarball mínimo
```

---

### 🎨 Ampliación 5: Ayuda Avanzada
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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
	@printf "$(YELLOW)For tutorial:$(NC) cat MAKEFILE_TUTORIAL.md\n\n"

help-categories: ## Show commands grouped by category
	@printf "$(CYAN)Commands by Category\n$(NC)"
	@printf "====================\n\n"
	@printf "$(GREEN)🔨 Build & Deploy:$(NC) switch, test, build, dry-run, boot, safe-switch\n"
	@printf "$(GREEN)🐛 Debug:$(NC) debug, validate, check-syntax, show, emergency\n"
	@printf "$(GREEN)🧹 Maintenance:$(NC) clean, clean-week, clean-conservative, optimize, gc\n"
	@printf "$(GREEN)📦 Updates:$(NC) update, update-nixpkgs, update-hydenix, upgrade, update-input\n"
	@printf "$(GREEN)💾 Backup:$(NC) backup, list-generations, rollback, generation-sizes\n"
	@printf "$(GREEN)📊 Info:$(NC) info, status, health, diff-generations, changelog\n"
	@printf "$(GREEN)🖥️  Multi-Host:$(NC) list-hosts, (use HOSTNAME=<name> with build commands)\n"
	@printf "$(GREEN)🔍 Search:$(NC) search, search-installed\n"
	@printf "$(GREEN)🔧 Advanced:$(NC) repl, shell, vm, hardware-scan, benchmark\n"
	@printf "$(GREEN)📤 Export:$(NC) export-config, export-minimal\n\n"
```

**Testing:**
```bash
make help-advanced
# Debe mostrar workflows detallados

make help-categories
# Debe mostrar comandos por categoría
```

---

### 🎨 Ampliación 6: Información de Paquetes Instalados
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
packages: ## List all installed packages
	@printf "$(CYAN)📦 Installed Packages\n$(NC)"
	@printf "====================\n\n"
	@printf "$(BLUE)User packages:$(NC)\n"
	@nix-env -q | sort | sed 's/^/  /' || printf "  $(YELLOW)None$(NC)\n"
	@printf "\n$(BLUE)System packages (count):$(NC) "
	@nix-store -q --references /run/current-system | wc -l
	@printf "\n$(YELLOW)Tip: Use 'make search-installed PKG=name' to find specific package$(NC)\n"

packages-system: ## List system packages in detail
	@printf "$(CYAN)📦 System Packages\n$(NC)"
	@printf "==================\n"
	@nix-store -q --references /run/current-system | \
		grep -v '^\.' | \
		sort | \
		sed 's/.*\///' | \
		sed 's/-[0-9].*//' | \
		sort -u | \
		column
```

**Testing:**
```bash
make packages
# Debe listar paquetes instalados

make packages-system
# Debe listar paquetes del sistema
```

---

### 🎨 Ampliación 7: Logs Específicos
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
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
```

**Testing:**
```bash
make logs-boot
make logs-errors
make logs-service SVC=networkmanager
```

---

### 🎨 Ampliación 8: Información de Closures
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
closure-size: ## Show closure size of current system
	@printf "$(CYAN)📊 System Closure Size\n$(NC)"
	@printf "======================\n"
	@nix path-info -Sh /run/current-system | head -1
	@printf "\n$(BLUE)Top 10 largest packages:$(NC)\n"
	@nix path-info -rSh /run/current-system | \
		sort -k2 -h | \
		tail -10 | \
		awk '{printf "  %8s  %s\n", $$2, $$1}'

what-depends: ## Show what depends on a package (use PKG=/nix/store/...)
	@if [ -z "$(PKG)" ]; then \
		printf "$(RED)Error: PKG variable required$(NC)\n"; \
		printf "$(YELLOW)Usage: make what-depends PKG=/nix/store/...-package$(NC)\n"; \
		exit 1; \
	fi
	@printf "$(CYAN)🔍 Reverse dependencies for:\n$(NC)"
	@printf "  $(PKG)\n\n"
	@nix-store --query --referrers $(PKG) | head -20
```

**Testing:**
```bash
make closure-size
# Debe mostrar tamaño del closure actual
```

---

### 🎨 Ampliación 9: Helpers para Development
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
edit-flake: ## Open flake.nix in editor
	@$$EDITOR flake.nix || nvim flake.nix || nano flake.nix

edit-host: ## Open host configuration in editor (use HOSTNAME)
	@if [ -f "hosts/$(HOSTNAME)/configuration.nix" ]; then \
		$$EDITOR hosts/$(HOSTNAME)/configuration.nix || nvim hosts/$(HOSTNAME)/configuration.nix; \
	else \
		printf "$(RED)Host configuration not found: hosts/$(HOSTNAME)/configuration.nix$(NC)\n"; \
	fi

edit-hm: ## Open home-manager config in editor
	@if [ -f "modules/hm/default.nix" ]; then \
		$$EDITOR modules/hm/default.nix || nvim modules/hm/default.nix; \
	else \
		printf "$(RED)Home-manager config not found$(NC)\n"; \
	fi

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
```

**Testing:**
```bash
make edit-flake
# Debe abrir flake.nix en editor

make tree
# Debe mostrar estructura
```

---

### 🎨 Ampliación 10: Quick Info Commands
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
version: ## Show NixOS and flake versions
	@printf "$(CYAN)📌 Version Information\n$(NC)"
	@printf "=====================\n"
	@printf "$(BLUE)NixOS:$(NC) $$(nixos-version 2>/dev/null || echo 'N/A')\n"
	@printf "$(BLUE)Nix:$(NC) $$(nix --version 2>/dev/null || echo 'N/A')\n"
	@printf "$(BLUE)Hostname:$(NC) $(HOSTNAME)\n"
	@printf "$(BLUE)System:$(NC) $$(uname -sm)\n"
	@printf "\n$(BLUE)Flake inputs versions:$(NC)\n"
	@nix flake metadata --json 2>/dev/null | \
		jq -r '.locks.nodes | to_entries[] | select(.value.locked) | "  \(.key): \(.value.locked.lastModified // "unknown")"' | \
		head -10 || printf "  $(YELLOW)Unable to read$(NC)\n"

current-generation: ## Show current generation details
	@printf "$(CYAN)📍 Current Generation\n$(NC)"
	@printf "====================\n"
	@sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -1
	@printf "\n$(BLUE)Activation date:$(NC) "
	@stat -c %y /run/current-system | cut -d'.' -f1
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
```

**Testing:**
```bash
make version
make current-generation
make hosts-info
```

---

### 🎨 Ampliación 11: Store Management
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
store-info: ## Show detailed nix store information
	@printf "$(CYAN)💾 Nix Store Information\n$(NC)"
	@printf "=======================\n"
	@printf "$(BLUE)Store path:$(NC) /nix/store\n"
	@printf "$(BLUE)Total size:$(NC) $$(du -sh /nix/store 2>/dev/null | cut -f1)\n"
	@printf "$(BLUE)Items count:$(NC) $$(ls /nix/store 2>/dev/null | wc -l)\n"
	@printf "$(BLUE)Live paths:$(NC) $$(nix-store --gc --print-roots 2>/dev/null | wc -l)\n"
	@printf "\n$(BLUE)Disk usage:$(NC)\n"
	@df -h /nix 2>/dev/null | tail -1 | awk '{printf "  Total: %s | Used: %s (%s) | Free: %s\n", $$2, $$3, $$5, $$4}'

store-verify: ## Verify nix store integrity
	@printf "$(CYAN)🔍 Verifying Store Integrity\n$(NC)"
	@printf "============================\n"
	@printf "$(YELLOW)This may take several minutes...$(NC)\n\n"
	@if nix-store --verify --check-contents; then \
		printf "\n$(GREEN)✅ Store verification passed$(NC)\n"; \
	else \
		printf "\n$(RED)✗ Store verification found issues$(NC)\n"; \
		printf "$(YELLOW)Consider running 'nix-store --repair-path <path>'$(NC)\n"; \
	fi

store-gc-dry: ## Show what would be collected by GC
	@printf "$(CYAN)🗑️  Garbage Collection Preview\n$(NC)"
	@printf "==============================\n"
	@nix-collect-garbage --dry-run
	@sudo nix-collect-garbage --dry-run
```

**Testing:**
```bash
make store-info
make store-verify
make store-gc-dry
```

---

### 🎨 Ampliación 12: Profile Management
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
profiles: ## List all nix profiles
	@printf "$(CYAN)👤 Nix Profiles\n$(NC)"
	@printf "==============\n\n"
	@printf "$(BLUE)System profile:$(NC)\n"
	@ls -lh /nix/var/nix/profiles/system 2>/dev/null || printf "  $(YELLOW)Not found$(NC)\n"
	@printf "\n$(BLUE)User profiles:$(NC)\n"
	@ls -lh /nix/var/nix/profiles/per-user/$$USER/ 2>/dev/null || printf "  $(YELLOW)None$(NC)\n"

profile-history: ## Show profile history with sizes
	@printf "$(CYAN)📊 Profile History\n$(NC)"
	@printf "==================\n"
	@for gen in /nix/var/nix/profiles/system-*-link; do \
		if [ -L "$$gen" ]; then \
			SIZE=$$(du -sh $$gen 2>/dev/null | cut -f1); \
			DATE=$$(stat -c %y $$gen 2>/dev/null | cut -d'.' -f1); \
			printf "  %s | %s | %s\n" "$$(basename $$gen)" "$$SIZE" "$$DATE"; \
		fi \
	done | tail -15
```

**Testing:**
```bash
make profiles
make profile-history
```

---

### 🎨 Ampliación 13: Network Tests
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
test-network: ## Test network connectivity and cache access
	@printf "$(CYAN)🌐 Network Tests\n$(NC)"
	@printf "===============\n\n"
	@printf "$(BLUE)1. Internet connectivity:$(NC) "
	@if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
	fi
	@printf "$(BLUE)2. DNS resolution:$(NC) "
	@if ping -c 1 -W 2 nixos.org >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
	fi
	@printf "$(BLUE)3. Binary cache access:$(NC) "
	@if curl -s --head https://cache.nixos.org >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
	fi
	@printf "$(BLUE)4. GitHub access:$(NC) "
	@if curl -s --head https://github.com >/dev/null 2>&1; then \
		printf "$(GREEN)✓$(NC)\n"; \
	else \
		printf "$(RED)✗$(NC)\n"; \
	fi

cache-info: ## Show binary cache information
	@printf "$(CYAN)💾 Binary Cache Info\n$(NC)"
	@printf "====================\n"
	@nix show-config | grep substituters || printf "$(YELLOW)No cache info$(NC)\n"
```

**Testing:**
```bash
make test-network
make cache-info
```

---

### 🎨 Ampliación 14: Build Analysis
**Estado:** [ ] Pendiente

**Nuevo comando:**
```makefile
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
```

**Testing:**
```bash
make why-depends PKG=firefox
make build-trace
```

---

### 🎨 Ampliación 15: Quick Fixes
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
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
	@printf "$(GREEN)✅ Store repair complete$(NC)\n"

clean-result: ## Remove result symlinks
	@printf "$(CYAN)🧹 Cleaning result symlinks\n$(NC)"
	@find . -maxdepth 2 -name 'result*' -type l -delete 2>/dev/null || true
	@printf "$(GREEN)✅ Result symlinks removed$(NC)\n"
```

**Testing:**
```bash
make fix-permissions
make clean-result
```

---

### 🎨 Ampliación 16: Documentation Helpers
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
docs: ## Open documentation in browser
	@printf "$(CYAN)📚 Opening Documentation\n$(NC)"
	@xdg-open https://nixos.org/manual/nixos/stable/ 2>/dev/null || \
		printf "$(YELLOW)Visit: https://nixos.org/manual/nixos/stable/$(NC)\n"

docs-local: ## Show local documentation files
	@printf "$(CYAN)📚 Local Documentation\n$(NC)"
	@printf "=====================\n"
	@if [ -f "README.md" ]; then printf "  $(GREEN)✓$(NC) README.md\n"; fi
	@if [ -f "MAKEFILE_TUTORIAL.md" ]; then printf "  $(GREEN)✓$(NC) MAKEFILE_TUTORIAL.md\n"; fi
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
```

**Testing:**
```bash
make docs-local
make readme
```

---

### 🎨 Ampliación 17: Performance Monitoring
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
perf: ## Show system performance metrics
	@printf "$(CYAN)⚡ System Performance\n$(NC)"
	@printf "====================\n"
	@printf "$(BLUE)CPU:$(NC)\n"
	@top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | \
		awk '{print "  Usage: " 100 - $$1 "%"}'
	@printf "$(BLUE)Memory:$(NC)\n"
	@free -h | awk 'NR==2{printf "  Used: %s / %s (%.0f%%)\n", $$3, $$2, $$3/$$2*100}'
	@printf "$(BLUE)Disk (/):$(NC)\n"
	@df -h / | awk 'NR==2{printf "  Used: %s / %s (%s)\n", $$3, $$2, $$5}'
	@printf "$(BLUE)Disk (/nix):$(NC)\n"
	@df -h /nix | awk 'NR==2{printf "  Used: %s / %s (%s)\n", $$3, $$2, $$5}'

load: ## Show system load
	@printf "$(CYAN)📊 System Load\n$(NC)"
	@printf "=============\n"
	@uptime | awk -F'load average:' '{print "  Load average:" $$2}'
	@printf "$(BLUE)CPU cores:$(NC) $$(nproc)\n"
```

**Testing:**
```bash
make perf
make load
```

---

### 🎨 Ampliación 18: Configuration Templates
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
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
```

**Testing:**
```bash
make new-host HOST=testvm
make new-module MODULE=hm/programs/test
```

---

### 🎨 Ampliación 19: Diff Tools
**Estado:** [ ] Pendiente

**Nuevos comandos:**
```makefile
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
```

**Testing:**
```bash
make diff-config
make diff-flake
make compare-hosts HOST1=hydenix HOST2=laptop
```

---

### 🎨 Ampliación 20: Shell Optimizations
**Estado:** [ ] Pendiente

**Agregar al inicio del Makefile:**
```makefile
# Shell optimization
.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
```

**Descripción:**
- `.ONESHELL`: Todos los comandos de una regla se ejecutan en el mismo shell
- `.SHELLFLAGS`: Error on undefined vars, fail on pipe errors
- `--warn-undefined-variables`: Avisar de variables no definidas
- `--no-builtin-rules`: Desactivar reglas built-in innecesarias

---

## 📝 NOTAS FINALES

### Orden de Implementación Recomendado

1. **FASE 1 completa** (crítico) - ~2 horas
2. **Mejoras 1, 2, 4** (multi-host, validación, health) - ~2 horas
3. **Mejoras 3, 7** (status mejorado, diff-generations) - ~1 hora
4. **Ampliaciones según necesidad** - implementar a demanda

### Testing

Después de cada cambio:
```bash
make help                # Verificar que se lista correctamente
make <nuevo-comando>     # Probar funcionalidad
make check-syntax        # Validar que no rompiste el flake
```

### Documentación

Después de implementar:
1. Actualizar `MAKEFILE_TUTORIAL.md` con nuevos comandos
2. Probar todos los comandos al menos una vez
3. Documentar cualquier dependencia externa necesaria

### Dependencias Externas

Algunas mejoras requieren herramientas adicionales:
- `statix`: para linting (ampliación de lint)
- `nixpkgs-fmt` o `alejandra`: para formatting
- `jq`: para parsear JSON (algunas ampliaciones)
- `tree`: para visualización de estructura

Considerar agregar a `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  statix
  nixpkgs-fmt
  jq
  tree
];
```

---

**Estado:** Listo para implementación  
**Próximo paso:** Comenzar con FASE 1 (correcciones críticas)  
**Actualizado:** 2026-01-11

