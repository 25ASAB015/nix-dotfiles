# 📚 Tutorial Completo de Makefile para NixOS

**Guía de Usuario - Tu manual esencial para gestionar Hydenix**

---

## 📖 Índice

1. [¿Qué es un Makefile?](#qué-es-un-makefile)
2. [Conceptos Básicos](#conceptos-básicos)
3. [Estructura del Makefile de Hydenix](#estructura-del-makefile-de-hydenix)
4. [Comandos por Categoría](#comandos-por-categoría)
5. [Flujos de Trabajo Comunes](#flujos-de-trabajo-comunes)
6. [Resolución de Problemas](#resolución-de-problemas)
7. [Tips y Trucos](#tips-y-trucos)

---

## ¿Qué es un Makefile?

Un **Makefile** es un archivo que contiene un conjunto de instrucciones (llamadas "reglas" o "targets") que automatizan tareas repetitivas. Originalmente diseñado para compilar programas, se usa ampliamente para cualquier flujo de trabajo que requiera automatización.

### ¿Por qué usar un Makefile en NixOS?

Los comandos de NixOS pueden ser largos y difíciles de recordar:

```bash
# Sin Makefile (tedioso)
sudo nixos-rebuild switch --flake .#hydenix --show-trace --verbose

# Con Makefile (simple)
make debug
```

**Ventajas:**
- ✅ Comandos cortos y memorables
- ✅ Menos errores tipográficos
- ✅ Consistencia en el equipo
- ✅ Documentación integrada
- ✅ Automatización de tareas complejas

---

## Conceptos Básicos

### Sintaxis Fundamental

```makefile
target: dependencias ## Descripción (se muestra en help)
	@comando1
	@comando2
```

**Componentes:**
- **target**: nombre del comando (ejemplo: `rebuild`, `test`)
- **dependencias**: otros targets que deben ejecutarse primero (opcional)
- **@**: suprime el echo del comando (sin @ verías el comando antes del resultado)
- **##**: comentario especial que aparece en `make help`

### Variables en tu Makefile

```makefile
FLAKE_DIR := .              # Directorio actual (donde está flake.nix)
HOSTNAME := hydenix         # Nombre de tu máquina
BACKUP_DIR := ~/nixos-backups  # Dónde guardar backups
```

Estas variables se usan con `$(VARIABLE)`:
```makefile
sudo nixos-rebuild switch --flake $(FLAKE_DIR)#$(HOSTNAME)
# Se expande a: sudo nixos-rebuild switch --flake .#hydenix
```

### Colores en el Output

```makefile
RED := \033[0;31m
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
PURPLE := \033[0;35m
CYAN := \033[0;36m
NC := \033[0m # No Color
```

Uso: `@printf "$(GREEN)✅ Éxito\n$(NC)"`

---

## Estructura del Makefile de Hydenix

### 1. Declaraciones Iniciales

```makefile
.PHONY: help rebuild switch test ...
.DEFAULT_GOAL := help
```

- `.PHONY`: indica que estos targets no son archivos reales
- `.DEFAULT_GOAL`: si ejecutas solo `make`, corre este target (help)

### 2. Categorías de Comandos

Tu Makefile está organizado en secciones lógicas:

1. **Building and Switching** - Compilar y activar configuraciones
2. **Debugging** - Diagnóstico de problemas
3. **Maintenance and Cleanup** - Limpieza y optimización
4. **Updates** - Actualizar dependencias
5. **Formatting and Linting** - Calidad de código
6. **Backup and Restore** - Copias de seguridad
7. **Git Integration** - Control de versiones
8. **System Information** - Información del sistema
9. **Quick Actions** - Atajos rápidos
10. **Hardware** - Configuración de hardware
11. **Monitoring** - Monitoreo del sistema
12. **Advanced** - Herramientas avanzadas
13. **Migration Helpers** - Ayudantes de migración

---

## Comandos por Categoría

### 🔨 Building and Switching

Estos son los comandos que usarás **más frecuentemente**.

#### `make help`
Muestra todos los comandos disponibles con descripciones.

```bash
make help
# o simplemente:
make
```

**Cuándo usarlo:** Siempre que olvides un comando.

---

#### `make switch`
**⭐ Comando más usado** - Compila y activa tu nueva configuración.

```bash
make switch
```

**Qué hace:**
1. `git add .` - Staging de todos los cambios
2. Compila la configuración
3. Activa la nueva configuración (disponible inmediatamente)
4. Crea una nueva generación del sistema

**Cuándo usarlo:**
- Después de editar `flake.nix`, módulos, o cualquier configuración
- Cuando quieres aplicar cambios ahora mismo
- Flujo normal de trabajo

**Ejemplo de flujo:**
```bash
# 1. Editas un archivo
nvim modules/hm/programs/terminal/kitty.nix

# 2. Aplicas cambios
make switch

# 3. Si algo falla, revierte
make rollback
```

---

#### `make test`
Prueba tu configuración sin activarla permanentemente.

```bash
make test
```

**Qué hace:**
- Compila y activa temporalmente
- Los cambios se pierden al reiniciar
- Útil para experimentar

**Cuándo usarlo:**
- Probar configuraciones experimentales
- Verificar que compila antes de commitear
- Testing de cambios grandes

**Comparación:**
```
make test   → cambios temporales (se pierden al reiniciar)
make switch → cambios permanentes (nueva generación)
make boot   → cambios aplicados en próximo boot
```

---

#### `make build`
Solo compila, no activa nada.

```bash
make build
```

**Cuándo usarlo:**
- Verificar que no hay errores de sintaxis
- Ver qué se compilaría sin aplicar cambios
- CI/CD pipelines

---

#### `make dry-run`
Muestra qué cambiaría sin hacer cambios reales.

```bash
make dry-run
```

**Output ejemplo:**
```
would build:
  - /nix/store/...-neovim-0.9.5
  - /nix/store/...-kitty-0.31.0
would install:
  - kitty-0.31.0
would remove:
  - kitty-0.30.0
```

**Cuándo usarlo:**
- Antes de `make switch` en cambios grandes
- Ver el impacto de actualizaciones
- Depurar problemas de dependencias

---

#### `make boot`
Configura para el próximo arranque (no afecta la sesión actual).

```bash
make boot
```

**Cuándo usarlo:**
- Cambios en el kernel o bootloader
- Configuraciones que requieren reinicio
- Cuando no quieres cerrar sesión ahora

---

### 🐛 Debugging

#### `make debug`
Rebuild con output verbose completo y trace de errores.

```bash
make debug
```

**Cuándo usarlo:**
- Cuando `make switch` falla
- Errores crípticos
- Problemas de evaluación de Nix

**Output incluye:**
- Stack traces completos
- Valores de variables
- Camino de evaluación

---

#### `make check-syntax`
Valida la sintaxis del flake sin compilar.

```bash
make check-syntax
# Equivalente a: nix flake check
```

**Cuándo usarlo:**
- Verificación rápida de sintaxis
- Antes de commits
- Debugging de errores de parsing

**Output exitoso:**
```
✓ checks.x86_64-linux.default
✓ nixosConfigurations.hydenix
```

---

#### `make show`
Muestra la estructura del flake (outputs, sistemas, etc).

```bash
make show
```

**Output ejemplo:**
```
nixosConfigurations
└───hydenix
    └───x86_64-linux
```

---

### 🧹 Maintenance and Cleanup

NixOS guarda **TODAS** las versiones antiguas. Esto permite rollbacks pero consume espacio.

#### `make clean`
Limpieza estándar - elimina generaciones de más de 30 días.

```bash
make clean
```

**Qué elimina:**
- System generations > 30 días
- User generations > 30 días
- Packages no referenciados

**Espacio liberado típico:** 5-20 GB

**Cuándo usarlo:**
- Una vez al mes
- Cuando `/nix/store` está grande (ver con `make info`)
- Mantenimiento rutinario

---

#### `make clean-week`
Limpieza más agresiva - mantiene solo últimos 7 días.

```bash
make clean-week
```

**⚠️ Cuidado:** Solo podrás hacer rollback a generaciones de última semana.

**Cuándo usarlo:**
- Poco espacio en disco
- Has hecho muchos rebuilds recientes
- Testing intensivo

---

#### `make clean-conservative`
Limpieza muy segura - mantiene últimos 90 días.

```bash
make clean-conservative
```

**Cuándo usarlo:**
- Primera vez que limpias
- Quieres máxima seguridad
- Sistema de producción crítico

---

#### `make deep-clean`
Elimina **TODAS** las generaciones antiguas. ⚠️ **IRREVERSIBLE**

```bash
make deep-clean
# Pedirá confirmación: escribir "yes"
```

**⚠️ ADVERTENCIA:**
- No podrás hacer rollback a NINGUNA generación anterior
- Libera máximo espacio posible
- Solo si estás 100% seguro de configuración actual

**Cuándo usarlo:**
- Emergencia de espacio en disco
- Después de migración exitosa
- Sistema funcionando perfectamente y sin cambios recientes

---

#### `make clean-generations`
Elimina generaciones específicas, mantiene últimos 14 días.

```bash
make clean-generations
```

Balance entre seguridad y espacio.

---

#### `make optimize`
Optimiza el Nix store (hardlinks de archivos duplicados).

```bash
make optimize
```

**Qué hace:**
- Encuentra archivos idénticos en `/nix/store`
- Los convierte en hardlinks
- Ahorra espacio sin eliminar nada

**Tiempo:** 5-30 minutos dependiendo del tamaño del store

**Cuándo usarlo:**
- Después de muchas instalaciones
- Una vez al mes
- Complemento de `make clean`

**Ejemplo de uso combinado:**
```bash
make clean      # Elimina generaciones antiguas
make optimize   # Optimiza lo que queda
make info       # Verifica espacio liberado
```

---

### 📦 Updates

#### `make update`
Actualiza todas las inputs del flake (nixpkgs, hydenix, home-manager).

```bash
make update
```

**Qué actualiza:**
```nix
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";  # ← se actualiza
  hydenix.url = "github:richen604/hydenix";              # ← se actualiza
  home-manager.url = "github:nix-community/home-manager"; # ← se actualiza
};
```

**Cuándo usarlo:**
- Una vez por semana
- Para obtener últimas versiones de software
- Antes de instalar nuevo software

**⚠️ Importante:** Después de update, debes hacer `make switch` para aplicar.

**Flujo recomendado:**
```bash
make update           # Actualiza inputs
make dry-run          # Ve qué cambiaría
make test             # Prueba la nueva config
make switch           # Si todo está bien, aplica
# Si algo falla:
make rollback         # Vuelve a versión anterior
```

---

#### `make update-nixpkgs`
Actualiza solo nixpkgs (repositorio principal de paquetes).

```bash
make update-nixpkgs
```

**Cuándo usarlo:**
- Quieres nuevo software pero no cambiar hydenix
- Update selectiva
- Debugging de incompatibilidades

---

#### `make update-hydenix`
Actualiza solo el framework hydenix.

```bash
make update-hydenix
```

**Cuándo usarlo:**
- Nueva versión de hydenix disponible
- Nuevas features de hydenix
- Fixes en hydenix

---

#### `make upgrade`
Combo: actualiza inputs + rebuild. **Comando todo-en-uno**.

```bash
make upgrade
# Equivalente a:
# make update
# make switch
```

**⚠️ Cuidado:** Aplica cambios inmediatamente. Mejor usar:
```bash
make update && make dry-run && make test && make switch
```

---

### 💾 Backup and Restore

#### `make backup`
Crea backup completo de tu configuración.

```bash
make backup
```

**Qué guarda:**
- Todo el directorio del flake
- Timestamp en el nombre: `backup-20260111-143000`
- Ubicación: `~/nixos-backups/`

**Cuándo usarlo:**
- Antes de cambios grandes
- Antes de `make update`
- Antes de experimentar
- Semanalmente como rutina

**Ver backups:**
```bash
ls -lh ~/nixos-backups/
```

**Restaurar backup:**
```bash
cd ~/nixos-backups/backup-20260111-143000
make switch
```

---

#### `make list-generations`
Lista todas las generaciones del sistema con fechas.

```bash
make list-generations
```

**Output ejemplo:**
```
  184   2026-01-08 10:23:45   
  185   2026-01-09 15:30:12   
  186   2026-01-10 09:45:33   
  187   2026-01-11 14:20:01   (current)
```

**Cuándo usarlo:**
- Ver historial de cambios
- Antes de rollback (para elegir generación)
- Verificar cuántas generaciones tienes

---

#### `make rollback`
Vuelve a la generación anterior inmediatamente.

```bash
make rollback
```

**Qué hace:**
- Activa la generación anterior (N-1)
- Cambios disponibles inmediatamente
- No elimina la generación "mala"

**Cuándo usarlo:**
- Después de `make switch` que rompió algo
- Sistema no funciona correctamente
- Quieres deshacer último cambio

**Ejemplo de flujo de recuperación:**
```bash
make switch          # Algo se rompe
make rollback        # Vuelve a versión que funcionaba
# Ahora investiga qué salió mal
make debug           # Re-intenta con verbose output
```

---

### 🔧 Git Integration

#### `make git-status`
Muestra estado del repositorio con GitHub CLI.

```bash
make git-status
```

**Output:**
- Nombre del repo
- Branch actual
- Archivos modificados
- Cambios staged/unstaged

---

#### `make git-add`
Stages todos los cambios.

```bash
make git-add
# Equivalente a: git add .
```

---

#### `make git-commit`
Commit rápido con timestamp automático.

```bash
make git-commit
# Crea commit: "config: update 2026-01-11 14:30:45"
```

**Mejor práctica:** Usa mensajes descriptivos manualmente:
```bash
git add .
git commit -m "feat: add kitty terminal config"
```

---

#### `make git-push`
Push al remoto.

```bash
make git-push
```

---

#### `make save`
**Comando ultra-rápido:** add + commit + push + rebuild todo en uno.

```bash
make save
```

**Qué hace:**
1. `git add .`
2. `git commit -m "config: update [timestamp]"`
3. `git push`
4. `make switch`

**⚠️ Úsalo con cuidado:** Es conveniente pero hace commits automáticos. Mejor para cambios pequeños.

**Mejor práctica:**
```bash
# Para cambios pequeños:
make save

# Para cambios importantes:
git add .
git commit -m "feat: descripción clara del cambio"
git push
make switch
```

---

### 📊 System Information

#### `make info`
Muestra información completa del sistema.

```bash
make info
```

**Output ejemplo:**
```
💻 System Information
===================
Hostname: hydenix
NixOS Version: 24.11.20260110.abc123
Current Generation: 187   2026-01-11 14:20:01
Flake Location: /home/ludus/dotfiles
Store Size: 45G
```

**Cuándo usarlo:**
- Verificar tamaño de `/nix/store`
- Ver versión de NixOS
- Debugging general

---

#### `make status`
Combo de git status + system info.

```bash
make status
```

Vista general completa de tu sistema.

---

### ⚡ Quick Actions

#### `make quick`
Rebuild rápido, salta algunas verificaciones.

```bash
make quick
```

**⚠️ Solo para:**
- Cambios muy pequeños
- Debugging rápido
- Iteración rápida

**No usar para:**
- Cambios importantes
- Updates
- Producción

---

#### `make emergency`
Rebuild con **MÁXIMA** verbosidad para debugging extremo.

```bash
make emergency
```

**Cuándo usarlo:**
- Nada más funciona
- `make debug` no dio suficiente info
- Reportar bugs

---

### 🔩 Hardware

#### `make hardware-scan`
Re-detecta hardware y genera nueva configuración.

```bash
make hardware-scan
```

**Qué hace:**
- Escanea todo el hardware
- Genera `hardware-configuration-new.nix`
- NO sobrescribe el actual

**Cuándo usarlo:**
- Cambiaste hardware (GPU, disco, etc)
- Moviste disco a otra máquina
- Problemas de detección de hardware

**Flujo:**
```bash
make hardware-scan
diff hardware-configuration.nix hardware-configuration-new.nix
# Revisa diferencias
mv hardware-configuration-new.nix hardware-configuration.nix
make switch
```

---

### 📡 Monitoring

#### `make watch-logs`
Ve logs del sistema en tiempo real.

```bash
make watch-logs
```

**Útil para:**
- Ver qué hace el sistema
- Debugging de servicios
- Monitoreo durante rebuild

**Salir:** `Ctrl + C`

---

### 🧠 Advanced

#### `make repl`
Abre un REPL interactivo de Nix con tu flake cargado.

```bash
make repl
```

**Qué puedes hacer:**
```nix
nix-repl> outputs.nixosConfigurations.hydenix.config.services
# Ver configuraciones
nix-repl> :q  # salir
```

**Cuándo usarlo:**
- Explorar configuraciones
- Testing de expresiones Nix
- Aprender Nix

---

#### `make shell`
Entra a un shell de desarrollo (si está configurado).

```bash
make shell
```

---

#### `make vm`
Construye y ejecuta una VM de tu configuración.

```bash
make vm
```

**Útil para:**
- Testing sin riesgo
- Probar en "otra máquina"
- Desarrollo

---

### 🚀 Migration Helpers

#### `make progress`
Muestra progreso de migración desde AGENTS.md.

```bash
make progress
```

**Solo útil durante la migración actual.** Puedes ignorar o eliminar después.

---

## Flujos de Trabajo Comunes

### 📅 Flujo Diario Básico

```bash
# 1. Haces cambios en configuración
nvim modules/hm/programs/terminal/fish.nix

# 2. Aplicas
make switch

# 3. Si hay problemas
make rollback
```

---

### 📅 Flujo Semanal de Mantenimiento

```bash
# Lunes por la mañana:
make backup              # Backup preventivo
make update              # Actualizar inputs
make dry-run             # Ver qué cambiaría
make test                # Probar
make switch              # Aplicar si todo bien
make clean               # Limpiar
make info                # Verificar estado
```

---

### 🔬 Flujo de Experimentación

```bash
# Probar algo nuevo sin riesgo:
make backup              # Backup primero
make test                # Solo para esta sesión
# Prueba tu cambio
# Si te gusta:
make switch              # Aplica permanentemente
# Si no te gusta:
# Simplemente reinicia (cambios se pierden)
```

---

### 🐛 Flujo de Debugging

```bash
# Algo no funciona:
make debug               # Rebuild con verbose
make watch-logs          # En otra terminal
# Revisa errores
make rollback            # Si es grave
make repl                # Explorar configuración
```

---

### 📦 Flujo de Instalación de Software

```bash
# Quieres instalar algo nuevo:
make update              # Asegura últimas versiones
# Edita tu config para agregar el paquete
nvim modules/hm/default.nix
make dry-run             # Ve qué se instalará
make switch              # Aplica

# Si el paquete no existe en cache:
# Puede tardar (compilación)
```

---

### 🌐 Flujo de Contribución Git

```bash
# Cambios listos para compartir:
git add .
git commit -m "feat: add neovim config"
make test                # Verifica que funciona
git push
# Opcional: crear PR
gh pr create
```

---

### 💾 Flujo de Recuperación de Desastres

```bash
# Sistema totalmente roto:
make rollback            # Intenta volver atrás

# Si rollback no funciona:
make list-generations    # Ve generaciones disponibles
# Reinicia y en GRUB elige generación anterior

# Si necesitas backup:
cd ~/nixos-backups/backup-[fecha]
make switch
```

---

## Resolución de Problemas

### ❌ Error: "cannot build derivation"

**Solución:**
```bash
make debug               # Ver error completo
# Suele ser error de sintaxis en .nix
make check-syntax        # Valida sintaxis
```

**Causas comunes:**
- Falta `;` en Nix
- Paréntesis/corchetes sin cerrar
- Variable no definida

---

### ❌ Error: "file not found"

**Solución:**
```bash
# Asegúrate de estar en directorio correcto
cd ~/dotfiles
make switch

# Verifica que flake.nix existe
ls flake.nix
```

---

### ❌ Error: "not a flake"

**Solución:**
```bash
# Asegura que tienes flake.nix válido
nix flake show .

# Re-agrega a git si es nuevo archivo
git add flake.nix
```

---

### ❌ Error: "experimental feature 'flakes' not enabled"

Tu NixOS ya tiene flakes habilitados (en tu config), pero si ves esto:

```bash
# Agregar a configuration.nix:
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

---

### ❌ Error: "disk full"

```bash
make info                # Ver espacio usado
make clean               # Limpiar
make optimize            # Optimizar store
# Si es emergencia:
make deep-clean          # ⚠️ Borra TODO
```

---

### ❌ Error: "permission denied"

**Causas:**
1. Comando necesita `sudo` (el Makefile lo maneja)
2. Archivo sin permisos

```bash
# Si es un módulo nuevo:
chmod 644 modules/hm/programs/terminal/nuevo.nix
```

---

### ❌ Rebuild muy lento

**Causas y soluciones:**
1. **Primera build:** siempre es lenta, paciencia
2. **Compilación:** algunos paquetes compilan
   ```bash
   # Ver qué compila:
   make dry-run
   ```
3. **Muchas dependencies:**
   ```bash
   # Usa binary cache
   # Ya configurado en tu sistema
   ```

---

### ❌ Cambios no se aplican

```bash
# Verifica que guardaste el archivo
# Verifica que estás editando el archivo correcto
make debug               # Ve qué módulos se cargan
```

---

## Tips y Trucos

### 💡 Tip 1: Alias en Fish/Bash

Agrega a tu shell config:

```bash
# Fish (~/.config/fish/config.fish)
alias ns="make switch"
alias nt="make test"
alias nr="make rollback"
alias nu="make update"

# Bash/Zsh (~/.bashrc o ~/.zshrc)
alias ns='make switch'
alias nt='make test'
```

---

### 💡 Tip 2: Testing Rápido

```bash
# Antes de commit:
make check-syntax && make dry-run
# Si ambos pasan, es seguro hacer switch
```

---

### 💡 Tip 3: Ver Cambios de Update

```bash
# Antes de update:
nix flake metadata > before.txt

make update

nix flake metadata > after.txt
diff before.txt after.txt
```

---

### 💡 Tip 4: Búsqueda de Paquetes

```bash
# Buscar paquete:
nix search nixpkgs neovim

# Ver versión actual:
nix eval .#nixosConfigurations.hydenix.pkgs.neovim.version
```

---

### 💡 Tip 5: Edición Rápida

Crea aliases para tus archivos más editados:

```bash
alias edit-fish="nvim ~/dotfiles/modules/hm/programs/terminal/fish.nix"
alias edit-hypr="nvim ~/dotfiles/modules/hm/programs/hyprland.nix"
alias edit-flake="nvim ~/dotfiles/flake.nix"
```

---

### 💡 Tip 6: Commits Descriptivos

En lugar de `make save`, usa commits descriptivos:

```bash
# Malo (make save hace esto):
git commit -m "config: update 2026-01-11 14:30:45"

# Bueno:
git commit -m "feat: add kitty terminal with custom theme"
git commit -m "fix: resolve fish shell completion issue"
git commit -m "refactor: organize browser configs"
```

**Convenciones:**
- `feat:` - nueva funcionalidad
- `fix:` - corrección
- `refactor:` - reorganización
- `docs:` - documentación
- `style:` - formateo

---

### 💡 Tip 7: Backup Automático

Crea un cronjob o systemd timer:

```bash
# Backup semanal automático
# Agregar a crontab: crontab -e
0 2 * * 1 cd ~/dotfiles && make backup
```

---

### 💡 Tip 8: Ver Tamaño de Paquetes

```bash
# Ver qué consume más espacio:
nix path-info -Sh /run/current-system | sort -k2 -h
```

---

### 💡 Tip 9: Testing en VM Rápido

```bash
# En lugar de arriesgar tu sistema:
make vm
# Prueba cambios en VM
# Si funciona, aplica en sistema real
```

---

### 💡 Tip 10: Documentar tus Cambios

Mantén un changelog personal:

```bash
# Crear CHANGELOG.md
echo "## $(date +%Y-%m-%d) - Configuración inicial kitty" >> CHANGELOG.md
```

---

## 📚 Recursos Adicionales

### Documentación Oficial
- **NixOS Manual:** https://nixos.org/manual/nixos/stable/
- **Nix Language:** https://nixos.org/manual/nix/stable/language/
- **Home Manager:** https://nix-community.github.io/home-manager/

### Tu Configuración
- `README.md` - Overview de tu config
- `AGENTS.md` - Estado de migración
- `docs/` - Documentación adicional

### Comandos de Referencia Rápida

```bash
make                   # Ver todos los comandos
make switch            # Aplicar cambios
make test              # Probar sin aplicar
make rollback          # Deshacer último cambio
make update            # Actualizar paquetes
make clean             # Limpiar espacio
make backup            # Guardar backup
make info              # Ver estado del sistema
make debug             # Debugging detallado
```

---

## 🎯 Próximos Pasos

1. **Lee el README.md** de tu configuración
2. **Experimenta** con `make test` (es seguro)
3. **Crea backups** antes de cambios grandes
4. **Usa rollback** sin miedo si algo falla
5. **Documenta** tus cambios importantes
6. **Mantén actualizado** con `make update` semanal
7. **Limpia regularmente** con `make clean`

---

## 🤝 Contribuciones

¿Encontraste un truco útil? ¡Agrégalo aquí!

```bash
# Edita este tutorial
nvim MAKEFILE_TUTORIAL.md

# Comparte con la comunidad
git add MAKEFILE_TUTORIAL.md
git commit -m "docs: add [tu truco] to tutorial"
git push
```

---

**¡Disfruta tu configuración NixOS con Hydenix!** 🎉

Si tienes preguntas, revisa:
1. Este tutorial
2. `make help`
3. `docs/faq.md`
4. Comunidad de Hydenix

---

## 🆕 Nuevos Comandos Agregados (2026-01-11)

### Comandos Multi-Host

#### `make list-hosts`
Lista todas las configuraciones de hosts disponibles (hydenix, laptop, vm).

```bash
make list-hosts
# Muestra qué hosts están configurados y cuál es el actual
```

**Usar con otros comandos:**
```bash
make switch HOSTNAME=laptop  # Deploy a laptop
make test HOSTNAME=vm        # Probar config de VM
```

---

### Comandos de Validación

#### `make validate`
Valida la configuración antes de aplicarla (chequeos de sintaxis y evaluación).

```bash
make validate
# 1/3 Checking flake syntax... ✓
# 2/3 Checking configuration evaluation... ✓
# 3/3 Checking for common issues... ⊘
```

#### `make safe-switch`
Combo: valida y luego hace switch (la opción más segura).

```bash
make safe-switch
# Valida primero, solo hace switch si todo está bien
```

#### `make health`
Chequeo de salud del sistema completo (flake, store, disco, servicios, git).

```bash
make health
# Revisa 7 aspectos del sistema
```

---

### Comandos de Información

#### `make generation-sizes`
Muestra el tamaño en disco de cada generación del sistema.

```bash
make generation-sizes
# Útil para ver qué generaciones ocupan más espacio
```

#### `make diff-generations`
Compara la generación actual con la anterior (qué cambió).

```bash
make diff-generations
# Muestra paquetes añadidos/eliminados/actualizados
```

#### `make diff-gen GEN1=N GEN2=M`
Compara dos generaciones específicas.

```bash
make diff-gen GEN1=20 GEN2=25
# Compara generación 20 vs 25
```

#### `make update-info`
Muestra información sobre los inputs actuales del flake.

```bash
make update-info
# Ve las versiones actuales de nixpkgs, hydenix, etc
```

#### `make diff-update`
Muestra cambios en flake.lock después de un update.

```bash
make update
make diff-update
# Ve qué cambió exactamente
```

---

### Comandos de Actualización

#### `make update-input INPUT=nombre`
Actualiza solo un input específico del flake.

```bash
make update-input INPUT=hydenix
# Actualiza solo hydenix, no nixpkgs ni otros
```

**Inputs disponibles:**
- nixpkgs
- hydenix
- nixos-hardware
- mynixpkgs
- opencode
- zen-browser-flake

---

### Comandos de Búsqueda

#### `make search PKG=nombre`
Busca paquetes en nixpkgs.

```bash
make search PKG=firefox
# Busca firefox en todos los paquetes disponibles
```

#### `make search-installed PKG=nombre`
Busca en paquetes ya instalados en tu sistema.

```bash
make search-installed PKG=kitty
# Verifica si kitty está instalado
```

---

### Comandos de Ayuda

#### `make help-advanced`
Muestra ayuda avanzada con workflows completos y ejemplos.

```bash
make help-advanced
# Guía de workflows: desarrollo diario, updates seguros, mantenimiento, etc
```

---

### Comando de Performance

#### `make benchmark`
Mide el tiempo que tarda un rebuild (solo build, no switch).

```bash
make benchmark
# Total time: 120s (2m 0s)
```

---

### Correcciones Implementadas

Los siguientes comandos fueron corregidos en esta actualización:

1. **`make deep-clean`** - Ahora pide confirmación correctamente
2. **`make format`** - Detecta qué formatter tienes instalado (nixpkgs-fmt o alejandra)
3. **`make lint`** - Detecta si statix está instalado y da instrucciones claras
4. **`make vm`** - Corregido para usar `nix build .#vm` (coincide con flake.nix)
5. **`make hardware-scan`** - Genera archivo en `hosts/$(HOSTNAME)/` en lugar del root

---

### Status Mejorado

El comando `make status` ahora muestra información mucho más detallada y organizada:

```bash
make status
# ╔══════════════════════════════════════╗
# ║      SYSTEM STATUS OVERVIEW          ║
# ╚══════════════════════════════════════╝
# 
# 📍 Configuration
# ├─ Host: hydenix
# ├─ Flake: /home/ludus/dotfiles
# └─ NixOS: 24.11
#
# 📦 Git Status
# ├─ Branch: feature/reorganize-structure
# ├─ Status: Uncommitted changes
# │  M Makefile
# └─ Last 3 commits: ...
#
# 💾 System Info
# ├─ Store size: 45G
# ├─ Current gen: 26
# ├─ Total gens: 26
# └─ Disk usage: 35% used
```

---

### 💡 Flujos de Trabajo Nuevos

**Flujo de Validación Segura:**
```bash
make validate       # Chequea sintaxis y config
make test           # Prueba temporalmente  
make safe-switch    # Valida y aplica
```

**Flujo de Health Check:**
```bash
make health         # Ver estado general
make generation-sizes  # Ver uso de espacio
make clean-week     # Limpiar si es necesario
```

**Flujo Multi-Host:**
```bash
make list-hosts     # Ver hosts disponibles
make validate HOSTNAME=laptop  # Validar config de laptop
make switch HOSTNAME=laptop    # Aplicar a laptop
```

---

*Última actualización: 2026-01-11*
*Versión: 2.0 - Con mejoras FASE 1 y FASE 2 implementadas*
*Mantenedor: ludus*

