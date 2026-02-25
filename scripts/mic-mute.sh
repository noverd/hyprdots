#!/bin/bash
pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}'
