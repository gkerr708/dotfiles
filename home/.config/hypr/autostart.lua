-- Autostart programs on Hyprland launch.

local V = require("variables")

hl.on("hyprland.start", function()
    hl.exec_cmd(V.terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("waybar")

    -- Clipboard fix
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal")

    -- Wallpapers — uncomment the block for your current setup
    -- hl.exec_cmd("swww-daemon")
    -- Thinkpad
    -- hl.exec_cmd("swww img -o " .. V.internal_monitor .. " " .. V.wallpaper_internal .. " --transition-type " .. V.wallpaper_transition .. " --transition-duration " .. V.wallpaper_duration)
    -- hl.exec_cmd("swww img -o " .. V.thinkpad_ext_monitor .. " " .. V.wallpaper_external .. " --transition-type " .. V.wallpaper_transition .. " --transition-duration " .. V.wallpaper_duration)
    -- XPS-13
    -- hl.exec_cmd("swww img -o " .. V.internal_monitor .. " " .. V.wallpaper_internal .. " --transition-type " .. V.wallpaper_transition .. " --transition-duration " .. V.wallpaper_duration)
    -- hl.exec_cmd("swww img -o " .. V.xps_ext_monitor .. " " .. V.wallpaper_external .. " --transition-type " .. V.wallpaper_transition .. " --transition-duration " .. V.wallpaper_duration)
end)
