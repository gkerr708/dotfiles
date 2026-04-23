-- init.lua
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- LSP compat shim for plugins still calling vim.lsp.buf_get_clients()
--@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf_get_clients = function(bufnr)
  return vim.lsp.get_clients({ bufnr = bufnr })
end

-- It's hard to make a color scheme that doesn't look like trash.
--vim.cmd("colorscheme mytheme")

require("config.lazy")
require("settings")
require("key_mappings")
--require("custom.float_bg") -- setup transparent floating backgrounds
-- require("custom.math").setup()
