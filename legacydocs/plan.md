# Resumen: Integración SSH/GPG de Kaku en Dotfiles (Hydenix)

## Contexto del Proyecto

- **Sistema base**: Hydenix (NixOS + Hyprland) funcionando
- **Objetivo**: Adoptar estructura modular de Kaku para Home Manager
- **Usuario**: ludus
- **Ubicaciones**:
  - Dotfiles (Hydenix): `~/dotfiles/`
  - Kaku original: `~/kaku/`
  - Kakunew: `~/Downloads/kakunew/`

## Primera Integración Solicitada: SSH + GPG

### Situación Actual

Tu script `setup_github.sh` hace todo imperativo:
1. Genera SSH key (`ssh-keygen`)
2. Genera GPG key (`gpg --gen-key`)
3. Sube ambas a GitHub (`gh ssh-key add`, `gh gpg-key add`)
4. Configura git signing

### Lo que Kaku/Kakunew Hace

- **Agenix** para secretos encriptados (tokens, APIs)
- **NO almacena** SSH/GPG private keys como secretos
- Archivos `.age` encriptados con clave host del sistema
- Desencriptados en boot a `/run/agenix/`

### Tu Requerimiento Adicional

Quieres **la misma SSH/GPG key en todas las máquinas**:
- 3 PCs con NixOS (actual + 2 futuras)
- VMs con NixOS
- Containers Docker
- GitHub Codespaces

## Problema Descubierto

**Agenix NO funciona en containers/Codespaces** porque requiere:
- NixOS activation system
- SSH host keys en `/etc/ssh/`

## Estrategia Híbrida Propuesta

```
┌─────────────────────────────────────────────────────┐
│     FUENTE DE VERDAD: 1Password/Bitwarden          │
│     (SSH key, GPG key, GitHub token)               │
└─────────────────────────────────────────────────────┘
                         ↓
┌──────────────┬──────────────────┬──────────────────┐
│   NixOS      │   Containers     │   Codespaces     │
│   Agenix     │   bw/op CLI      │   GH Secrets     │
└──────────────┴──────────────────┴──────────────────┘
```

| Entorno | Herramienta | Bootstrap |
|---------|-------------|-----------|
| NixOS | Agenix | Host SSH key |
| Containers | Bitwarden/1Password CLI | Master password |
| Codespaces | GitHub Secrets | GitHub UI |
| Emergencia | Script manual | Prompt interactivo |

## Archivos a Crear en Dotfiles

```
dotfiles/
├── flake.nix                          # Añadir input agenix
├── secrets/
│   ├── secrets.nix                    # Definir claves públicas
│   ├── ssh-key.age                    # SSH private key encriptada
│   ├── gpg-key.age                    # GPG private key encriptada
│   └── github.age                     # GitHub token
└── modules/hm/terminal/software/
    ├── ssh.nix                        # Configuración SSH declarativa
    ├── gpg.nix                        # GPG + pinentry
    └── secrets.nix                    # Detector de entorno
```

## Preguntas Pendientes

1. **¿Usas 1Password o Bitwarden?** (determina qué CLI integrar)
2. **¿Prefieres empezar simple?** (solo agenix para NixOS primero)
3. **¿Tu GPG key tiene passphrase?** (afecta configuración de pinentry)

## Próximos Pasos Cuando Retomes

1. Responder las 3 preguntas pendientes
2. Configurar 1Password/Bitwarden con tus claves actuales
3. Implementar agenix en dotfiles
4. Crear módulos `ssh.nix` y `gpg.nix`
5. Crear script de bootstrap para containers

## Referencias Útiles

- Kakunew secrets: `~/Downloads/kakunew/secrets/secrets.nix`
- Kakunew ssh: `~/Downloads/kakunew/home/terminal/software/ssh.nix`
- Kakunew gpg: `~/Downloads/kakunew/home/terminal/software/gpg.nix`
- Dotfiles software: `~/dotfiles/modules/hm/terminal/software/`
- Tu script actual: `~/Downloads/setup_github.sh`

## Hallazgos Importantes

1. Tu `git.nix` en dotfiles **ya tiene soporte GPG** - solo hay que habilitarlo
2. Kakunew tiene infraestructura agenix pero **secretos no migrados**
3. Dotfiles/Hydenix **no tiene** manejo de secretos actualmente
