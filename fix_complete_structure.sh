#!/usr/bin/env bash
# Fix completo: Reorganizar toda la estructura correctamente

cd ~/dotfiles

echo "🔧 Arreglando estructura completa de modules/hm/..."
echo ""

# 1. Crear estructura programs/terminal completa si no existe
echo "📁 Creando estructura programs/terminal..."
mkdir -p modules/hm/programs/terminal/{emulators,shell,software}

# 2. Mover emulators
echo "🔄 Moviendo emulators..."
if [ -d "modules/hm/terminal/emulators" ]; then
    cp -r modules/hm/terminal/emulators/* modules/hm/programs/terminal/emulators/ 2>/dev/null || true
fi

# 3. Mover shell
echo "🔄 Moviendo shell..."
if [ -d "modules/hm/terminal/shell" ]; then
    cp -r modules/hm/terminal/shell/* modules/hm/programs/terminal/shell/ 2>/dev/null || true
fi

# 4. Mover software
echo "🔄 Moviendo software..."
if [ -d "modules/hm/terminal/software" ]; then
    cp -r modules/hm/terminal/software/* modules/hm/programs/terminal/software/ 2>/dev/null || true
fi

# 5. Mover browsers
echo "🔄 Moviendo browsers..."
if [ -d "modules/hm/software/browsers" ]; then
    mkdir -p modules/hm/programs/browsers
    cp -r modules/hm/software/browsers/* modules/hm/programs/browsers/ 2>/dev/null || true
fi

# 6. Mover languages.nix
echo "🔄 Moviendo languages.nix..."
if [ -f "modules/hm/software/languages.nix" ]; then
    cp modules/hm/software/languages.nix modules/hm/programs/development/languages.nix 2>/dev/null || true
fi

# 7. Remover directorios antiguos
echo "🧹 Limpiando directorios antiguos..."
rm -rf modules/hm/terminal/ 2>/dev/null || true
rm -rf modules/hm/software/ 2>/dev/null || true

echo ""
echo "📊 Verificando estructura..."
tree -L 3 modules/hm/programs/ 2>/dev/null || find modules/hm/programs/ -type f | head -20

echo ""
echo "📝 Estado de git:"
git add -A
git status --short

echo ""
echo "✅ ¡Estructura corregida!"
echo ""
echo "Siguiente paso:"
echo "  git commit -m 'fix: complete programs/ reorganization'"
echo "  sudo nixos-rebuild switch --flake ~/dotfiles#hydenix"

