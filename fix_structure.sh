#!/bin/bash
# Fix: Mover archivos a la estructura correcta

cd ~/dotfiles

echo "🔧 Moviendo archivos a la estructura correcta..."

# Mover browsers a programs/
mv modules/hm/software/browsers modules/hm/programs/

# Mover languages.nix a development/
mv modules/hm/software/languages.nix modules/hm/programs/development/

# Remover directorio software/ vacío
rmdir modules/hm/software/ 2>/dev/null || echo "software/ no está vacío o ya fue removido"

# Mover terminal/ a programs/
if [ -d "modules/hm/terminal" ]; then
    # Los archivos de terminal ya están en programs/terminal, verificar
    echo "✅ Terminal ya está en programs/"
fi

echo ""
echo "📝 Agregando cambios a git..."
git add -A

echo ""
echo "📊 Estado actual:"
git status --short

echo ""
echo "✅ Archivos reorganizados!"
echo ""
echo "Siguiente paso: git commit y rebuild"

