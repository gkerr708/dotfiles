-- Monitor setup and workspace-to-monitor assignment.

local V = require("variables")

hl.monitor({ output = "",                 mode = "preferred", position = "auto", scale = "auto" })
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
