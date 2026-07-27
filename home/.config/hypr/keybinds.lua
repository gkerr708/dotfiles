-- Keybindings.

local V = require("variables")
local mainMod = V.mainMod
local altMod  = V.altMod

-- Basic
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Z", hl.dsp.window.kill())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("kitty --class wiremix -e wiremix"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(V.menu))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(V.terminal))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(V.browser))

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
