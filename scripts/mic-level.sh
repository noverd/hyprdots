#!/bin/bash
pactl get-source-volume @DEFAULT_SOURCE@ | awk '/Volume:/ {print $5}' | tr -d '%'
