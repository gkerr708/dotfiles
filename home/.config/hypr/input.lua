-- Keyboard, mouse, and touchpad input configuration.

local V = require("variables")

hl.config({
    input = {
        kb_layout     = V.kb_layout,
        repeat_rate   = V.repeat_rate,
        repeat_delay  = V.repeat_delay,

        follow_mouse  = 1,
        sensitivity   = V.mouse_sens,
        accel_profile = "flat",

        touchpad = {
            natural_scroll = true,
        },
    },

    cursor = {
        no_warps = false,
    },
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})
