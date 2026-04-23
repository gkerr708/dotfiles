-- colors/mytheme.lua
vim.cmd("hi clear")
vim.g.colors_name = "mytheme"

local groups = require("mytheme.highlights").highlights

for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
end
