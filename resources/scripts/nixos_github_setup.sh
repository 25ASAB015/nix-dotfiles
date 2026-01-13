#!/usr/bin/env bash

echo "=== CONFIGURACIÓN AUTOMATIZADA DE GIT/GITHUB (NixOS) ==="
echo ""

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para verificar si un archivo es writable (no symlink a nix store)
is_writable_config() {
    local file="$1"
    # Si no existe, es writable
    [ ! -e "$file" ] && return 0
    # Si es symlink a nix store, no es writable
    if [ -L "$file" ]; then
        local target=$(readlink -f "$file")
        if [[ "$target" == /nix/store/* ]]; then
            return 1
        fi
    fi
    # Intentar escribir
    touch "$file" 2>/dev/null
    return $?
}

# Detectar si Git está gestionado por Home Manager
GIT_MANAGED_BY_NIX=false
if [ -L ~/.config/git/config ] && [[ "$(readlink -f ~/.config/git/config)" == /nix/store/* ]]; then
    GIT_MANAGED_BY_NIX=true
    echo "ℹ️  Detectado: Git está gestionado por Home Manager (declarativo)"
    echo "   Las configuraciones de git se omitirán (ya están en tu .nix)"
    echo ""
fi

# Verificar que gh esté instalado
if ! command_exists gh; then
    echo "❌ GitHub CLI no está instalado."
    echo "📦 En NixOS, instala github-cli agregándolo a tu configuration.nix:"
    echo ""
    echo "  environment.systemPackages = with pkgs; ["
    echo "    github-cli"
    echo "    git"
    echo "    gnupg"
    echo "  ];"
    echo ""
    echo "Luego ejecuta: sudo nixos-rebuild switch"
    exit 1
fi

# Verificar que git esté instalado
if ! command_exists git; then
    echo "❌ Git no está instalado."
    echo "📦 Agrega 'git' a tu configuration.nix como se indicó arriba"
    exit 1
fi

# Verificar que gpg esté instalado
if ! command_exists gpg; then
    echo "❌ GPG no está instalado."
    echo "📦 Agrega 'gnupg' a tu configuration.nix como se indicó arriba"
    exit 1
fi

# Verificar autenticación actual
echo "🔍 Verificando autenticación actual..."
if gh auth status >/dev/null 2>&1; then
    echo "✅ Ya estás autenticado en GitHub."
    read -p "¿Deseas cerrar sesión y reautenticar? (s/N): " reauth
    if [[ "$reauth" =~ ^[sS]$ ]]; then
        gh auth logout --hostname github.com
    else
        echo "ℹ️  Manteniendo sesión actual, continuando con otras configuraciones..."
        SKIP_AUTH=true
    fi
fi

if [ "$SKIP_AUTH" != "true" ]; then
    # Pedir token de forma segura
    echo "🔐 Introduce tu Personal Access Token de GitHub:"
    echo "(El token no se mostrará en pantalla por seguridad)"
    read -s GITHUB_TOKEN
    echo ""

    # Verificar que se introdujo un token
    if [ -z "$GITHUB_TOKEN" ]; then
        echo "❌ Error: No se introdujo ningún token"
        exit 1
    fi

    # Autenticar con token
    echo "🔐 Autenticando con token..."
    echo "$GITHUB_TOKEN" | gh auth login --with-token --hostname github.com

    if [ $? -eq 0 ]; then
        echo "✅ Autenticación exitosa"
    else
        echo "❌ Error en autenticación"
        exit 1
    fi
fi

# Configurar protocolo SSH (solo si gh config es writable)
if is_writable_config ~/.config/gh/config.yml; then
    gh config set git_protocol ssh 2>/dev/null || true
fi

# Configurar Git global (solo si NO está gestionado por Nix)
if [ "$GIT_MANAGED_BY_NIX" = false ]; then
    echo "⚙️ Configurando Git global..."
    git config --global user.name "Roberto Flores"
    git config --global user.email "25asab015@ujmd.edu.sv"
else
    echo "⏭️  Saltando configuración de Git (gestionado por Home Manager)"
fi

# Generar llave SSH si no existe
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "🔑 Generando llave SSH ed25519..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "25asab015@ujmd.edu.sv"
else
    echo "✅ Llave SSH ya existe"
fi

# Generar llave GPG si no existe
if ! gpg --list-secret-keys 2>/dev/null | grep -q "Roberto Flores"; then
    echo "🔐 Generando llave GPG..."
    cat > /tmp/gpg_batch << 'EOF'
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Roberto Flores
Name-Email: 25asab015@ujmd.edu.sv
Expire-Date: 0
%no-protection
%commit
EOF
    gpg --batch --generate-key /tmp/gpg_batch
    rm /tmp/gpg_batch
else
    echo "✅ Llave GPG ya existe"
fi

# Obtener IDs de llaves
SSH_KEY_TITLE="nixos-$(hostname)-$(date +%Y%m%d)"

# Obtener GPG key ID de forma más robusta
echo "🔍 Buscando llave GPG existente..."
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format SHORT "Roberto Flores" 2>/dev/null | grep "^sec" | head -1 | awk '{print $2}' | cut -d'/' -f2)

# Si no encuentra con el nombre completo, buscar por email
if [ -z "$GPG_KEY_ID" ]; then
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format SHORT "25asab015@ujmd.edu.sv" 2>/dev/null | grep "^sec" | head -1 | awk '{print $2}' | cut -d'/' -f2)
fi

# Si aún no encuentra, buscar cualquier llave RSA reciente
if [ -z "$GPG_KEY_ID" ]; then
    GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format SHORT 2>/dev/null | grep "^sec" | grep "rsa4096" | head -1 | awk '{print $2}' | cut -d'/' -f2)
fi

echo "🔑 GPG Key ID encontrado: $GPG_KEY_ID"

echo "📤 Agregando llave SSH a GitHub..."
if gh ssh-key add ~/.ssh/id_ed25519.pub --title "$SSH_KEY_TITLE" 2>/dev/null; then
    echo "✅ Llave SSH agregada"
else
    echo "ℹ️  Llave SSH ya existe en GitHub"
fi

echo "📤 Agregando llave GPG a GitHub..."
if [ -n "$GPG_KEY_ID" ]; then
    if gpg --armor --export $GPG_KEY_ID | gh gpg-key add - 2>/dev/null; then
        echo "✅ Llave GPG agregada exitosamente"
    else
        echo "ℹ️  La llave GPG ya existe en GitHub"
    fi
else
    echo "⚠️  No se encontró llave GPG válida"
fi

# Función para actualizar archivo .nix automáticamente
update_nix_config() {
    local key="$1"
    local config_file="$HOME/Dotfiles/modules/hm/hydenix-config.nix"
    
    if [ ! -f "$config_file" ]; then
        echo "⚠️  No se encontró $config_file"
        return 1
    fi
    
    # Buscar y reemplazar la línea de signingKey
    if grep -q 'gpg.signingKey' "$config_file"; then
        sed -i "s/gpg\.signingKey = \"[^\"]*\"/gpg.signingKey = \"$key\"/" "$config_file"
        echo "✅ Actualizado gpg.signingKey = \"$key\" en hydenix-config.nix"
        return 0
    else
        echo "⚠️  No se encontró gpg.signingKey en el archivo"
        return 1
    fi
}

# Configurar firma automática (solo si NO está gestionado por Nix)
if [ "$GIT_MANAGED_BY_NIX" = false ]; then
    echo "✍️ Configurando firma automática..."
    if [ -n "$GPG_KEY_ID" ]; then
        git config --global user.signingkey $GPG_KEY_ID
        git config --global commit.gpgsign true
        git config --global tag.gpgsign true
        echo "✅ Firma automática configurada"
    else
        echo "⚠️  Advertencia: No se pudo configurar firma automática (no hay llave GPG)"
    fi
else
    echo "⏭️  Saltando configuración de firma Git (gestionado por Home Manager)"
    if [ -n "$GPG_KEY_ID" ]; then
        # Verificar si la key es diferente a la configurada
        CONFIG_FILE="$HOME/Dotfiles/modules/hm/hydenix-config.nix"
        CURRENT_KEY=$(grep -oP 'gpg\.signingKey = "\K[^"]+' "$CONFIG_FILE" 2>/dev/null || echo "")
        
        if [ "$CURRENT_KEY" != "$GPG_KEY_ID" ]; then
            echo ""
            echo "⚠️  GPG Key diferente detectada:"
            echo "   Actual en sistema: $GPG_KEY_ID"
            echo "   Configurada en .nix: $CURRENT_KEY"
            echo ""
            read -p "¿Actualizar hydenix-config.nix automáticamente? (S/n): " update_config
            if [[ ! "$update_config" =~ ^[nN]$ ]]; then
                if update_nix_config "$GPG_KEY_ID"; then
                    NEEDS_REBUILD=true
                fi
            fi
        else
            echo "✅ GPG Key ya está correctamente configurada"
        fi
    fi
fi

# Configurar GPG_TTY para diferentes shells
echo "🔧 Configurando GPG_TTY..."

# Para bash (solo si es writable)
if [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
    if ! grep -q "GPG_TTY" ~/.bashrc; then
        echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
        echo "  ✅ Configurado en ~/.bashrc"
    fi
fi

# Para zsh (solo si es writable y no gestionado por nix)
if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
    if ! grep -q "GPG_TTY" ~/.zshrc; then
        echo 'export GPG_TTY=$(tty)' >> ~/.zshrc
        echo "  ✅ Configurado en ~/.zshrc"
    fi
fi

# Para fish (crear en conf.d que siempre es writable)
if command_exists fish && [ -d ~/.config/fish ]; then
    mkdir -p ~/.config/fish/conf.d
    if [ ! -f ~/.config/fish/conf.d/gpg.fish ]; then
        echo 'set -x GPG_TTY (tty)' > ~/.config/fish/conf.d/gpg.fish
        echo "  ✅ Configurado en ~/.config/fish/conf.d/gpg.fish"
    fi
fi

# Configurar GPG para uso con pinentry correcto en NixOS
echo "🔧 Configurando GPG para NixOS..."
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# Configurar gpg-agent.conf (solo si no existe o es writable)
if [ ! -f ~/.gnupg/gpg-agent.conf ] || [ ! -L ~/.gnupg/gpg-agent.conf ]; then
    cat > ~/.gnupg/gpg-agent.conf << 'EOF'
# Configuración para NixOS
default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support
EOF
    echo "  ✅ gpg-agent.conf configurado"
fi

# Recargar gpg-agent
gpgconf --kill gpg-agent 2>/dev/null || true
gpgconf --launch gpg-agent 2>/dev/null || true

# Limpiar variables sensibles
unset GITHUB_TOKEN

echo ""
echo "🎉 ¡CONFIGURACIÓN COMPLETADA!"
echo ""
echo "📋 RESUMEN:"
echo "- Autenticación GitHub: ✅"
echo "- Llave SSH: ✅"
if [ -n "$GPG_KEY_ID" ]; then
    echo "- GPG Key ID: $GPG_KEY_ID ✅"
else
    echo "- GPG Key: ⚠️ No encontrada"
fi

# Si se modificó el archivo .nix, ofrecer hacer rebuild
if [ "$NEEDS_REBUILD" = true ]; then
    echo ""
    echo "📦 Se modificó hydenix-config.nix"
    read -p "¿Ejecutar 'sudo nixos-rebuild switch' ahora? (S/n): " do_rebuild
    if [[ ! "$do_rebuild" =~ ^[nN]$ ]]; then
        echo ""
        echo "🔄 Ejecutando nixos-rebuild switch..."
        cd ~/Dotfiles
        if sudo nixos-rebuild switch --flake .#hydenix; then
            echo "✅ Rebuild completado exitosamente"
        else
            echo "❌ Error en rebuild. Ejecuta manualmente:"
            echo "   cd ~/Dotfiles && sudo nixos-rebuild switch --flake .#hydenix"
        fi
    else
        echo ""
        echo "⚠️  Recuerda ejecutar cuando puedas:"
        echo "   cd ~/Dotfiles && sudo nixos-rebuild switch --flake .#hydenix"
    fi
fi

echo ""
echo "✅ ¡Listo! Puedes probar con: gh auth status"
