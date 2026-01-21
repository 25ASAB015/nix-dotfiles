#!/run/current-system/sw/bin/bash

# Simple Script Selector for Rofi
pkill -x rofi && exit

# Set comprehensive PATH like your dict script
export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"

SCRIPT_DIR="$HOME/Dotfiles/resources/scripts"

# Check if directory exists
if [[ ! -d "$SCRIPT_DIR" ]]; then
    notify-send "Script Selector" "Directory not found: $SCRIPT_DIR"
    exit 1
fi

# Generate list of .sh scripts with descriptions
cd "$SCRIPT_DIR" || exit 1

script_list=""
for script in *.sh; do
    [[ ! -f "$script" ]] && continue
    [[ ! -x "$script" ]] && continue

    # Skip launcher and specific scripts
    [[ "$script" =~ script.?launcher ]] && continue
    [[ "$script" =~ if.?discharging ]] && continue

    # Get description from first comment line
    description=$(head -5 "$script" | grep '^#' | grep -v '^#!/' | head -1 | sed 's/^#[[:space:]]*//')
    [[ -z "$description" ]] && description="No description"

    script_list+="$script\t$description\n"
done



# Show in rofi with system theme
selected=$(echo -e "$script_list" | rofi -dmenu -theme style_1 -p " Scripts" -i)

# Exit if nothing selected
[[ -z "$selected" ]] && exit 0

# Get script name (first column)
script_name=$(echo "$selected" | cut -f1)

# Run the script with proper environment
cd "$SCRIPT_DIR" || exit
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"
bash -l -c "./$script_name"
