#!/bin/sh

if [ ! -f /sys/class/power_supply/BAT0/capacity ]; then
    exit 0
fi

# Get battery status and capacity
status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
cap=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)

CRITICAL_COLOR="#ff3838"  # Red
WARNING_COLOR="#ffd166"   # Yellow
NORMAL_COLOR="#50fa7b"    # Green
CHARGING_COLOR="#00d1ff"  # Active blue
FULL_COLOR="#a6e3a1"      # Light green

case "$status" in
    "Discharging")
        if [ "$cap" -lt 15 ]; then
            # Critical discharge - red with bold
            printf '<span color="%s" font_weight="bold">BAT: %d%% CRITICAL</span>' "$CRITICAL_COLOR" "$cap"
        elif [ "$cap" -lt 30 ]; then
            # Low battery - yellow
            printf '<span color="%s">BAT: %d%% LOW</span>' "$WARNING_COLOR" "$cap"
        else
            # Normal discharge - green
            printf '<span color="%s">BAT: %d%%</span>' "$NORMAL_COLOR" "$cap"
        fi
        ;;
    "Charging")
        # Charging - active blue
        printf '<span color="%s">BAT: %d%% CHARGING</span>' "$CHARGING_COLOR" "$cap"
        ;;
    "Full")
        # Full battery - light green
        printf '<span color="%s">BAT: FULL</span>' "$FULL_COLOR"
        ;;
    *)
        # Unknown status - neutral green
        printf '<span color="%s">BAT: %d%%</span>' "$NORMAL_COLOR" "$cap"
        ;;
esac
