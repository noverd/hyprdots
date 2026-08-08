---@module 'hl'

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 8,
        border_size = 2,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
        snap = {
            enabled = true,
        },
        col = {
            active_border = { colors = { "rgba(00d1ffee)", "rgba(00f0ffee)" }, angle = 45 },
            inactive_border = "rgba(1a1a1aaa)",
        },
    },
})
