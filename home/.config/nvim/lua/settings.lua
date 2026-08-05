-- lua/settings.lua or in lua_ls config
vim = vim or {}  -- defensive in case the LSP is analyzing it out of context

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.hlsearch = false
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.wrap = false    -- Disable text wrapping by default
vim.o.mouse = 'a'
vim.opt.clipboard = 'unnamedplus' -- not sure which one is correct
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.scrolloff = 8
vim.o.spelllang = 'en_us'
vim.o.spell = true
vim.g.netrw_liststyle = 0
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.background = "dark" -- or "light" for light mode
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Command to make the current WORD uppercase
vim.keymap.set("n", "gp", "gUiw", { noremap = true, silent = true, desc = "Make WORD uppercase" })

-- JSON needs two space indent
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  command = "setlocal tabstop=2 shiftwidth=2 expandtab"
})

-- Lua needs two space indent
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  command = "setlocal tabstop=2 shiftwidth=2 expandtab"
})

-- Command just for htmlt o change the tabstop
vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  command = "setlocal indentexpr="
})

-- Ensure the signcolumn is always visible
vim.wo.signcolumn = 'yes'

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
	vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Set the highlight group for SignColumn
vim.cmd [[highlight SignColumn guibg=bg]]

-- Enable text wrapping for prose filetypes (.tex, markdown, html), keep it
-- off everywhere else (python, rust, etc). Re-applied on BufEnter too, since
-- 'wrap' is window-local and switching between already-loaded buffers in the
-- same window doesn't re-fire FileType.
local wrap_filetypes = { tex = true, markdown = true, html = true }
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("prose_wrap", { clear = true }),
  pattern = "*",
  callback = function()
    if wrap_filetypes[vim.bo.filetype] then
      vim.wo.wrap = true
      vim.wo.linebreak = true
    else
      vim.wo.wrap = false
      vim.wo.linebreak = false
    end
  end,
})

vim.g.WebDevIconsNerdTreeAfterGlyphPadding = '  '
