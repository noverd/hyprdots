---@module 'hl'

local detect_hw = require("scripts.detect-hw")

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- hypridle")
    hl.exec_cmd("uwsm app -- swayosd-server")
    hl.exec_cmd("uwsm app -- swaync")
    hl.exec_cmd("uwsm app -- hyprpaper")
    hl.exec_cmd("uwsm app -- hyprsunset")
    hl.exec_cmd("uwsm app -- walker --gapplication-service")
    hl.exec_cmd("uwsm app -- elephant")
    hl.exec_cmd("uwsm app -- hyprpolkitagent")
    hl.exec_cmd("eww daemon")
    hl.exec_cmd("eww open topbar")
    detect_hw()
end)
