#!/run/current-system/sw/bin/bash
# Launch system monitor (Activity monitor) as floating window
# Set a comprehensive PATH to ensure we find all commands
export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:$PATH"

# Find command paths dynamically
PGREP_CMD=$(command -v pgrep || echo "/usr/bin/pgrep")
JQ_CMD=$(command -v jq || echo "/usr/bin/jq")
HYPRCTL_CMD=$(command -v hyprctl || echo "/usr/bin/hyprctl")
HEAD_CMD=$(command -v head || echo "/usr/bin/head")

# Try to find system monitor executable (btm, btop, or htop)
SYSMON_CMD=""
for cmd in "btm" "btop" "htop"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        SYSMON_CMD=$(command -v "$cmd")
        break
    fi
done

# Fallback if not found
if [ "$SYSMON_CMD" = "" ]; then
    SYSMON_CMD="btm"
fi

# Try to find terminal emulator (ghostty, foot, kitty, or alacritty)
TERMINAL_CMD=""
for cmd in "ghostty" "foot" "kitty" "alacritty"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        TERMINAL_CMD=$(command -v "$cmd")
        break
    fi
done

# Fallback if not found
if [ "$TERMINAL_CMD" = "" ]; then
    TERMINAL_CMD="foot"
fi

# Window class identifier for sysmon
SYSMON_CLASS="sysmon"
SYSMON_TITLE="System Monitor"

# Check if a sysmon window already exists
SYSMON_PID=$("$PGREP_CMD" -f "$SYSMON_CMD" | "$HEAD_CMD" -n1)
if [ "$SYSMON_PID" != "" ]; then
    # Try to find the window by class or title
    SYSMON_WINDOW=$("$HYPRCTL_CMD" clients -j | "$JQ_CMD" -r ".[] | select(.class | test(\"(?i)$SYSMON_CLASS|btm|btop|htop\")) | .address" | "$HEAD_CMD" -n1)
    if [ "$SYSMON_WINDOW" != "" ]; then
        # Focus existing window and make it float if not already
        "$HYPRCTL_CMD" dispatch focuswindow "address:$SYSMON_WINDOW"
        "$HYPRCTL_CMD" dispatch togglefloating "address:$SYSMON_WINDOW"
        exit 0
    fi
fi

# Launch new system monitor in terminal with specific class
# Different terminals have different ways to set class/title
case "$(basename "$TERMINAL_CMD")" in
    ghostty)
        "$TERMINAL_CMD" --class "$SYSMON_CLASS" --title "$SYSMON_TITLE" -e "$SYSMON_CMD" &
        ;;
    foot)
        "$TERMINAL_CMD" --app-id "$SYSMON_CLASS" --title "$SYSMON_TITLE" -e "$SYSMON_CMD" &
        ;;
    kitty)
        "$TERMINAL_CMD" --class "$SYSMON_CLASS" --title "$SYSMON_TITLE" -e "$SYSMON_CMD" &
        ;;
    alacritty)
        "$TERMINAL_CMD" --class "$SYSMON_CLASS" --title "$SYSMON_TITLE" -e "$SYSMON_CMD" &
        ;;
    *)
        # Generic fallback
        "$TERMINAL_CMD" -e "$SYSMON_CMD" &
        ;;
esac

# Wait a moment for the window to appear, then make it float
sleep 0.3

# Find the newly created window and make it float
NEW_WINDOW=$("$HYPRCTL_CMD" clients -j | "$JQ_CMD" -r ".[] | select(.class | test(\"(?i)$SYSMON_CLASS|btm|btop|htop\")) | .address" | "$HEAD_CMD" -n1)
if [ "$NEW_WINDOW" != "" ]; then
    "$HYPRCTL_CMD" dispatch togglefloating "address:$NEW_WINDOW"
    # Center the window (optional, can be removed if not desired)
    "$HYPRCTL_CMD" dispatch centerwindow "address:$NEW_WINDOW"
fi
