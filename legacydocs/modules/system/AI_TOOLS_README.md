# AI Tools Unrestricted Configuration

## 🎯 Propósito

Este módulo elimina restricciones del sistema para dar **libertad total** a herramientas AI como:
- 🤖 **Cursor** (AI-powered IDE)
- 💻 **VSCode** con extensiones AI
- 🚀 **Antigravity** (OpenCode plugin)
- 🧠 **OpenCode** (Terminal AI assistant)

## ⚠️ Advertencia de Seguridad

Esta configuración **ELIMINA protecciones de seguridad** para maximizar funcionalidad:

| Protección Eliminada | Razón | Impacto |
|----------------------|-------|---------|
| Nix Sandbox | Permite ejecución sin restricciones | 🔴 Alto |
| Sudo sin contraseña | Comandos root sin fricción | 🔴 Alto |
| AppArmor disabled | Sin perfiles de seguridad | 🟡 Medio |
| Grupos privilegiados | Acceso completo al sistema | 🔴 Alto |

**✅ Usar en:** Máquinas de desarrollo local  
**❌ NO usar en:** Servidores, VMs expuestas, laptops en redes públicas

---

## 🔧 Qué Hace Este Módulo

### 1. Nix Settings Sin Restricciones
```nix
sandbox = false                    # No sandbox en builds
filter-syscalls = false            # Sin filtro de syscalls
trusted-users = ["root" "@wheel"]  # Usuario confiable
```

**Resultado:** Cursor puede ejecutar comandos git, build tools, sin errores de permisos.

### 2. Grupos de Usuario Expandidos
```nix
extraGroups = [
  "wheel"           # Sudo completo
  "docker"          # Docker sin sudo
  "libvirtd"        # VMs
  "systemd-journal" # Logs
  "disk"            # Acceso a discos
  ...
]
```

**Resultado:** AI tools pueden leer logs, gestionar containers, acceder hardware.

### 3. Sudo Sin Contraseña
```nix
wheelNeedsPassword = false
```

**Resultado:** `sudo nixos-rebuild`, `sudo systemctl`, etc. sin prompt.

### 4. Git Sin Restricciones
```nix
[safe]
  directory = *
```

**Resultado:** Git funciona en cualquier directorio sin errores de `safe.directory`.

### 5. Variables de Entorno
```nix
NIX_LD = "..."           # Ejecutar binarios no-NixOS
SANDBOX = "false"        # Sin sandboxing
```

**Resultado:** Herramientas como npm, pip, cargo funcionan sin problemas.

---

## 🚀 Cómo Activar

Ya está incluido en `modules/system/default.nix`:

```nix
imports = [
  ./ai-tools-unrestricted.nix  # ✅ Ya importado
];
```

Para aplicar:
```bash
sudo nixos-rebuild switch --flake ~/dotfiles#hydenix
```

---

## 🔒 Cómo Revertir (Restaurar Seguridad)

Si necesitas más seguridad:

### Opción 1: Comentar el import
```nix
# modules/system/default.nix
imports = [
  # ./ai-tools-unrestricted.nix  # ← Comentar esta línea
];
```

### Opción 2: Editar el módulo
```nix
# modules/system/ai-tools-unrestricted.nix
nix.settings.sandbox = true;  # Activar sandbox
security.sudo.wheelNeedsPassword = true;  # Pedir contraseña
```

### Opción 3: Crear versiones por host
```nix
# hosts/hydenix/configuration.nix (PC local - sin restricciones)
imports = [ ../../modules/system/ai-tools-unrestricted.nix ];

# hosts/laptop/configuration.nix (laptop público - con restricciones)
imports = [ ]; # No importar ai-tools-unrestricted
```

---

## 🐛 Problemas Solucionados

### Antes (Con Restricciones)
```bash
# Terminal en Cursor
$ git status
fatal: detected dubious ownership

$ sudo systemctl restart service
[sudo] password for ludus:  # ← Interrumpe workflow

$ nix build
error: cannot build in sandbox mode
```

### Después (Sin Restricciones)
```bash
# Terminal en Cursor
$ git status
On branch main  # ✅ Funciona

$ sudo systemctl restart service  # ✅ Sin password

$ nix build  # ✅ Sin errores de sandbox
```

---

## 📊 Comparación

| Feature | Con Restricciones | Sin Restricciones |
|---------|-------------------|-------------------|
| Cursor git commands | ❌ Errores safe.directory | ✅ Funciona |
| OpenCode ejecutar comandos | ⚠️ Limitado | ✅ Total libertad |
| Sudo en scripts | 🔴 Pide password | ✅ Sin fricción |
| Nix builds | ⚠️ Sandbox errors | ✅ Sin problemas |
| AI agents autonomía | 🟡 Media | ✅ Completa |

---

## 🎓 Para Entender Más

### ¿Por qué Cursor tenía problemas?

1. **Nix Sandbox**: Aísla ejecución de comandos
   - AI agents ejecutan git, make, etc.
   - Sandbox bloqueaba acceso al filesystem
   - Resultado: output vacío o errors

2. **Safe Directory**: Git protección contra repos maliciosos
   - Cursor clona/accede repos
   - Git requiere ownership check
   - Resultado: `fatal: detected dubious ownership`

3. **Sudo Password**: Muchas operaciones NixOS requieren root
   - `nixos-rebuild`, `systemctl`
   - Prompt interrumpe workflow AI
   - Resultado: comandos fallan en scripts

### ¿Es seguro?

**Para desarrollo local en PC personal:** ✅ Sí
- No hay usuarios maliciosos en tu máquina
- Tu usuario = tú confías en ti mismo
- Beneficio > riesgo

**Para laptop en cafetería:** ⚠️ Precaución
- Redes públicas = mayor riesgo
- Considera mantener sudo password
- Usar VPN siempre

**Para servidor/VM expuesta:** ❌ No
- Usar configuración segura
- No aplicar este módulo
- Seguir best practices

---

## ✅ Testing

Después de aplicar, prueba que todo funciona:

```bash
# 1. Git sin restricciones
git status  # ✅ Sin errores

# 2. Sudo sin password
sudo echo "test"  # ✅ Sin prompt

# 3. Nix build sin sandbox
nix build  # ✅ Sin errores

# 4. Cursor terminal
# Abre Cursor terminal y prueba comandos
```

---

## 🔗 Referencias

- [NixOS Security](https://nixos.org/manual/nixos/stable/index.html#sec-security)
- [Nix Sandbox](https://nixos.org/manual/nix/stable/advanced-topics/diff-hook.html)
- [Polkit Configuration](https://www.freedesktop.org/software/polkit/docs/latest/)

---

**Configurado por:** AGENTS.md migration  
**Fecha:** 2026-01-10  
**Versión:** 1.0

