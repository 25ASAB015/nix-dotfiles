#!/usr/bin/env bash

CONFIG_FILE="$HOME/.config/.weather_location"

if [ -z "$1" ]; then
    echo "Usage: $0 \"City, Country\""
    echo "Current location: $(cat "$CONFIG_FILE" 2>/dev/null || echo 'Not set')"
    exit 1
fi

# URL encode the argument (simple version, mostly for spaces)
LOCATION=$(echo "$*" | sed 's/ /+/g')

echo "$LOCATION" > "$CONFIG_FILE"
echo "Weather location set to: $LOCATION"
echo "Waybar should update automatically within 30 seconds."
