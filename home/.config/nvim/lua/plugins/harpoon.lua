return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },

  config = function()
    local harpoon = require("harpoon")
    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    })

    -- Core Harpoon keymaps
    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
    vim.keymap.set("n", "<leader>v", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
    vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
    vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
    vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
    vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
    vim.keymap.set("n", "<leader>n", function() harpoon:list():next() end, { desc = "Harpoon next" })
    vim.keymap.set("n", "<leader>p", function() harpoon:list():prev() end, { desc = "Harpoon prev" })

    -- Telescope picker for Harpoon marks
    local function harpoon_picker()
      local list = harpoon:list()
      local items = {}
      for i, it in ipairs(list.items) do
        table.insert(items, { idx = i, path = it.value })
      end

      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local conf    = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      pickers.new({}, {
        prompt_title = "Harpoon",
        finder = finders.new_table {
          results = items,
          entry_maker = function(entry)
            return {
              value = entry.idx,
              ordinal = entry.path,
              display = string.format("%d. %s", entry.idx, entry.path),
            }
          end,
        },
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
          local select = function(bufnr)
            local entry = action_state.get_selected_entry()
            actions.close(bufnr)
            list:select(entry.value)
          end
          map("i", "<CR>", select)
          map("n", "<CR>", select)
          return true
        end,
      }):find()
    end

    -- Keymap to open the Telescope picker
    vim.keymap.set("n", "<leader>he", harpoon_picker, { desc = "Harpoon via Telescope" })
  end,
}
