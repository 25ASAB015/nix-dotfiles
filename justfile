# ============================================================================
# NixOS Management Justfile
# ============================================================================

# Variables de configuración
flake_dir := "."
hostname := env_var_or_default("HOSTNAME", "hydenix")

# ============================================================================
# COMANDOS PRINCIPALES
# ============================================================================

# Lista todos los comandos disponibles (default)
@default:
    just --list

# Deployment completo: permisos → git → build
@sync: doctor fix-git stage commit push apply
    #!/usr/bin/env bash
    source .just-helpers.sh
    printf "${GREEN}✅ Deployment completo exitoso${NC}\n"

# Alias para sync
alias deploy := sync

# ============================================================================
# SISTEMA
# ============================================================================

# Build y activa nueva configuración
@apply: fix-git
    #!/usr/bin/env bash
    source .just-helpers.sh
    printf "${CYAN}🔄 Aplicando configuración NixOS...${NC}\n"
    git add .
    sudo nixos-rebuild switch --flake {{flake_dir}}#{{hostname}}
    printf "${GREEN}✅ Configuración aplicada${NC}\n"

# Corrige permisos en directorios de usuario
@doctor:
    #!/usr/bin/env bash
    source .just-helpers.sh
    printf "${CYAN}👨‍⚕️ Verificando permisos...${NC}\n"
    fix_permissions() {
        local dir=$1
        if [ -d "$dir" ]; then
            if find "$dir" -maxdepth 1 -not -user $USER 2>/dev/null | grep -q .; then
                printf "  Corrigiendo $dir... "
                sudo chown -R $USER:users "$dir" && printf "${GREEN}✓${NC}\n" || printf "${RED}✗${NC}\n"
            else
                printf "  $dir ${GREEN}✓${NC}\n"
            fi
        fi
    }
    fix_permissions ~/.config
    fix_permissions ~/.local

# Corrige permisos del repositorio git
@fix-git:
    #!/usr/bin/env bash
    source .just-helpers.sh
    if [ -d "{{flake_dir}}/.git/objects" ]; then
        if find "{{flake_dir}}/.git/objects" -maxdepth 2 -type d -not -user $USER 2>/dev/null | grep -q .; then
            printf "${YELLOW}Corrigiendo permisos de git...${NC} "
            sudo chown -R $USER:users "{{flake_dir}}/.git" && printf "${GREEN}✓${NC}\n" || printf "${RED}✗${NC}\n"
        fi
    fi

# ============================================================================
# GIT
# ============================================================================

# Prepara todos los cambios
@stage:
    #!/usr/bin/env bash
    source .just-helpers.sh
    if [ -n "$(git status --porcelain)" ]; then
        git add .
        count=$(git status --short | wc -l)
        printf "${GREEN}✓${NC} Staged $count archivo(s)\n"
    else
        printf "${YELLOW}⚠${NC}  Sin cambios\n"
    fi

# Commit con timestamp
@commit:
    #!/usr/bin/env bash
    source .just-helpers.sh
    if [ -n "$(git status --porcelain)" ]; then
        git add .
        msg="config: update $(date '+%Y-%m-%d %H:%M:%S')"
        git commit -m "$msg"
        printf "${GREEN}✓${NC} Commit: %s\n" "$(git rev-parse --short HEAD)"
    else
        printf "${YELLOW}⚠${NC}  Sin cambios para commit\n"
    fi

# Push a remote
@push:
    #!/usr/bin/env bash
    source .just-helpers.sh
    branch=$(git branch --show-current)
    unpushed=$(git log origin/$branch..HEAD --oneline 2>/dev/null | wc -l || echo 0)
    if [ $unpushed -gt 0 ]; then
        git push
        printf "${GREEN}✓${NC} Pushed $unpushed commit(s) a $branch\n"
    else
        printf "${YELLOW}⚠${NC}  Todo actualizado\n"
    fi

# Commit con mensaje personalizado
@commit-msg msg:
    #!/usr/bin/env bash
    source .just-helpers.sh
    git add .
    git commit -m "{{msg}}"
    printf "${GREEN}✓${NC} Commit: {{msg}}\n"

# ============================================================================
# UTILIDADES
# ============================================================================

# Muestra el estado del sistema
@status:
    #!/usr/bin/env bash
    source .just-helpers.sh
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
    #!/usr/bin/env bash
    source .just-helpers.sh
    printf "${YELLOW}🗑️  Limpiando generaciones antiguas...${NC}\n"
    sudo nix-collect-garbage --delete-old
    printf "${GREEN}✓${NC} Limpieza completa\n"

# Actualiza flake inputs
@update:
    #!/usr/bin/env bash
    source .just-helpers.sh
    printf "${CYAN}⬆️  Actualizando flake inputs...${NC}\n"
    nix flake update
    printf "${GREEN}✓${NC} Flake actualizado\n"

# Verifica la configuración sin aplicar
@check:
    #!/usr/bin/env bash
    source .just-helpers.sh
    printf "${CYAN}🔍 Verificando configuración...${NC}\n"
    nixos-rebuild dry-build --flake {{flake_dir}}#{{hostname}}

# ============================================================================
# DESARROLLO
# ============================================================================

# Formatea archivos Nix (deshabilitado temporalmente)
@fmt:
    #!/usr/bin/env bash
    source .just-helpers.sh
    printf "${YELLOW}⚠${NC}  Formateo deshabilitado temporalmente\n"
    # printf "${CYAN}✨ Formateando código Nix...${NC}\n"
    # nix fmt
    # printf "${GREEN}✓${NC} Formato aplicado\n"

# Muestra el diff de la última generación
@diff:
    nix store diff-closures /nix/var/nix/profiles/system-*-link(om[2]) /nix/var/nix/profiles/system-*-link(om[1])
