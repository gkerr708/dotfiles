-- Monitor setup and workspace-to-monitor assignment.

local V = require("variables")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })

if V.on_desktop then
    -- Desktop (home) — two external monitors, side by side
    hl.monitor({ output = V.desktop_left_monitor,  mode = "1920x1080@60",  position = "0x0",    scale = 1 })
    hl.monitor({ output = V.desktop_right_monitor, mode = "1920x1080@144", position = "1920x0", scale = 1 })

    hl.workspace_rule({ workspace = "1", monitor = V.desktop_left_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "2", monitor = V.desktop_left_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "3", monitor = V.desktop_left_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "4", monitor = V.desktop_right_monitor, persistent = true })
    hl.workspace_rule({ workspace = "5", monitor = V.desktop_right_monitor, persistent = true })
    hl.workspace_rule({ workspace = "6", monitor = V.desktop_right_monitor, persistent = true })
    return
end

hl.monitor({ output = V.internal_monitor, mode = "preferred", position = "auto", scale = V.internal_scale })

if V.on_thinkpad then
    -- Thinkpad (work) — dual monitor
    hl.workspace_rule({ workspace = "1", monitor = V.internal_monitor,     persistent = true })
    hl.workspace_rule({ workspace = "2", monitor = V.internal_monitor,     persistent = true })
    hl.workspace_rule({ workspace = "3", monitor = V.internal_monitor,     persistent = true })
    hl.workspace_rule({ workspace = "4", monitor = V.thinkpad_ext_monitor, persistent = true })
    hl.workspace_rule({ workspace = "5", monitor = V.thinkpad_ext_monitor, persistent = true })
    hl.workspace_rule({ workspace = "6", monitor = V.thinkpad_ext_monitor, persistent = true })
else
    -- XPS-13 (home) — single monitor
    hl.workspace_rule({ workspace = "1", monitor = V.xps_ext_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "2", monitor = V.xps_ext_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "3", monitor = V.xps_ext_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "4", monitor = V.xps_ext_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "5", monitor = V.xps_ext_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "6", monitor = V.xps_ext_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "7", monitor = V.xps_ext_monitor,  persistent = true })
    hl.workspace_rule({ workspace = "8", monitor = V.internal_monitor, persistent = true })
end
