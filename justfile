# ============================================================================
# NixOS Management Justfile
# ============================================================================

# Variables de configuración
flake_dir := "."
hostname := env_var_or_default("HOSTNAME", "hydenix")

# Variables de color (definidas una sola vez)
red := '\033[0;31m'
green := '\033[0;32m'
yellow := '\033[0;33m'
blue := '\033[0;34m'
cyan := '\033[0;36m'
nc := '\033[0m'

# ============================================================================
# COMANDOS PRINCIPALES
# ============================================================================

# Lista todos los comandos disponibles (default)
@default:
    just --list

# Deployment completo: permisos → git → build
@sync: doctor fix-git stage commit push apply
    echo "{{green}}✅ Deployment completo exitoso{{nc}}"

# Alias para sync
alias deploy := sync

# ============================================================================
# SISTEMA
# ============================================================================

# Build y activa nueva configuración
@apply: fix-git
    echo "{{cyan}}🔄 Aplicando configuración NixOS...{{nc}}"
    git add .
    sudo nixos-rebuild switch --flake {{flake_dir}}#{{hostname}}
    echo "{{green}}✅ Configuración aplicada{{nc}}"

# Corrige permisos en directorios de usuario
@doctor:
    #!/usr/bin/env bash
    echo "{{cyan}}👨‍⚕️ Verificando permisos...{{nc}}"
    fix_permissions() {
        local dir=$1
        if [ -d "$dir" ]; then
            if find "$dir" -maxdepth 1 -not -user $USER 2>/dev/null | grep -q .; then
                echo -n "  Corrigiendo $dir... "
                sudo chown -R $USER:users "$dir" && echo "{{green}}✓{{nc}}" || echo "{{red}}✗{{nc}}"
            else
                echo "  $dir {{green}}✓{{nc}}"
            fi
        fi
    }
    fix_permissions ~/.config
    fix_permissions ~/.local

# Corrige permisos del repositorio git
@fix-git:
    #!/usr/bin/env bash
    if [ -d "{{flake_dir}}/.git/objects" ]; then
        if find "{{flake_dir}}/.git/objects" -maxdepth 2 -type d -not -user $USER 2>/dev/null | grep -q .; then
            echo -n "{{yellow}}Corrigiendo permisos de git...{{nc}} "
            sudo chown -R $USER:users "{{flake_dir}}/.git" && echo "{{green}}✓{{nc}}" || echo "{{red}}✗{{nc}}"
        fi
    fi

# ============================================================================
# GIT
# ============================================================================

# Prepara todos los cambios
@stage:
    #!/usr/bin/env bash
    if [ -n "$(git status --porcelain)" ]; then
        git add .
        count=$(git status --short | wc -l)
        echo "{{green}}✓{{nc}} Staged $count archivo(s)"
    else
        echo "{{yellow}}⚠{{nc}}  Sin cambios"
    fi

# Commit con timestamp
@commit:
    #!/usr/bin/env bash
    if [ -n "$(git status --porcelain)" ]; then
        git add .
        msg="config: update $(date '+%Y-%m-%d %H:%M:%S')"
        git commit -m "$msg"
        echo "{{green}}✓{{nc}} Commit: $(git rev-parse --short HEAD)"
    else
        echo "{{yellow}}⚠{{nc}}  Sin cambios para commit"
    fi

# Push a remote
@push:
    #!/usr/bin/env bash
    branch=$(git branch --show-current)
    unpushed=$(git log origin/$branch..HEAD --oneline 2>/dev/null | wc -l || echo 0)
    if [ $unpushed -gt 0 ]; then
        git push
        echo "{{green}}✓{{nc}} Pushed $unpushed commit(s) a $branch"
    else
        echo "{{yellow}}⚠{{nc}}  Todo actualizado"
    fi

# Commit con mensaje personalizado
@commit-msg msg:
    git add .
    git commit -m "{{msg}}"
    echo "{{green}}✓{{nc}} Commit: {{msg}}"

# ============================================================================
# UTILIDADES
# ============================================================================

# Muestra el estado del sistema
@status:
    #!/usr/bin/env bash
    CYAN=$'\033[0;36m'
    BLUE=$'\033[0;34m'
    NC=$'\033[0m'
    printf "${CYAN}📊 Estado del sistema${NC}\n\n"
    printf "${BLUE}Git:${NC}\n"
    git status --short --branch
    printf "\n${BLUE}Branch:${NC} %s\n" "$(git branch --show-current)"
    unpushed=$(git log origin/$(git branch --show-current)..HEAD --oneline 2>/dev/null | wc -l || echo 0)
    printf "${BLUE}Unpushed:${NC} %s\n" "$unpushed"
    printf "\n${BLUE}NixOS:${NC}\n"
    printf "${BLUE}Hostname:${NC} {{hostname}}\n"
    printf "${BLUE}Flake:${NC} {{flake_dir}}\n"

# Limpia generaciones antiguas de NixOS
@clean:
    echo "{{yellow}}🗑️  Limpiando generaciones antiguas...{{nc}}"
    sudo nix-collect-garbage --delete-old
    echo "{{green}}✓{{nc}} Limpieza completa"

# Actualiza flake inputs
@update:
    echo "{{cyan}}⬆️  Actualizando flake inputs...{{nc}}"
    nix flake update
    echo "{{green}}✓{{nc}} Flake actualizado"

# Verifica la configuración sin aplicar
@check:
    #!/usr/bin/env bash
    CYAN=$'\033[0;36m'
    NC=$'\033[0m'
    printf "${CYAN}🔍 Verificando configuración...${NC}\n"
    nixos-rebuild dry-build --flake {{flake_dir}}#{{hostname}}

# ============================================================================
# DESARROLLO
# ============================================================================

# Formatea archivos Nix (deshabilitado temporalmente)
@fmt:
    echo "{{yellow}}⚠{{nc}}  Formateo deshabilitado temporalmente"
    # echo "{{cyan}}✨ Formateando código Nix...{{nc}}"
    # nix fmt
    # echo "{{green}}✓{{nc}} Formato aplicado"

# Muestra el diff de la última generación
@diff:
    nix store diff-closures /nix/var/nix/profiles/system-*-link(om[2]) /nix/var/nix/profiles/system-*-link(om[1])
