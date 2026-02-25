#!/bin/bash
upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print substr($2, 1, length($2)-1)}'