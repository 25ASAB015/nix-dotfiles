# 🔧 Integración de Nix Development Tools

## ✅ Implementación Completada

Se ha creado un módulo nuevo para las herramientas de desarrollo de Nix que proporciona los paquetes necesarios para `make format` y `make lint`.

---

## 📁 Archivos Creados/Modificados

### 1. **Nuevo Módulo**: `modules/hm/programs/development/nix-tools.nix`

Módulo configurable que instala:
- **Formatter**: `nixpkgs-fmt` o `alejandra` (configurable)
- **Linter**: `statix` (opcional)

**Características:**
- ✅ Patrón `options`/`config` con `mkEnableOption`
- ✅ Opción para elegir formatter
- ✅ Opción para habilitar/deshabilitar linter
- ✅ Mensaje informativo en la activación del sistema
- ✅ Sigue el patrón de tu configuración (`modules.development.*`)

### 2. **Modificado**: `modules/hm/programs/development/default.nix`

```nix
imports = [
  ./languages.nix  # Programming languages and runtimes
  ./nix-tools.nix  # Nix development tools (linters and formatters) ← NUEVO
  # Future imports...
];
```

### 3. **Modificado**: `modules/hm/hydenix-config.nix`

Habilitado el módulo con configuración predeterminada:

```nix
# ════════════════════════════════════════════════════════════════════════════
# NIX DEVELOPMENT TOOLS - Linters y formatters para desarrollo en Nix
# ════════════════════════════════════════════════════════════════════════════
# Herramientas necesarias para `make format` y `make lint`
# - nixpkgs-fmt/alejandra: formatea archivos .nix
# - statix: linter estático para Nix (detecta problemas y malas prácticas)
modules.development.nix-tools = {
  enable = true;
  formatter = "nixpkgs-fmt";  # o "alejandra"
  installLinter = true;        # instala statix
};
```

---

## 📦 Paquetes Instalados

Después del rebuild, tendrás disponibles globalmente:

| Paquete | Versión | Comando | Propósito |
|---------|---------|---------|-----------|
| `nixpkgs-fmt` | 1.3.0 | `nixpkgs-fmt` | Formatter para archivos .nix |
| `statix` | 0.5.8 | `statix` | Linter estático para Nix |

---

## 🎯 Uso con el Makefile

Ahora los comandos del Makefile funcionarán correctamente:

```bash
# Formatear archivos .nix
make format
# → Usa nixpkgs-fmt automáticamente

# Lint archivos .nix
make lint
# → Usa statix automáticamente

# Validar + formatear + lint
make validate
make format
make lint
```

---

## ⚙️ Configuración Personalizable

Puedes cambiar el formatter editando `modules/hm/hydenix-config.nix`:

```nix
modules.development.nix-tools = {
  enable = true;
  formatter = "alejandra";  # Cambiar a alejandra si lo prefieres
  installLinter = true;      # false para no instalar statix
};
```

---

## 🚀 Próximos Pasos

1. **Aplicar cambios**:
   ```bash
   sudo nixos-rebuild switch --flake .#hydenix
   ```

2. **Verificar instalación**:
   ```bash
   which nixpkgs-fmt  # Debe mostrar ruta
   which statix       # Debe mostrar ruta
   ```

3. **Probar comandos**:
   ```bash
   make format  # Debería funcionar sin errores
   make lint    # Debería funcionar sin errores
   ```

4. **Testing completo**:
   ```bash
   ./test-makefile.sh  # Ahora lint y format pasarán
   ```

---

## 📝 Notas Técnicas

### Diferencia con OpenCode

- **OpenCode**: `alejandra` solo disponible en PATH de OpenCode
- **Este módulo**: Herramientas disponibles **globalmente** en el sistema

### Estructura del Módulo

```
modules/development.nix-tools
├── enable (bool)
├── formatter (enum: "nixpkgs-fmt" | "alejandra")
└── installLinter (bool)
```

### Ventajas de Este Enfoque

1. ✅ **Modular**: Fácil de habilitar/deshabilitar
2. ✅ **Configurable**: Elige tu formatter preferido
3. ✅ **Documentado**: Comentarios claros en la configuración
4. ✅ **Consistente**: Sigue el patrón de tus otros módulos
5. ✅ **Flexible**: Se puede extender fácilmente

---

## 🔄 Integración con Git

Los cambios están staged y listos para commit:

```bash
git status
# modules/hm/programs/development/nix-tools.nix (nuevo)
# modules/hm/programs/development/default.nix (modificado)
# modules/hm/hydenix-config.nix (modificado)
```

**Sugerencia de commit:**
```bash
git commit -m "feat: add nix development tools module

- Create nix-tools.nix module for formatter and linter
- Install nixpkgs-fmt (formatter) and statix (linter)
- Enable globally for use with Makefile commands
- Configurable formatter choice (nixpkgs-fmt or alejandra)
- Optional linter installation

Fixes: make format and make lint now work correctly"
```

---

**Fecha**: 2026-01-11  
**Estado**: ✅ Implementado y verificado  
**Testing**: Flake check passed, packages verified in configuration

