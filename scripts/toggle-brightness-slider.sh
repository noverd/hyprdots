#!/bin/bash
if eww active-windows | grep -q "brightness-slider-win"; then
    eww close brightness-slider-win
else
    eww open brightness-slider-win
fi
