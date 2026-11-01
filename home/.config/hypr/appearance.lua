-- Environment variables, colors, and decoration.

local V = require("variables")

hl.env("XCURSOR_SIZE", tostring(V.cursor_size))
hl.env("HYPRCURSOR_SIZE", tostring(V.cursor_size))

hl.config({
    general = {
        gaps_in     = V.gaps_in,
        gaps_out    = V.gaps_out,
        border_size = V.border_size,

        col = {
            active_border   = V.color_active,
            inactive_border = V.color_inactive,
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = V.rounding,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = { enabled = false },
        blur   = { enabled = false },
    },

    animations = {
        enabled = false,
    },
})

hl.config({
    dwindle = {
        -- pseudotile = true, -- Removed in update (2026-05-30 ish)
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})
