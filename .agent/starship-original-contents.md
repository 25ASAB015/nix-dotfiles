# Contenido Original de ~/.config/starship (Hydenix)

Esta carpeta originalmente contenía **3 archivos** desde el paquete `hyde` de Hydenix:

## 1. starship.toml
Configuración principal de Starship (formato de una línea con icono, directorio, git, etc.)

```toml
# "$schema" = 'https://starship.rs/config-schema.json'
add_newline = false
format = """\
  󰣇 \
  $directory\
  $git_branch$git_commit$git_state $git_status\
  $character\n
"""
right_format = """
$singularity\
$kubernetes\
$vcsh\
$hg_branch\
$pijul_channel\
$c\
$cmake\
$cobol\
$daml\
$dart\
$deno\
$dotnet\
$elixir\
$elm\
$erlang\
$fennel\
$golang\
$guix_shell\
$haskell\
$haxe\
$helm\
$java\
$julia\
$kotlin\
$gradle\
$lua\
$nim\
$nodejs\
$ocaml\
$opa\
$perl\
$pulumi\
$purescript\
$python\
$raku\
$rlang\
$red\
$ruby\
$rust\
$scala\
$solidity\
$swift\
$terraform\
$vlang\
$vagrant\
$zig\
$buf\
$conda\
$meson\
$spack\
$memory_usage\
$aws\
$gcloud\
$openstack\
$azure\
$cpp\
$kotlin\
$ocaml\
$pixi\
$rlang\
$php\
$crystal\
$custom\
$status\
$os\
$time"""

continuation_prompt = '▶▶ '

[directory]
disabled = false
format = "[$path](bold fg:#8be9fd)"
truncate_to_repo = false

[git_branch]
format = " [  $branch](fg:#9198a1)"

[git_status]
ahead = '⇡${count}'
behind = '⇣${count}'
diverged = '⇕⇡${ahead_count}⇣${behind_count}'
format = '[[( $all_status$ahead_behind )](fg:#769ff0)]($style)'
style = "bg:#394260"

[time]
disabled = false
format = '[[  $time ](fg:#a0a9cb )]($style)'
time_format = "%R"

# ... (más configuraciones de lenguajes de programación)
```

## 2. powerline.toml
Configuración alternativa estilo powerline con colores y formato diferente

```toml
format = """
[ ](#9A348E)\
$os\
$username\
[ ](bg:#DA627D fg:#9A348E)\
$directory\
[ ](fg:#DA627D bg:#FCA17D)\
$git_branch\
$git_status\
[ ](fg:#FCA17D bg:#86BBD8)\
$c\
$elixir\
$elm\
$golang\
$gradle\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
$scala\
$deno\
$lua\
$python\
$ruby\
$swift\
$aws\
$buf\
$cpp\
$kotlin\
$ocaml\
$perl\
$php\
$pixi\
$rlang\
$meson\
$conda\
$dart\
$memory_usage\
$nix_shell\
$spack\
$zig\
$singularity\
$kubernetes\
$vcsh\
$cobol\
$daml\
$dotnet\
$erlang\
$fennel\
$haxe\
$helm\
$opa\
$pulumi\
$purescript\
$raku\
$red\
$solidity\
$terraform\
$vlang\
$vagrant\
$gcloud\
$openstack\
$azure\
$crystal\
[ ](fg:#86BBD8 bg:#06969A)\
$docker_context\
[ ](fg:#06969A bg:#33658A)\
$time\
[ ](fg:#33658A)\
"""

[username]
disabled = false
format = '[$user ]($style)'
show_always = true
style_root = "bg:#9A348E"
style_user = "bg:#9A348E"

[directory]
format = "[ $path ]($style)"
style = "bg:#DA627D"

[git_branch]
format = '[ $symbol $branch ]($style)'
style = "bg:#FCA17D"
symbol = ""

[git_status]
format = '[$all_status$ahead_behind ]($style)'
style = "bg:#FCA17D"

# ... (más configuraciones)
```

## 3. fish.toml
Configuración específica para Fish shell (más minimalista, formato de 2 líneas)

```toml
add_newline = true
command_timeout = 500
format = "$status$username$hostname$directory$git_branch$git_status$cmd_duration$nix_shell\n$character"
scan_timeout = 5

[character]
error_symbol = "[│](bold red) "
format = "$symbol"
success_symbol = "[│](bold white) "
vicmd_symbol = "[│](bold green) "

[cmd_duration]
format = " [$duration]($style)"
min_time = 2000
show_milliseconds = true
style = "yellow"

[directory]
format = "[$path]($style)"
home_symbol = "~"
repo_root_format = "[$repo_root]($repo_root_style)"
repo_root_style = "bold white"
style = "cyan"
truncation_length = 1
truncation_symbol = ""

[git_branch]
format = " [$branch]($style)"
style = "green"
symbol = ""

[git_status]
ahead = "[↑]"
behind = "[↓]"
deleted = "[x]"
diverged = "[↕]"
format = " [$all_status$ahead_behind]($style)"
modified = "[!]"
renamed = "[»]"
staged = "[+]"
stashed = ""
style = "yellow"
untracked = "[?]"

[nix_shell]
disabled = false
format = " [nix]($style)"
heuristic = false
impure_msg = ""
pure_msg = ""
style = "bold blue"
unknown_msg = ""

[status]
disabled = false
format = "[$symbol](bold $style) "
map_symbol = false
pipestatus = false
recognize_signal_code = false
style = "red"
success_symbol = "[│](bold white)"
symbol = "│"

[username]
format = "[$user]($style)@"
show_always = false
style_root = "bold red"
style_user = "bold yellow"

# La mayoría de los módulos de lenguajes están disabled = true
```

## Notas

- Estos archivos provienen del paquete `hyde` de Hydenix
- Se copian desde `${pkgs.hyde}/Configs/.config/starship/` en el módulo `hydenix/modules/hm/shell.nix`
- `fish.toml` es un symlink a otro archivo en el store de Nix
- La configuración actual puede haber sido modificada o reemplazada por configuraciones personalizadas

