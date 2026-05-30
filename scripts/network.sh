#!/bin/bash

interface=$(ip route | grep '^default' | awk '{print $5; exit}')
[[ -z "$interface" ]] && { echo "0B/s"; exit 1; }

rx_file="/sys/class/net/${interface}/statistics/rx_bytes"
tx_file="/sys/class/net/${interface}/statistics/tx_bytes"

rx1=$(cat "$rx_file")
tx1=$(cat "$tx_file")

sleep 1

rx2=$(cat "$rx_file")
tx2=$(cat "$tx_file")

(( rx2 < rx1 )) && rx1=0 # i hate math in bash
(( tx2 < tx1 )) && tx1=0

total_speed=$(( (rx2 - rx1) + (tx2 - tx1) ))

numfmt --to=iec --round=nearest --suffix='B' --format="%.0f" <<< "$total_speed"
