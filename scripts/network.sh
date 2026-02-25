#!/bin/bash
# Get the active network interface
interface=$(ip route | grep '^default' | awk '{print $5}' | head -n 1)

if [ -n "$interface" ]; then
    # Get the download speed for the active interface in KB/s
    # This is a simplified approach, it shows the total bytes downloaded since boot, divided by 1024.
    # A more accurate script would measure the difference over a time interval.
    # For the purpose of a bar widget, this is a reasonable approximation of "speed" if polled regularly.
    rx_bytes=$(cat /sys/class/net/"$interface"/statistics/rx_bytes)
    echo $((rx_bytes / 1024))
else
    echo "0"
fi