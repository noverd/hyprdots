#!/bin/bash
# Get the first line of /proc/stat
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

# Calculate the total and idle times
total_last=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_last=$((idle + iowait))

# Wait for a second
sleep 1

# Read the file again
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat

# Calculate the new total and idle times
total_now=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_now=$((idle + iowait))

# Calculate the difference
total_diff=$((total_now - total_last))
idle_diff=$((idle_now - idle_last))

# Calculate the CPU usage percentage
cpu_usage=$((100 * (total_diff - idle_diff) / total_diff))

echo $cpu_usage