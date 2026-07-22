-- Migrated from hyprland.conf (hyprlang) to the Lua config introduced in Hyprland 0.55.
-- Reference: https://wiki.hypr.land/Configuring/Start/

---------------
-- Variables --
---------------

-- Monitors
local laptop_monitor   = "eDP-1"
local work_monitor     = "HDMI-A-2" -- Thinkpad work
local xps_home_monitor = "DP-1"     -- XPS-13 work
-- local xps_home_monitor = "DP-3"  -- XPS-13 home

-- Scale
local laptop_scale = 1.25

-- Programs
local terminal    = "kitty"
local fileManager = "kitty -e yazi"
local menu        = "wofi --show drun --style ~/.config/wofi/style.css"
local browser     = "firefox"

-- Wallpapers
local wallpaper_laptop     = "/home/gkerr/images/arch1.jpg"
local wallpaper_extern     = "/home/gkerr/images/arch5.jpg"
local wallpaper_transition = "any"
local wallpaper_duration   = 0.7

-- Look and feel
local gaps_in     = 1
local gaps_out    = 1
local border_size = 1
local rounding     = 4

-- Colors
local color_active_1 = "rgba(33ccffee)"
local color_active_2 = "rgba(00ff99ee)"
local color_inactive = "rgba(595959aa)"
local color_shadow   = "rgba(1a1a1aee)"

-- Cursor
local cursor_size = 24

-- Input
local kb_layout    = "us"
local mouse_sens   = 0.0
local repeat_rate  = 40
local repeat_delay = 250

-- Modifiers
local mainMod = "SUPER"
local altMod  = "ALT"


---------------
-- Display   --
---------------

hl.on("hyprland.start", function()
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("waybar")

    -- Clipboard fix
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal")

    -- Wallpapers — uncomment the block for your current setup
    -- hl.exec_cmd("swww-daemon")
    -- Thinkpad
    -- hl.exec_cmd("swww img -o " .. laptop_monitor .. " " .. wallpaper_laptop .. " --transition-type " .. wallpaper_transition .. " --transition-duration " .. wallpaper_duration)
    -- hl.exec_cmd("swww img -o " .. work_monitor   .. " " .. wallpaper_extern .. " --transition-type " .. wallpaper_transition .. " --transition-duration " .. wallpaper_duration)
    -- XPS-13
    -- hl.exec_cmd("swww img -o " .. laptop_monitor     .. " " .. wallpaper_laptop .. " --transition-type " .. wallpaper_transition .. " --transition-duration " .. wallpaper_duration)
    -- hl.exec_cmd("swww img -o " .. xps_work_monitor   .. " " .. wallpaper_extern .. " --transition-type " .. wallpaper_transition .. " --transition-duration " .. wallpaper_duration)
    -- hl.exec_cmd("swww img -o " .. xps_home_monitor   .. " " .. wallpaper_extern .. " --transition-type " .. wallpaper_transition .. " --transition-duration " .. wallpaper_duration)
end)

-- Monitors
hl.monitor({ output = "",             mode = "preferred", position = "auto", scale = "auto" })
hl.monitor({ output = laptop_monitor, mode = "preferred", position = "auto", scale = laptop_scale })


-------------------
-- MONITORS Work --
-------------------

-- Thinkpad — enabled
hl.workspace_rule({ workspace = "1", monitor = laptop_monitor, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = laptop_monitor, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = laptop_monitor, persistent = true })
hl.workspace_rule({ workspace = "4", monitor = work_monitor,   persistent = true })
hl.workspace_rule({ workspace = "5", monitor = work_monitor,   persistent = true })
hl.workspace_rule({ workspace = "6", monitor = work_monitor,   persistent = true })

-- XPS-13 work — uncomment to use
-- hl.workspace_rule({ workspace = "1", monitor = laptop_monitor,   persistent = true })
-- hl.workspace_rule({ workspace = "2", monitor = laptop_monitor,   persistent = true })
-- hl.workspace_rule({ workspace = "3", monitor = laptop_monitor,   persistent = true })
-- hl.workspace_rule({ workspace = "4", monitor = xps_work_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "5", monitor = xps_work_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "6", monitor = xps_work_monitor, persistent = true })


-------------------
-- MONITORS Home --
-------------------

-- XPS-13 home (two monitors) — uncomment to use
-- hl.workspace_rule({ workspace = "1", monitor = laptop_monitor,   persistent = true })
-- hl.workspace_rule({ workspace = "2", monitor = laptop_monitor,   persistent = true })
-- hl.workspace_rule({ workspace = "3", monitor = laptop_monitor,   persistent = true })
-- hl.workspace_rule({ workspace = "4", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "5", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "6", monitor = xps_home_monitor, persistent = true })

-- Single monitor home — uncomment to use
-- hl.workspace_rule({ workspace = "1", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "2", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "3", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "4", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "5", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "6", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "7", monitor = xps_home_monitor, persistent = true })
-- hl.workspace_rule({ workspace = "8", monitor = laptop_monitor,   persistent = true })


---------------------------
-- ENVIRONMENT VARIABLES --
---------------------------

hl.env("XCURSOR_SIZE", tostring(cursor_size))
hl.env("HYPRCURSOR_SIZE", tostring(cursor_size))


-------------------
-- LOOK AND FEEL --
-------------------

hl.config({
    general = {
        gaps_in     = gaps_in,
        gaps_out    = gaps_out,
        border_size = border_size,

        col = {
            active_border   = { colors = { color_active_1, color_active_2 }, angle = 45 },
            inactive_border = color_inactive,
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = rounding,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = color_shadow,
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true, -- was: enabled = yes, please :)
    },
})

hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1.0 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

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


-----------
-- INPUT --
-----------

hl.config({
    input = {
        kb_layout     = kb_layout,
        repeat_rate   = repeat_rate,
        repeat_delay  = repeat_delay,

        follow_mouse  = 1,
        sensitivity   = mouse_sens,
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


------------------
-- KEYBINDINGS  --
------------------

-- Basic
hl.bind(mainMod .. " + Q", hl.dsp.window.kill())
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty --class wiremix -e wiremix"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))

-- Focus
hl.bind(altMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(altMod .. " + j", hl.dsp.focus({ direction = "down" }))
hl.bind(altMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(altMod .. " + l", hl.dsp.focus({ direction = "right" }))

-- Split
-- hl.bind(mainMod .. " + P", hl.dsp.layout("togglesplit")) -- Removed in update (2026-05-30 ish)

-- Swap windows
hl.bind(mainMod .. " + " .. altMod .. " + h", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + " .. altMod .. " + j", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + " .. altMod .. " + k", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + " .. altMod .. " + l", hl.dsp.window.swap({ direction = "right" }))

-- Resize
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.resize({ x = -30, y = 0,  relative = true }))
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.resize({ x = 0,   y = 30, relative = true }))
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.resize({ x = 0,   y = -30, relative = true }))
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.resize({ x = 30,  y = 0,  relative = true }))

-- Switch workspace
hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + D", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + F", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + G", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + SEMICOLON", hl.dsp.focus({ workspace = "10" }))
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = "5" }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = "6" }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = "7" }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = "8" }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = "9" }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = "10" }))

-- Move window to workspace
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + SEMICOLON", hl.dsp.window.move({ workspace = "10" }))
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = "4" }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = "5" }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = "6" }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = "7" }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = "8" }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = "9" }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))

-- Mouse
hl.bind(altMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(altMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume & brightness
hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",       hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",    hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 2%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 2%-"),                  { locked = true, repeating = true })

-- Media
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


----------------------------
-- WINDOWS AND WORKSPACES --
----------------------------

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
