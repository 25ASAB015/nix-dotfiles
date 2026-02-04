# 🚀 Fix: Internet Lento en NixOS - Solución de DNS

## 🔍 Problema Identificado

Tu sistema estaba usando **DNS lentos del ISP** (179.51.50.202, 179.51.50.203) en lugar de los DNS rápidos de Cloudflare (1.1.1.1).

### Síntomas:
- Navegación web lenta en Zen Browser y otros navegadores
- Páginas tardan en cargar a pesar de tener 300 Mb de velocidad
- Latencia alta en resolución DNS

---

## ✅ Cambios Aplicados

### **1. DNS Forzados a Cloudflare (Fix Principal)**

**Archivo:** `hosts/default.nix` (líneas 82-93)

**Antes:**
```nix
networking = {
  networkmanager.enable = true;
  nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];
};
```

**Después:**
```nix
networking = {
  networkmanager = {
    enable = true;
    # Insertar DNS manualmente (ignora DNS del ISP/DHCP)
    insertNameservers = [ "1.1.1.1" "1.0.0.1" ];
    # No usar DNS del router/ISP
    dns = "none";
  };
  # DNS del sistema (fallback)
  nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];
};
```

**¿Qué hace?**
- `insertNameservers`: Fuerza Cloudflare DNS (1.1.1.1) como primario
- `dns = "none"`: Ignora completamente los DNS del ISP/Router
- `nameservers`: DNS de respaldo a nivel sistema

---

### **2. HTTP/2 Habilitado (Mejora Secundaria)**

**Archivo:** `hosts/default.nix` (línea 46)

**Antes:**
```nix
http2 = false;
```

**Después:**
```nix
http2 = true; # ✅ HTTP/2 mejora velocidad de descargas (cachix, binarios)
```

**¿Qué hace?**
- Mejora velocidad de descargas de Nix (binarios, cachix)
- Reduce latencia en conexiones múltiples
- Protocolo moderno más eficiente

---

## 📋 Cómo Aplicar los Cambios

### **Opción 1: Rebuild Completo (Recomendado)**

```bash
cd ~/Dotfiles
sudo nixos-rebuild switch --flake .#hydenix
```

### **Opción 2: Test Antes de Aplicar**

```bash
cd ~/Dotfiles
sudo nixos-rebuild test --flake .#hydenix
```

Si todo funciona bien, entonces:

```bash
sudo nixos-rebuild switch --flake .#hydenix
```

---

## 🧪 Verificar Mejoras

Después de aplicar el rebuild, verifica que los DNS hayan cambiado:

### **1. Verificar DNS Activos**

```bash
cat /etc/resolv.conf
```

**Deberías ver:**
```
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
```

**NO deberías ver:**
```
nameserver 179.51.50.202  # ❌ DNS del ISP (lento)
nameserver 179.51.50.203  # ❌ DNS del ISP (lento)
```

### **2. Verificar NetworkManager**

```bash
nmcli device show | grep DNS
```

**Deberías ver:**
```
IP4.DNS[1]: 1.1.1.1
IP4.DNS[2]: 1.0.0.1
```

### **3. Test de Velocidad Web**

```bash
time curl -s -o /dev/null -w "Lookup: %{time_namelookup}s, Total: %{time_total}s\n" https://www.google.com
```

**Antes del fix:**
- Lookup: ~0.100-0.500s (con DNS del ISP)

**Después del fix (esperado):**
- Lookup: ~0.010-0.050s (con Cloudflare DNS)

---

## 🎯 Resultados Esperados

### **Mejoras Inmediatas:**

1. ⚡ **Navegación web más rápida**
   - Páginas cargan 2-5x más rápido
   - Menos latencia en cada request DNS
   
2. 🚀 **Resolución DNS más rápida**
   - Cloudflare DNS: ~10-20ms
   - ISP DNS: ~50-200ms (o más)

3. 📦 **Descargas Nix más rápidas**
   - HTTP/2 mejora descargas de cachix
   - Mejor paralelización de requests

---

## 🔧 Troubleshooting

### **Problema: DNS del ISP siguen apareciendo**

Si después del rebuild sigues viendo los DNS del ISP:

1. **Reiniciar NetworkManager:**
   ```bash
   sudo systemctl restart NetworkManager
   ```

2. **Forzar reconexión:**
   ```bash
   nmcli connection down "Wired connection 1"
   nmcli connection up "Wired connection 1"
   ```

3. **Verificar configuración:**
   ```bash
   nmcli connection show "Wired connection 1" | grep dns
   ```

### **Problema: Internet no funciona después del cambio**

Si pierdes conectividad:

1. **Rollback inmediato:**
   ```bash
   sudo nixos-rebuild switch --rollback
   ```

2. **Verificar que los DNS estén accesibles:**
   ```bash
   ping -c 3 1.1.1.1
   ```

---

## 📊 Comparación DNS

| DNS Provider     | IP            | Latencia Típica | Privacidad |
|------------------|---------------|-----------------|------------|
| **Cloudflare**   | 1.1.1.1       | ~10-20ms       | ⭐⭐⭐⭐⭐ |
| **Google**       | 8.8.8.8       | ~15-30ms       | ⭐⭐⭐     |
| **ISP (tuyo)**   | 179.51.50.202 | ~50-200ms+     | ⭐         |

---

## 🔗 Referencias

- [Cloudflare DNS](https://1.1.1.1/)
- [NetworkManager Configuration - NixOS](https://search.nixos.org/options?query=networking.networkmanager)
- [Nix HTTP/2 Settings](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-http2)

---

## ✨ Configuración TCP Existente (Ya Optimizada)

Tu configuración **ya tiene** optimizaciones TCP excelentes en `hosts/default.nix`:

```nix
boot.kernel.sysctl = {
  "net.core.rmem_max" = 134217728;        # 128 MiB buffer receive
  "net.core.wmem_max" = 134217728;        # 128 MiB buffer send
  "net.ipv4.tcp_rmem" = "4096 87380 67108864";  # TCP read buffers
  "net.ipv4.tcp_wmem" = "4096 65536 67108864";  # TCP write buffers
  "net.ipv4.tcp_congestion_control" = "bbr";    # BBR congestion control (Google)
  "net.core.default_qdisc" = "fq";              # Fair Queue discipline
};
```

Estas configuraciones son **de nivel profesional** y no requieren cambios. 👍

---

**Autor:** AI Assistant  
**Fecha:** 2026-01-15  
**Estado:** ✅ Cambios aplicados, pendiente rebuild

