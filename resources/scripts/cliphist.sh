#!/run/current-system/sw/bin/bash

# Script to manage clipboard history using cliphist and rofi

# Function to display clipboard history
show_history() {
    cliphist list | rofi -dmenu -p "Clipboard" -display-columns 2 | cliphist decode | wl-copy
}

# Function to clear clipboard history
clear_history() {
    cliphist wipe
    notify-send "Clipboard" "History cleared"
}

# Parse arguments
case "$1" in
    c|--copy)
        # In this context, -c seems to be used for the main binding (Show history) in Dotfiles config
        # bindd = $mainMod, p, ... cliphist.sh -c
        show_history
        ;;
    w|--wipe)
        clear_history
        ;;
    *)
        # Default action (also show history, used by Shift+P binding in Dotfiles?)
        # bindd = $mainMod Shift, p, ... cliphist.sh (no args)
        show_history
        ;;
esac
