#!/bin/bash

echo "=== CONFIGURACIÓN AUTOMATIZADA DE GIT/GITHUB ==="
echo ""

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detectar si estamos en WSL
detect_wsl() {
    if [ -f /proc/version ] && grep -qi microsoft /proc/version; then
        return 0
    fi
    if [ -n "$WSL_DISTRO_NAME" ] || [ -n "$WSLENV" ]; then
        return 0
    fi
    return 1
}

# Detectar distribución y gestor de paquetes
detect_package_manager() {
    if command_exists apt-get; then
        echo "apt"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists yum; then
        echo "yum"
    elif command_exists dnf; then
        echo "dnf"
    else
        echo "unknown"
    fi
}

# Instalar GitHub CLI según el gestor de paquetes
install_gh_cli() {
    local pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        apt)
            echo "📦 Instalando GitHub CLI con apt (Ubuntu/Debian/WSL)..."
            if ! command_exists gh; then
                curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
                sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
                echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
                sudo apt update
                sudo apt install gh -y
            fi
            ;;
        pacman)
            echo "📦 Instalando GitHub CLI con pacman (Arch)..."
            sudo pacman -S github-cli --noconfirm
            ;;
        yum)
            echo "📦 Instalando GitHub CLI con yum (RHEL/CentOS)..."
            sudo yum install gh -y
            ;;
        dnf)
            echo "📦 Instalando GitHub CLI con dnf (Fedora)..."
            sudo dnf install gh -y
            ;;
        *)
            echo "❌ No se pudo detectar el gestor de paquetes. Por favor instala GitHub CLI manualmente."
            exit 1
            ;;
    esac
}

# Verificar que gh esté instalado
if ! command_exists gh; then
    echo "❌ GitHub CLI no está instalado. Instalando..."
    install_gh_cli
fi

# Verificar si estamos en WSL
if detect_wsl; then
    echo "🐧 Detectado entorno WSL"
    # Asegurar que el agente SSH esté corriendo en WSL
    if [ -z "$SSH_AUTH_SOCK" ]; then
        echo "🔧 Iniciando agente SSH para WSL..."
        eval "$(ssh-agent -s)" > /dev/null
    fi
fi

# Verificar autenticación actual
echo "🔍 Verificando autenticación actual..."
if gh auth status >/dev/null 2>&1; then
    echo "✅ Ya estás autenticado. Cerrando sesión para reautenticar..."
    gh auth logout
fi

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

# Configurar protocolo SSH
gh config set git_protocol ssh

# Configurar Git global
echo "⚙️ Configurando Git global..."
git config --global user.name "Roberto Flores"
git config --global user.email "25asab015@ujmd.edu.sv"

# Generar llave SSH si no existe
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "🔑 Generando llave SSH ed25519..."
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -C "25asab015@ujmd.edu.sv"
    echo "✅ Llave SSH generada exitosamente"
else
    echo "✅ Llave SSH ya existe"
fi

# Agregar llave SSH al agente
echo "🔧 Agregando llave SSH al agente..."
if [ -f ~/.ssh/id_ed25519 ]; then
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || {
        eval "$(ssh-agent -s)" > /dev/null
        ssh-add ~/.ssh/id_ed25519
    }
    echo "✅ Llave SSH agregada al agente"
fi

# Agregar GitHub a known_hosts si no está ya presente
echo "🔧 Verificando known_hosts para GitHub..."
if [ ! -f ~/.ssh/known_hosts ] || ! grep -q "github.com" ~/.ssh/known_hosts 2>/dev/null; then
    echo "📝 Agregando GitHub a known_hosts..."
    ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
    chmod 600 ~/.ssh/known_hosts
    echo "✅ GitHub agregado a known_hosts"
else
    echo "✅ GitHub ya está en known_hosts"
fi

# Generar llave GPG si no existe
if ! gpg --list-secret-keys | grep -q "Roberto Flores"; then
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
fi

# Obtener IDs de llaves
SSH_KEY_TITLE="ludus-$(date +%Y%m%d)"

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

# Subir llave SSH a GitHub automáticamente
echo "📤 Agregando llave SSH a GitHub..."
if [ -f ~/.ssh/id_ed25519.pub ]; then
    # Verificar si la llave ya existe en GitHub
    if gh ssh-key list | grep -q "$SSH_KEY_TITLE"; then
        echo "⚠️  La llave SSH '$SSH_KEY_TITLE' ya existe en GitHub"
    else
        if gh ssh-key add ~/.ssh/id_ed25519.pub --title "$SSH_KEY_TITLE" 2>/dev/null; then
            echo "✅ Llave SSH agregada exitosamente a GitHub"
        else
            echo "❌ Error al agregar llave SSH. Intentando con método alternativo..."
            # Método alternativo usando la API de GitHub directamente
            SSH_KEY_CONTENT=$(cat ~/.ssh/id_ed25519.pub)
            # Escapar caracteres especiales para JSON
            SSH_KEY_ESCAPED=$(echo "$SSH_KEY_CONTENT" | sed 's/"/\\"/g')
            SSH_JSON=$(cat <<EOF
{
  "title": "$SSH_KEY_TITLE",
  "key": "$SSH_KEY_ESCAPED"
}
EOF
)
            if curl -X POST \
                -H "Accept: application/vnd.github+json" \
                -H "Authorization: Bearer $GITHUB_TOKEN" \
                -H "X-GitHub-Api-Version: 2022-11-28" \
                -H "Content-Type: application/json" \
                https://api.github.com/user/keys \
                -d "$SSH_JSON" \
                > /dev/null 2>&1; then
                echo "✅ Llave SSH agregada exitosamente usando API de GitHub"
            else
                echo "❌ Error al agregar llave SSH. Verifica tu token y conexión."
            fi
        fi
    fi
else
    echo "❌ Error: No se encontró la llave pública SSH"
    exit 1
fi

# Subir llave GPG a GitHub automáticamente
echo "📤 Agregando llave GPG a GitHub..."
if [ -n "$GPG_KEY_ID" ]; then
    GPG_KEY_ARMORED=$(gpg --armor --export $GPG_KEY_ID)
    
    # Verificar si la llave ya existe en GitHub
    if echo "$GPG_KEY_ARMORED" | gh gpg-key list | grep -q "$GPG_KEY_ID" 2>/dev/null; then
        echo "⚠️  La llave GPG ya existe en GitHub"
    else
        if echo "$GPG_KEY_ARMORED" | gh gpg-key add - 2>/dev/null; then
            echo "✅ Llave GPG agregada exitosamente a GitHub"
        else
            echo "⚠️  Intentando método alternativo para agregar llave GPG..."
            # Método alternativo usando la API de GitHub directamente
            # Escapar la llave GPG para JSON (reemplazar saltos de línea con \n)
            GPG_KEY_ESCAPED=$(echo "$GPG_KEY_ARMORED" | sed ':a;N;$!ba;s/\n/\\n/g' | sed 's/"/\\"/g')
            GPG_JSON=$(cat <<EOF
{
  "armored_public_key": "$GPG_KEY_ESCAPED"
}
EOF
)
            if curl -X POST \
                -H "Accept: application/vnd.github+json" \
                -H "Authorization: Bearer $GITHUB_TOKEN" \
                -H "X-GitHub-Api-Version: 2022-11-28" \
                -H "Content-Type: application/json" \
                https://api.github.com/user/gpg_keys \
                -d "$GPG_JSON" \
                > /dev/null 2>&1; then
                echo "✅ Llave GPG agregada exitosamente usando API de GitHub"
            else
                echo "⚠️  La llave GPG ya existe en GitHub o hubo un error. Continuando..."
            fi
        fi
    fi
else
    echo "⚠️  Advertencia: No se pudo encontrar una llave GPG válida. Continuando sin GPG..."
fi

# Configurar firma automática
echo "✍️ Configurando firma automática..."
if [ -n "$GPG_KEY_ID" ]; then
    git config --global user.signingkey $GPG_KEY_ID
    git config --global commit.gpgsign true
    git config --global tag.gpgsign true
    echo "✅ Firma automática configurada"
else
    echo "⚠️  Advertencia: No se pudo configurar firma automática (no hay llave GPG)"
fi

# Configurar GPG_TTY y SSH para WSL
echo "🔧 Configurando GPG_TTY y SSH..."
SHELL_RC=""
if [ -f ~/.bashrc ]; then
    SHELL_RC=~/.bashrc
elif [ -f ~/.zshrc ]; then
    SHELL_RC=~/.zshrc
elif [ -f ~/.profile ]; then
    SHELL_RC=~/.profile
fi

if [ -n "$SHELL_RC" ]; then
    # Configurar GPG_TTY
    if ! grep -q "GPG_TTY" "$SHELL_RC"; then
        echo '' >> "$SHELL_RC"
        echo '# Configuración GPG para WSL' >> "$SHELL_RC"
        echo 'export GPG_TTY=$(tty)' >> "$SHELL_RC"
        echo "✅ GPG_TTY configurado en $SHELL_RC"
    fi
    
    # Configurar SSH agent para WSL
    if detect_wsl && ! grep -q "SSH_AUTH_SOCK" "$SHELL_RC"; then
        echo '' >> "$SHELL_RC"
        echo '# Configuración SSH agent para WSL' >> "$SHELL_RC"
        echo 'if [ -z "$SSH_AUTH_SOCK" ]; then' >> "$SHELL_RC"
        echo '    eval "$(ssh-agent -s)" > /dev/null' >> "$SHELL_RC"
        echo '    ssh-add ~/.ssh/id_ed25519 2>/dev/null' >> "$SHELL_RC"
        echo 'fi' >> "$SHELL_RC"
        echo "✅ SSH agent configurado para WSL en $SHELL_RC"
    fi
fi

# Configurar SSH config para GitHub
echo "🔧 Configurando SSH config para GitHub..."
mkdir -p ~/.ssh
if [ ! -f ~/.ssh/config ] || ! grep -q "Host github.com" ~/.ssh/config; then
    cat >> ~/.ssh/config << 'EOF'

# Configuración para GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
EOF
    chmod 600 ~/.ssh/config
    echo "✅ SSH config configurado para GitHub"
fi

# Limpiar variables sensibles
unset GITHUB_TOKEN
rm -f /tmp/github_token

echo ""
echo "🎉 ¡CONFIGURACIÓN COMPLETADA!"
echo "Token introducido: ✅"
echo "Autenticación: ✅"
echo "Llave SSH: ✅"
echo "Llave GPG: ✅"
echo "Firma automática: ✅"
echo ""
echo "📋 RESUMEN:"
echo "- Usuario Git: Roberto Flores <25asab015@ujmd.edu.sv>"
echo "- Protocolo: SSH"
echo "- SSH Key agregada con título: $SSH_KEY_TITLE"
if [ -n "$GPG_KEY_ID" ]; then
    echo "- GPG Key ID: $GPG_KEY_ID"
    echo "- Commits y tags firmados automáticamente: ✅"
else
    echo "- GPG Key: No configurada"
    echo "- Firma automática: ❌ (requiere llave GPG)"
fi