# Resources Folder

Este directorio contiene configuraciones mutables y recursos que no son código Nix.

## Estructura

```
resources/
├── config/         # Archivos de configuración planos (editable text files)
│   ├── .zshrc_extra  # Zsh aliases y exports extras
│   ├── hypr/      # Hyprland configs (keybindings, monitors, etc.)
│   ├── fish/      # Fish shell configs
│   └── starship/  # Starship prompt configs
├── scripts/       # Scripts de utilidad (bash, python, etc.)
└── wallpapers/    # Fondos de pantalla
```

## Uso

### Configs Mutables

Los archivos en `config/` son para configuraciones que cambias frecuentemente y prefieres editar como texto plano en lugar de Nix.

**Ejemplo:** Para override keybindings de Hyprland:
1. Crea `resources/config/hypr/keybindings.conf`
2. En un módulo Nix:
   ```nix
   home.file.".config/hypr/keybindings.conf" = lib.mkForce {
     source = ../../resources/config/hypr/keybindings.conf;
   };
   ```

### Hydenix Keybinds y Recursos (Pruebas)

Esta configuración integra `keybinds.nix` y recursos desde `resources/` para pruebas rápidas:

- **Keybinds:** `resources/config/keybinds.conf`
- **Scripts:** `resources/scripts/` y `resources/script_launcher.sh`
- **Wallpapers:** `resources/wallpapers/`
- **Themes:** `resources/themes/`

**Dónde se integra:**
- Módulo: `modules/hm/keybinds.nix`

**Cómo personalizar:**
1. Edita `resources/config/keybinds.conf`
2. Ajusta scripts en `resources/scripts/`
3. Aplica una vez (luego no necesitas rebuild para cambios en resources):
   ```bash
   make switch
   ```

## ¿Qué editar primero?

Si estás empezando o quieres cambios rápidos:

1. **Keybinds:** `resources/config/keybinds.conf`
2. **Scripts:** `resources/scripts/` (lanzadores, grabación, utilidades)
3. **Kitty:** `resources/config/kitty.conf`
4. **Monitores:** `resources/config/monitors.conf`

## Shell (Zsh) - Overrides rápidos

Usa `resources/config/.zshrc_extra` para aliases y exports personales sin tocar módulos Nix.

### Scripts

Scripts de utilidad que quieres tener disponibles en el sistema.

**Ejemplo:**
```bash
# resources/scripts/toggle-monitor.sh
#!/usr/bin/env bash
# Tu script aquí
```

En Nix:
```nix
home.file.".local/bin/toggle-monitor.sh" = {
  source = ../../resources/scripts/toggle-monitor.sh;
  executable = true;
};
```

### Wallpapers

Fondos de pantalla para temas de Hydenix.

**Ejemplo:**
```nix
home.activation.copyWallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
  cp ${../../resources/wallpapers/my-wallpaper.png} \
     "$HOME/.config/hyde/themes/My Theme/wallpapers/"
'';
```

## Filosofía

Este folder permite un **enfoque híbrido**:
- **Inmutable (Nix)**: Para configuraciones estables y complejas
- **Mutable (Resources)**: Para archivos que editas frecuentemente o prefieres en texto plano

Ver `ANALYSIS.md` para más detalles sobre estrategias de configuración.

