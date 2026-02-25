#!/bin/bash
if [[ $(eww get volume-slider-open) == "true" ]]; then
  eww update volume-slider-open=false
  eww close volume-slider-win
else
  eww update volume-slider-open=true
  eww open volume-slider-win
fi
