-- Migrated from hyprland.conf (hyprlang) to the Lua config introduced in Hyprland 0.55.
-- Reference: https://wiki.hypr.land/Configuring/Start/
--
-- Split into modules living alongside this file in ~/.config/hypr/.
-- Each is re-read fresh on every `hyprctl reload` (require() is not
-- stale-cached across reloads on this Hyprland build).

require("variables")
require("autostart")
require("monitors")
require("appearance")
require("input")
require("keybinds")
require("rules")
