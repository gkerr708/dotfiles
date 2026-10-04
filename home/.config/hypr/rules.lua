-- Window and layer rules.

hl.layer_rule({
    name  = "layerrule-1",
    match = { namespace = "waybar" },

    blur         = true,
    ignore_alpha = 0.2,
})

hl.window_rule({
    name  = "windowrule-1",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    name  = "windowrule-2",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Games open on the 144 Hz monitor (workspace 4 lives on desktop_right_monitor).
hl.window_rule({
    name  = "windowrule-hll-vietnam",
    match = { class = "^steam_app_3079210$" },

    workspace = "4",
})
