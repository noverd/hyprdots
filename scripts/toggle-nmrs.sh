#!/bin/bash
if [[ $(eww get nmrs-open) == "true" ]]; then
  eww update nmrs-open=false
  killall nmrs
else
  eww update nmrs-open=true
  sleep 0.1 # Add a small delay
  nmrs &
fi
