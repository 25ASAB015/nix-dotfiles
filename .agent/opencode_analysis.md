# Análisis: OpenCode - Ubicación y Organización

## 📋 Resumen Ejecutivo

Este documento analiza la ubicación actual de **OpenCode** (`modules/hm/programs/terminal/software/opencode/`) y propone recomendaciones para su organización dentro de la estructura de dotfiles.

---

## 🔍 Análisis Actual

### ¿Qué es OpenCode?

**OpenCode** es un **Terminal AI Assistant** - una herramienta de línea de comandos que permite interactuar con modelos de IA (Claude, Gemini, GPT, etc.) directamente desde la terminal.

**Características principales**:
- ✅ Herramienta CLI (no es un editor de código)
- ✅ Soporte para múltiples proveedores de IA
- ✅ Integración con LSP para autocompletado
- ✅ Skills personalizables
- ✅ Integración con MCP (Model Context Protocol) servers
- ✅ Plugin antigravity para acceso gratuito a modelos premium

### Ubicación Actual

```
modules/hm/programs/terminal/software/opencode/
├── default.nix          # Módulo principal
├── _languages.nix       # Configuración de LSP y formatters
├── _providers.nix       # Configuración de proveedores de IA
└── _skills.nix          # Skills personalizables
```

**Importado en**: `modules/hm/programs/terminal/software/default.nix`

---

## 🤔 Análisis de Ubicación

### Opción 1: Mantener en `terminal/software/` (ACTUAL) ✅

**Ventajas**:
- ✅ Es una herramienta CLI, tiene sentido en terminal/software
- ✅ Consistente con otras herramientas CLI (gh, git, lazygit, etc.)
- ✅ No requiere cambios
- ✅ Ya está bien organizado con subarchivos

**Desventajas**:
- ⚠️ No es específicamente una herramienta de terminal (podría usarse en otros contextos)
- ⚠️ Es más una herramienta de IA que una herramienta de terminal genérica

**Veredicto**: ✅ **Razonable, pero no ideal**

---

### Opción 2: Crear categoría `ai-tools/` o `ai-assistants/`

**Estructura propuesta**:
```
modules/hm/programs/
├── ai-tools/              # Nueva categoría
│   ├── default.nix
│   └── opencode/
│       ├── default.nix
│       ├── _languages.nix
│       ├── _providers.nix
│       └── _skills.nix
```

**Ventajas**:
- ✅ Categorización clara: herramientas de IA
- ✅ Escalable: fácil agregar más herramientas de IA en el futuro
- ✅ Separación semántica: no es solo "software de terminal"
- ✅ Mejor organización conceptual

**Desventajas**:
- ⚠️ Requiere crear nueva estructura
- ⚠️ Cambios en imports
- ⚠️ Por ahora solo hay una herramienta (opencode)

**Veredicto**: ✅ **Ideal para el futuro, pero puede ser prematuro**

---

### Opción 3: Mover a `development/`

**Estructura propuesta**:
```
modules/hm/programs/development/
├── default.nix
├── direnv.nix
├── languages.nix
├── nix-tools.nix
└── opencode/              # Agregar aquí
```

**Ventajas**:
- ✅ OpenCode se usa principalmente para desarrollo
- ✅ Ya existe la categoría development

**Desventajas**:
- ⚠️ OpenCode no es específicamente una herramienta de desarrollo
- ⚠️ Puede usarse para otras tareas (no solo código)
- ⚠️ Mezcla conceptos diferentes

**Veredicto**: ❌ **No recomendado**

---

## 💡 Recomendación

### Recomendación Principal: **Opción 2 - Crear `ai-tools/`**

**Razones**:
1. **Categorización semántica**: OpenCode es una herramienta de IA, no solo software de terminal
2. **Escalabilidad**: Fácil agregar más herramientas de IA en el futuro (ej: otros asistentes CLI)
3. **Claridad**: La estructura refleja mejor el propósito de la herramienta
4. **Consistencia**: Sigue el patrón de organización por categoría (editors/, browsers/, etc.)

### Plan de Implementación

#### FASE 1: Crear estructura `ai-tools/`

```bash
mkdir -p modules/hm/programs/ai-tools
```

#### FASE 2: Crear `ai-tools/default.nix`

```nix
# modules/hm/programs/ai-tools/default.nix
{ ... }:

{
  imports = [
    ./opencode
  ];
}
```

#### FASE 3: Mover directorio opencode

```bash
mv modules/hm/programs/terminal/software/opencode \
   modules/hm/programs/ai-tools/opencode
```

#### FASE 4: Actualizar imports

**En `modules/hm/programs/default.nix`**:
```nix
{
  imports = [
    ./terminal
    ./browsers
    ./development
    ./system
    ./document-viewers
    ./editors
    ./ai-tools        # NUEVO
  ];
}
```

**En `modules/hm/programs/terminal/software/default.nix`**:
```nix
{
  imports = [
    # ... otros imports ...
    # ./opencode     # REMOVER esta línea
  ];
}
```

#### FASE 5: Verificar y actualizar referencias

- Verificar que no hay referencias rotas
- Actualizar documentación si existe
- Probar que todo funciona

---

## 📊 Comparación de Opciones

| Criterio | Opción 1 (Actual) | Opción 2 (ai-tools/) | Opción 3 (development/) |
|----------|-------------------|---------------------|------------------------|
| **Claridad semántica** | ⚠️ Media | ✅ Alta | ❌ Baja |
| **Escalabilidad** | ⚠️ Limitada | ✅ Excelente | ⚠️ Media |
| **Esfuerzo de cambio** | ✅ Ninguno | ⚠️ Moderado | ⚠️ Moderado |
| **Consistencia** | ⚠️ Media | ✅ Alta | ❌ Baja |
| **Mantenibilidad** | ⚠️ Media | ✅ Alta | ⚠️ Media |

---

## 🎯 Recomendación Final

### Opción Recomendada: **Crear `ai-tools/`**

**Justificación**:
- OpenCode es claramente una herramienta de IA, no solo software de terminal
- La estructura actual funciona, pero no refleja bien el propósito
- Crear `ai-tools/` es escalable y claro
- Sigue el patrón de organización por categoría

### Alternativa: **Mantener actual (si no hay tiempo)**

Si no quieres hacer cambios ahora, la ubicación actual es **funcionalmente correcta**. OpenCode es una herramienta CLI y tiene sentido en `terminal/software/`. Sin embargo, no es la organización más semánticamente clara.

---

## 📝 Checklist de Implementación (si se elige Opción 2)

- [ ] Crear directorio `modules/hm/programs/ai-tools/`
- [ ] Crear `ai-tools/default.nix` con import de opencode
- [ ] Mover `opencode/` de `terminal/software/` a `ai-tools/`
- [ ] Actualizar `programs/default.nix` para importar `ai-tools`
- [ ] Remover import de opencode en `terminal/software/default.nix`
- [ ] Verificar sintaxis Nix
- [ ] Probar que opencode funciona después del cambio
- [ ] Actualizar documentación si existe
- [ ] Commit y push

---

## 🔄 Consideraciones Adicionales

### ¿Cuándo hacer el cambio?

**Hacer ahora si**:
- ✅ Quieres mejorar la organización a largo plazo
- ✅ Planeas agregar más herramientas de IA
- ✅ Tienes tiempo para testing

**Esperar si**:
- ⚠️ Estás en medio de otros cambios importantes
- ⚠️ No planeas agregar más herramientas de IA pronto
- ⚠️ La ubicación actual no te molesta

### Impacto del Cambio

**Riesgo**: Bajo
- Solo cambia la ubicación del módulo
- No cambia la funcionalidad
- Fácil de revertir si hay problemas

**Beneficio**: Alto
- Mejor organización
- Más escalable
- Más claro semánticamente

---

## 📚 Referencias

- **OpenCode**: https://github.com/anomalyco/opencode
- **Estructura actual**: `modules/hm/programs/terminal/software/opencode/`
- **Configuración**: `modules/hm/hydenix-config.nix` (líneas 165-198)

---

**Fecha de análisis**: 2026-01-23  
**Estado**: ✅ Listo para decisión

