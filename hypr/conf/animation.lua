---@module 'hl'

hl.config({
    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuad", { type = "bezier", points = { {0.25, 0.46}, {0.45, 0.94} } }) -- Optimal
hl.curve("easeInQuad",  { type = "bezier", points = { {0.55, 0.085}, {0.68, 0.53} } }) -- For window closing
hl.curve("linear", { type = "bezier", points = {{0, 0}, {1, 1}}})                  -- For critical


hl.animation({ leaf = "global", enabled = true, speed = 1, bezier = "easeOutQuad" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "easeOutQuad", style = "popin 85%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "easeInQuad", style = "popin 85%" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "fade", enabled = true, speed = 1, bezier = "linear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "easeOutQuad", style = "slidefade 10%" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "easeOutQuad", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "easeInQuad", style = "fade" })
