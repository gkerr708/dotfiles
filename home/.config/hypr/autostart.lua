-- Autostart programs on Hyprland launch.

local V = require("variables")

hl.on("hyprland.start", function()
    hl.exec_cmd(V.terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("waybar")

    -- Clipboard fix
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal")

    -- Wallpaper. hyprpaper preloads images from ~/.config/hypr/hyprpaper.conf
    -- on its own, but actually assigning a wallpaper to a monitor has to go
    -- through hyprctl's IPC once hyprpaper and the monitors are both up —
    -- the config file's own "wallpaper = mon,path" lines aren't applied
    -- automatically on this hyprpaper version.
    local ext_monitor = V.on_thinkpad and V.thinkpad_ext_monitor or V.xps_ext_monitor
    hl.exec_cmd("bash -c 'hyprpaper & sleep 1"
        .. "; hyprctl hyprpaper wallpaper \"" .. V.internal_monitor .. "," .. V.wallpaper_internal .. "\""
        .. "; hyprctl hyprpaper wallpaper \"" .. ext_monitor .. "," .. V.wallpaper_external .. "\"'")
end)
