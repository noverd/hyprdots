#!/bin/bash
if bluetoothctl show | grep -q "Powered: yes"; then
    if bluetoothctl info | grep -q "Connected: yes"; then
        bluetoothctl info | grep "Name:" | awk '{print $2}'
    else
        echo "On"
    fi
else
    echo "Off"
fi
