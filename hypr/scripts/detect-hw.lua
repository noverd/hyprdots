local function detect_hw()
    local f = io.popen("ls /sys/class/power_supply/ 2>/dev/null")
    local state = "false"

    if f then
        if f:read("*a"):match("BAT") then
            state = "true"
        end
        f:close()
    end

    hl.exec_cmd("eww update battery=" .. state)
end

return detect_hw
