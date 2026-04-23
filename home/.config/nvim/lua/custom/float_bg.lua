-- custom/float_bg.lua
vim.opt.termguicolors = true

local border_color = "#89b4fa"

local groups = { "NormalFloat", "FloatBorder", "LazyNormal", "Pmenu", "PmenuSel" }

local function clear()
  -- Transparent background for floating windows and popup menus
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "NONE" })
  end

  -- Match popup menu selection to your theme (optional)
  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#333333", fg = "#ffffff" })

  -- Borders and titles for LSP float windows
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = border_color, bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatTitle",  { fg = border_color, bg = "NONE", bold = true })
end

-- apply now (if colorscheme already loaded) and re-apply after any colorscheme change
pcall(clear)
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  callback = function() vim.schedule(clear) end,
})
