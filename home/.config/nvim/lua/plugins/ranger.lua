return {
  --"kevinhwang91/rnvimr",
  --config = function()
  --  -- Enable :Rnvimr and picker behavior (open files in nvim)
  --  vim.g.rnvimr_enable_ex = 1
  --  vim.g.rnvimr_enable_picker = 1

  --  -- Optional UI polish
  --  vim.g.rnvimr_draw_border = 1
  --  vim.g.rnvimr_shadow_winblend = 15
  --  vim.g.rnvimr_border_attr = { fg = 14, bg = -1 }

  --  vim.g.rnvimr_enable_ex = 1
  --  vim.g.rnvimr_enable_picker = 1
  --  vim.g.rnvimr_action = {
  --    ["<CR>"] = "NvimEdit",           -- open in current window
  --    ["C-m"] = "NvimEdit",
  --    ["s"]    = "NvimEdit split",
  --    ["v"]    = "NvimEdit vsplit",
  --    ["t"]    = "NvimEdit tabedit",
  --  }

  --  -- Toggle with <leader>f
  --  vim.keymap.set("n", "<leader>f", ":RnvimrToggle<CR>", { silent = true, desc = "Toggle Ranger" })

  --  -- OPTIONAL: disable netrw if you never use it
  --  -- (rnvimr works either way, but disabling netrw avoids it catching dirs)
  --  vim.g.loaded_netrw = 1
  --  vim.g.loaded_netrwPlugin = 1

  --  -- Auto-open Ranger when launching `nvim` on a directory (e.g., `nvim .`)
  --  vim.api.nvim_create_autocmd("VimEnter", {
  --    callback = function()
  --      if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
  --        vim.cmd("RnvimrToggle")
  --        -- Optional: close the dummy directory buffer if it was opened
  --        pcall(vim.cmd, "bd 1")
  --      end
  --    end,
  --  })
  --end,
}
