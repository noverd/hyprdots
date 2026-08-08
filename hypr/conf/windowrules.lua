---@module 'hl'

hl.window_rule({
    name  = "nmrs_rule",
    match = {
        class = "org.netrs.ui",
    },
    float = true
})

hl.window_rule({
    name             = "flameshot_rule",
    match            = {
        class = "flameshot",
    },
    no_anim          = true,
    float            = true,
    move             = { 0, 0 },
    pin              = true,
    no_initial_focus = true,
    monitor          = 1
})
