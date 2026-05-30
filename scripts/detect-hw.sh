if [[ $(ls /sys/class/power_supply/) == *"BAT"* ]]; then
    eww update battery=true
else 
	eww update battery=false
fi
