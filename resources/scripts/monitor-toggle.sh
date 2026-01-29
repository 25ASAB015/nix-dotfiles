#!/run/current-system/sw/bin/bash

# Check if hyprctl is available
if ! command -v hyprctl &> /dev/null; then
    notify-send "Monitor Toggle" "Error: hyprctl not found"
    exit 1
fi

# Get list of monitors
# We use json output for reliable parsing
MONITORS=$(hyprctl monitors -j)

# Count active monitors
COUNT=$(echo "$MONITORS" | jq 'length')

if [ "$COUNT" -gt 1 ]; then
    # More than 1 monitor active -> Switch to Single Mode
    # We will keep the focused monitor or the first one, and disable others.
    # For simplicity, let's keep eDP-1 if present, or the first one found.
    
    # Actually, the user likely wants to disable the external one or specific one.
    # Let's try to identify if there is an existing "secondary" monitor logic.
    # Usually eDP-1 is laptop, HDMI/DP are external.
    
    # Let's disable all except the one that is currently focused or 0.
    # But better: Disable the one that is NOT the primary/eDP if possible.
    
    # Simple approach: If 2 are on, disable the second one listed (often the external).
    # Or disable the non-focused one?
    
    # Let's try to disable the one that is NOT eDP-1 if eDP-1 exists.
    TARGET_TO_DISABLE=$(echo "$MONITORS" | jq -r '.[] | select(.name != "eDP-1") | .name' | head -n 1)
    
    # If no non-eDP found (e.g. 2 external), just pick the second one.
    if [ -z "$TARGET_TO_DISABLE" ]; then
        TARGET_TO_DISABLE=$(echo "$MONITORS" | jq -r '.[1].name')
    fi
    
    if [ -n "$TARGET_TO_DISABLE" ] && [ "$TARGET_TO_DISABLE" != "null" ]; then
        hyprctl keyword monitor "$TARGET_TO_DISABLE, disable"
        notify-send -t 3000 "Monitor Toggle" "Single Monitor Mode Active\nDisabled: $TARGET_TO_DISABLE"
    else
        notify-send "Monitor Toggle" "Could not identify monitor to disable."
    fi

else
    # Only 1 monitor active -> Enable Secondary
    # We basically need to reload the monitor config or just enable "all".
    # Since we defined them in monitors.conf or auto, "hyprctl reload" usually restores monitors?
    # No, reload might not enable disabled monitors if they were disabled via runtime keyword.
    # Actually, running `hyprctl keyword monitor "NAME, preferred, auto, 1"` enables it.
    
    # We don't know the name of the disabled monitor easily without listing *all* connected monitors (including disabled).
    ALL_MONITORS=$(hyprctl monitors all -j)
    
    # Find one that is disabled
    DISABLED_MONITOR=$(echo "$ALL_MONITORS" | jq -r '.[] | select(.active == false) | .name' | head -n 1)
    
    if [ -n "$DISABLED_MONITOR" ] && [ "$DISABLED_MONITOR" != "null" ]; then
        hyprctl keyword monitor "$DISABLED_MONITOR, preferred, auto, 1"
        notify-send -t 3000 "Monitor Toggle" "Dual Monitor Mode Active\nEnabled: $DISABLED_MONITOR"
    else
        # If no disabled monitor found, maybe just try to reload to force detection?
        # Or maybe the user unlpugged it.
        notify-send "Monitor Toggle" "No disabled monitors found to enable."
    fi
fi
