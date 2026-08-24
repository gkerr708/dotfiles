-- lua/plugins/dadbod.lua
-- SQL exploration: vim-dadbod (engine) + dadbod-ui (sidebar) + completion
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true, cmd = { "DB", "DBUI" } },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
      { "<leader>db", "<cmd>DBUIToggle<cr>", desc = "Database UI toggle" },
      { "<leader>df", "<cmd>DBUIFindBuffer<cr>", desc = "Database find buffer" },
      { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Database add connection" },
    },
    init = function()
      -- Saved queries + connection list live outside the git repo
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 35
      -- Don't clutter buffers with the auto-generated query header
      vim.g.db_ui_disable_mappings_dbout = 0
      vim.g.db_ui_execute_on_save = 0 -- run with <leader>S / :w is not enough

      -- Nicer defaults inside dadbod buffers
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          vim.opt_local.wrap = false
          vim.opt_local.foldenable = false
        end,
      })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dbout",
        callback = function()
          vim.opt_local.wrap = false
          vim.opt_local.number = false
        end,
      })
    end,
  },
}
