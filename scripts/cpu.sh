#!/bin/bash

read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
total_last=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_last=$((idle + iowait))
sleep 1
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
total_now=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_now=$((idle + iowait))
total_diff=$((total_now - total_last))
idle_diff=$((idle_now - idle_last))
cpu_usage=$((100 * (total_diff - idle_diff) / total_diff))

echo $cpu_usage
