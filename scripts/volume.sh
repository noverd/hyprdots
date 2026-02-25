#!/bin/bash
pactl subscribe | while read -r event; do
    if echo "$event" | grep -q "sink"; then
        pactl get-sink-mute @DEFAULT_SINK@ | grep -oP 'yes|no'
    fi
done
