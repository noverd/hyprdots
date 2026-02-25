#!/bin/bash
if [[ $(eww get calendar-open) == "true" ]]; then
  eww update calendar-open=false
  eww close calendar-win
else
  eww update calendar-open=true
  sleep 0.1 # Add a small delay
  eww open calendar-win
fi