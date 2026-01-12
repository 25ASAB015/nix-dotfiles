#!/usr/bin/env bash
# Script final: Push y crear PR

cd ~/dotfiles

echo "📝 Agregando script de reorganización..."
git add commit_reorganization.sh
git commit -m "chore: add reorganization script for future reference

Script usado para hacer commits atómicos de la migración.
Útil como referencia o para futuras reorganizaciones."

echo ""
echo "📊 Total de commits en la rama:"
git log main..HEAD --oneline
echo ""

echo "🚀 Haciendo push a GitHub..."
git push -u origin feature/reorganize-structure

echo ""
echo "✅ Push completado!"
echo ""
echo "📋 Crear PR con GitHub CLI:"
echo "gh pr create --title '🚀 Full Reorganization: Professional Structure & Multi-host Support' --body-file PR_BODY.md"
echo ""
echo "O simplemente:"
echo "gh pr create --fill"

