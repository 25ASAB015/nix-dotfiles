#!/usr/bin/env bash
# make/upd-dots.sh
# Automates updating dotfiles, submodules, and applying NixOS configuration

set -e

# Colors for output
CYAN='\033[0;36m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

FLAKE_DIR="."

printf "${CYAN}═════════════════════════════════════════════════════════════════════════════════${NC}\n"
printf "${CYAN}            🔄 Dotfiles Automatic Update                   ${NC}\n"
printf "${CYAN}═════════════════════════════════════════════════════════════════════════════════${NC}\n"

# 1. Update Submodules
printf "\n${BLUE}1/4 Actualizando submodules git...${NC}\n"
git submodule update --init --recursive --remote
printf "${GREEN}✓ Submodules actualizados${NC}\n"

# 2. Sync oh-my-tmux.conf
printf "\n${BLUE}2/4 Sincronizando oh-my-tmux.conf...${NC}\n"
if [ -f "modules/hm/programs/terminal/oh-my-tmux/.tmux.conf" ]; then
    cp modules/hm/programs/terminal/oh-my-tmux/.tmux.conf modules/hm/programs/terminal/oh-my-tmux.conf
    printf "${GREEN}✓ oh-my-tmux.conf sincronizado${NC}\n"
else
    printf "${RED}✗ Error: No se encontró el archivo de oh-my-tmux${NC}\n"
    exit 1
fi

# 3. Update Flake Inputs
printf "\n${BLUE}3/4 Actualizando flake inputs...${NC}\n"
nix flake update
printf "${GREEN}✓ Flake actualizado${NC}\n"

# 4. Apply Configuration
printf "\n${BLUE}4/4 Aplicando nueva configuración...${NC}\n"
git add .
sudo nixos-rebuild switch --flake "${FLAKE_DIR}#hydenix"
printf "${GREEN}✓ Configuración aplicada exitosamente${NC}\n"

printf "\n${CYAN}═════════════════════════════════════════════════════════════════════════════════${NC}\n"
printf "${GREEN}✅ Dotfiles actualizados y sistema sincronizado${NC}\n"
printf "${CYAN}═════════════════════════════════════════════════════════════════════════════════${NC}\n\n"
