-- Shared config values and machine detection, used by the other hyprland.lua modules.

local M = {}

-- Monitors
M.internal_monitor     = "eDP-1"      -- built-in panel (both machines)
M.thinkpad_ext_monitor  = "HDMI-A-2"  -- Thinkpad's external/dock monitor
M.xps_ext_monitor       = "DP-1"      -- XPS's external monitor (work dock)
-- M.xps_ext_monitor   = "DP-3"       -- XPS's external monitor (home dock)

-- Scale
M.internal_scale = 1.25

-- Programs
M.terminal    = "kitty"
M.fileManager = "kitty -e yazi"
M.menu        = "wofi --show drun --style ~/.config/wofi/style.css"
M.browser     = "firefox"

-- Wallpapers
M.wallpaper_internal  = "/home/gkerr/images/arch1.jpg"
M.wallpaper_external  = "/home/gkerr/images/arch5.jpg"
M.wallpaper_transition = "any"
M.wallpaper_duration   = 0.7

-- Look and feel
M.gaps_in     = 1
M.gaps_out    = 1
M.border_size = 1
M.rounding    = 4

-- Colors
M.color_active_1 = "rgba(33ccffee)"
M.color_active_2 = "rgba(00ff99ee)"
M.color_inactive = "rgba(595959aa)"
M.color_shadow   = "rgba(1a1a1aee)"

-- Cursor
M.cursor_size = 24

-- Input
M.kb_layout    = "us"
M.mouse_sens   = 0.0
M.repeat_rate  = 40
M.repeat_delay = 250

-- Modifiers
M.mainMod = "SUPER"
M.altMod  = "ALT"

-- Machine detection (Thinkpad = work, anything else = XPS/home)
local function is_thinkpad()
    local f = io.open("/sys/class/dmi/id/sys_vendor", "r")
    if not f then return false end
    local vendor = f:read("*l")
    f:close()
    return vendor ~= nil and vendor:match("LENOVO") ~= nil
end

M.on_thinkpad = is_thinkpad()

return M
