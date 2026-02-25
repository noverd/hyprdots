#!/bin/bash
if [[ $(eww get mic-slider-open) == "true" ]]; then
  eww update mic-slider-open=false
  eww close mic-slider-win
else
  eww update mic-slider-open=true
  eww open mic-slider-win
fi
