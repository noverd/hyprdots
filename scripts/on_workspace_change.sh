eww update current-workspace=$(hyprctl monitors -j | jq '.[0].activeWorkspace.id' | tr -d '\"')
handle() {
  case "$1" in
    workspacev2*)
      data="${1#*>>}"
      num="${data%%,*}"
      eww update current-workspace=$num
      ;;
  esac
}

socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done
