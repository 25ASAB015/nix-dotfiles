#!/usr/bin/env bash
# Script para aplicar la nueva configuración de seguridad

echo "════════════════════════════════════════════════════════════════"
echo "  Aplicando Nueva Configuración de Seguridad (Opción 2)"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Cambios:"
echo "  • Sudo ahora REQUIERE contraseña"
echo "  • Contraseña se recuerda por 10 minutos"
echo "  • Mayor seguridad contra acceso no autorizado"
echo ""
echo "════════════════════════════════════════════════════════════════"
echo ""

# Verificar que estamos en el directorio correcto
cd ~/dotfiles || exit 1

# Aplicar rebuild
echo "Ejecutando: sudo nixos-rebuild switch --flake ~/dotfiles#hydenix"
echo ""
sudo nixos-rebuild switch --flake ~/dotfiles#hydenix

if [ $? -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "  ✅ ¡Configuración aplicada exitosamente!"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "A partir de ahora:"
    echo "  1. Sudo pedirá contraseña la primera vez"
    echo "  2. Se recordará por 10 minutos"
    echo "  3. Después de 10 minutos, pedirá contraseña de nuevo"
    echo ""
    echo "Prueba ejecutando:"
    echo "  sudo systemctl status nix-daemon"
    echo ""
else
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "  ❌ Error al aplicar configuración"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "Si hay problemas, puedes revertir editando:"
    echo "  modules/system/ai-tools-unrestricted.nix"
    echo ""
fi

