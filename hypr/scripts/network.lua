local function get_default_interface()
    local f = io.open("/proc/net/route", "r")
    if not f then return nil end
    f:read("*l")
    for line in f:lines() do
        local iface, dest = line:match("^(%S+)%s+([0-9A-F]+)")
        if dest == "00000000" then
            f:close()
            return iface
        end
    end
    f:close()
    return nil
end

local function read_bytes(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local line = f:read("*l")
    f:close()
    return line and tonumber(line)
end

local function format_bytes(bytes_per_sec)
    local units = { "", "K", "M", "G", "T", "P" }
    local i = 1
    local value = bytes_per_sec
    while value >= 1024 and i < #units do
        value = value / 1024
        i = i + 1
    end

    if i == 1 or value >= 10 then
        return string.format("%.0f%sB/s", value, units[i])
    else
        local str = string.format("%.1f", value):gsub("%.0$", "")
        return str .. units[i] .. "B/s"
    end
end

local prev_state = {
    interface = nil,
    rx = nil,
    tx = nil,
    time = nil
}

local function get_speed_raw(interface)
    local rx_path = "/sys/class/net/" .. interface .. "/statistics/rx_bytes"
    local tx_path = "/sys/class/net/" .. interface .. "/statistics/tx_bytes"

    local current_rx = read_bytes(rx_path)
    local current_tx = read_bytes(tx_path)
    local current_time = os.time()

    if not current_rx or not current_tx then return nil end

    if prev_state.interface ~= interface then
        prev_state.interface = interface
        prev_state.rx = current_rx
        prev_state.tx = current_tx
        prev_state.time = current_time
        return 0, 0, 0
    end

    local time_diff = current_time - prev_state.time
    if time_diff <= 0 then time_diff = 1 end

    local diff_rx = (current_rx < prev_state.rx) and current_rx or (current_rx - prev_state.rx)
    local diff_tx = (current_tx < prev_state.tx) and current_tx or (current_tx - prev_state.tx)

    local rx_speed = diff_rx / time_diff
    local tx_speed = diff_tx / time_diff
    local total_speed = rx_speed + tx_speed

    prev_state.rx = current_rx
    prev_state.tx = current_tx
    prev_state.time = current_time

    return total_speed, rx_speed, tx_speed
end

local function get_speed(interface, verbose)
    if not interface then
        interface = get_default_interface()
        if not interface then
            return verbose and { rx = "0B/s", tx = "0B/s", total = "0B/s" } or { total = "0B/s" }
        end
    end

    local total, rx, tx = get_speed_raw(interface)

    if not total then
        return verbose and { rx = "0B/s", tx = "0B/s", total = "0B/s" } or { total = "0B/s" }
    end

    if verbose then
        return {
            rx = format_bytes(rx),
            tx = format_bytes(tx),
            total = format_bytes(total)
        }
    else
        return { total = format_bytes(total) }
    end
end

local function update_eww(speed_str)
    hl.exec_cmd("eww update network-speed='" .. speed_str .. "'")
end

local current_interface = get_default_interface()
local initial_speed = get_speed(current_interface)
update_eww(initial_speed.total)

local interface_timer = hl.timer(function()
    current_interface = get_default_interface()
    if current_interface == nil then
        update_eww("0B/s")
    end
end, { timeout = 8000, type = "repeat" })

local speed_timer = hl.timer(function()
    if current_interface == nil then
        return
    end
    local speed = get_speed(current_interface)
    update_eww(speed.total)
end, { timeout = 1000, type = "repeat" })

interface_timer:set_enabled(true)
speed_timer:set_enabled(true)
