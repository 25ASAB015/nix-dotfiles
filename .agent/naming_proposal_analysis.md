# Análisis: Propuesta de Nomenclatura - gui-editors/ y cli-editors/

## 📋 Propuesta Original

- `editors/` → `gui-editors/` (VS Code, Cursor, AntiGravity)
- `ai-tools/` → `cli-editors/` (OpenCode)

---

## 🔍 Análisis de la Propuesta

### ✅ Aspectos Positivos

1. **`gui-editors/` es claro y descriptivo**
   - ✅ VS Code, Cursor y AntiGravity son editores con interfaz gráfica
   - ✅ La nomenclatura es explícita sobre el tipo de herramienta
   - ✅ Facilita entender que son editores visuales

2. **Separación GUI vs CLI**
   - ✅ Distingue claramente entre herramientas gráficas y de línea de comandos
   - ✅ Útil si en el futuro agregas editores CLI (vim, nano, etc.)

---

## ⚠️ Problemas con `cli-editors/`

### Problema Principal: OpenCode NO es un Editor

**OpenCode es un Asistente de IA**, no un editor de código:

| Característica | Editor (VS Code, Cursor) | OpenCode |
|---------------|-------------------------|----------|
| **Edita archivos** | ✅ Sí | ❌ No |
| **Interfaz visual** | ✅ Sí (GUI) | ❌ No (CLI) |
| **Abre archivos** | ✅ Sí | ❌ No |
| **Autocompletado** | ✅ Sí (LSP) | ✅ Sí (pero solo sugiere) |
| **Función principal** | Editar código | Asistir con prompts de IA |

**OpenCode**:
- Es un asistente de IA para terminal
- Responde preguntas y genera código
- No edita archivos directamente
- Se usa con prompts, no abriendo archivos

### Confusión Semántica

Si llamamos a OpenCode "cli-editor", puede confundir porque:
- ❌ No es un editor (no edita archivos)
- ❌ Es un asistente/helper de IA
- ❌ La gente esperaría poder editar código con él

---

## 💡 Alternativas Mejores

### Opción A: `gui-editors/` + `ai-assistants/` ✅ RECOMENDADA

```
modules/hm/programs/
├── gui-editors/          # Editores con interfaz gráfica
│   ├── vscode.nix
│   ├── cursor.nix
│   └── antigravity.nix
└── ai-assistants/        # Asistentes de IA (CLI)
    └── opencode/
```

**Ventajas**:
- ✅ `gui-editors/` es claro y descriptivo
- ✅ `ai-assistants/` describe correctamente qué es OpenCode
- ✅ Escalable: fácil agregar más asistentes de IA
- ✅ Semánticamente correcto

**Desventajas**:
- ⚠️ Requiere renombrar `editors/` a `gui-editors/`

---

### Opción B: `gui-editors/` + `terminal/ai-tools/`

```
modules/hm/programs/
├── gui-editors/          # Editores con interfaz gráfica
│   ├── vscode.nix
│   ├── cursor.nix
│   └── antigravity.nix
└── terminal/
    └── ai-tools/         # Herramientas de IA para terminal
        └── opencode/
```

**Ventajas**:
- ✅ `gui-editors/` es claro
- ✅ Mantiene OpenCode en terminal (donde se usa)
- ✅ Menos cambios estructurales

**Desventajas**:
- ⚠️ OpenCode sigue en terminal/ (aunque ahora más organizado)

---

### Opción C: `editors/gui/` + `editors/cli/`

```
modules/hm/programs/editors/
├── default.nix
├── gui/
│   ├── vscode.nix
│   ├── cursor.nix
│   └── antigravity.nix
└── cli/
    └── opencode/         # Aunque OpenCode no es realmente un editor
```

**Ventajas**:
- ✅ Mantiene todo bajo `editors/`
- ✅ Separación clara GUI vs CLI

**Desventajas**:
- ❌ OpenCode no es un editor, así que está mal categorizado
- ❌ Confusión semántica

---

## 🎯 Recomendación Final

### Mejor Opción: **`gui-editors/` + `ai-assistants/`**

**Razones**:
1. **Semánticamente correcto**: 
   - `gui-editors/` describe correctamente VS Code, Cursor, AntiGravity
   - `ai-assistants/` describe correctamente OpenCode

2. **Claridad**:
   - No hay confusión sobre qué hace cada herramienta
   - La nomenclatura es autoexplicativa

3. **Escalabilidad**:
   - Fácil agregar más editores GUI
   - Fácil agregar más asistentes de IA (Claude CLI, GitHub Copilot CLI, etc.)

4. **Consistencia**:
   - Sigue el patrón de organización por propósito/función
   - Similar a cómo tienes `browsers/`, `document-viewers/`, etc.

---

## 📊 Comparación de Opciones

| Opción | Claridad | Corrección Semántica | Escalabilidad | Esfuerzo |
|--------|----------|---------------------|---------------|----------|
| `gui-editors/` + `cli-editors/` | ⚠️ Media | ❌ Baja (OpenCode no es editor) | ⚠️ Media | ⚠️ Alto |
| `gui-editors/` + `ai-assistants/` | ✅ Alta | ✅ Alta | ✅ Alta | ⚠️ Moderado |
| `gui-editors/` + `terminal/ai-tools/` | ✅ Alta | ✅ Alta | ⚠️ Media | ✅ Bajo |
| `editors/gui/` + `editors/cli/` | ⚠️ Media | ❌ Baja | ⚠️ Media | ⚠️ Moderado |

---

## 🔄 Plan de Implementación Recomendado

### Estructura Final Propuesta

```
modules/hm/programs/
├── gui-editors/              # Editores con interfaz gráfica
│   ├── default.nix
│   ├── vscode.nix
│   ├── cursor.nix
│   └── antigravity.nix
├── ai-assistants/            # Asistentes de IA (CLI)
│   ├── default.nix
│   └── opencode/
│       ├── default.nix
│       ├── _languages.nix
│       ├── _providers.nix
│       └── _skills.nix
├── browsers/
├── development/
├── terminal/
└── ...
```

### Cambios Necesarios

1. **Renombrar `editors/` → `gui-editors/`**
   - Mover todos los archivos
   - Actualizar imports en `programs/default.nix`
   - Actualizar referencias en documentación

2. **Crear `ai-assistants/`**
   - Crear directorio y `default.nix`
   - Mover `opencode/` de `terminal/software/` a `ai-assistants/`
   - Actualizar imports

3. **Actualizar documentación**
   - Referencias a `editors/` → `gui-editors/`
   - Agregar sección sobre `ai-assistants/`

---

## 💭 Consideraciones Adicionales

### ¿Vale la pena el cambio?

**Sí, si**:
- ✅ Quieres mejorar la claridad semántica
- ✅ Planeas agregar más herramientas de IA
- ✅ La nomenclatura actual te confunde

**No, si**:
- ⚠️ Estás en medio de otros cambios importantes
- ⚠️ La estructura actual funciona bien para ti
- ⚠️ No planeas expandir estas categorías

### Impacto

**Riesgo**: Bajo-Medio
- Cambios estructurales pero bien definidos
- Fácil de revertir
- Requiere actualizar imports y documentación

**Beneficio**: Alto
- Mejor organización semántica
- Más claro para nuevos usuarios
- Escalable para el futuro

---

## 🎯 Veredicto Final

### ❌ No recomiendo `cli-editors/` para OpenCode

**Razón**: OpenCode no es un editor, es un asistente de IA. Llamarlo "editor" es semánticamente incorrecto y puede confundir.

### ✅ Recomiendo `gui-editors/` + `ai-assistants/`

**Razón**: 
- `gui-editors/` es perfecto para VS Code, Cursor, AntiGravity
- `ai-assistants/` describe correctamente OpenCode
- Ambas nomenclaturas son claras y escalables

---

**Fecha de análisis**: 2026-01-23  
**Estado**: ✅ Listo para decisión

