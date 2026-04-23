return {
  "R-nvim/R.nvim",
  lazy = false,
  config = function()
    local opts = {
      -- Don't hijack <Enter>. Use localleader keys instead (optional).
      hook = {
        on_filetype = function()
          -- use <localleader>l to send line, <localleader>s to send selection
          vim.keymap.set("n", "<localleader>l", "<Plug>RDSendLine", { buffer = true, silent = true })
          vim.keymap.set("v", "<localleader>s", "<Plug>RSendSelection", { buffer = true, silent = true })
        end
      },

      -- quiet R
      R_args = {"--quiet", "--no-save"},
      min_editor_width = 72,
      rconsole_width = 78,

      -- explicitly DISABLE auto start so you won't see the prompt unless you start R yourself
      auto_start = "no",

      objbr_mappings = {
        c = 'class',
        ['<localleader>gg'] = 'head({object}, n = 15)',
        v = function() require('r.browser').toggle_view() end,
      },
      disable_cmds = { "RClearConsole","RCustomStart","RSPlot","RSaveClose" },
    }

    -- If you *want* auto-start sometimes, export R_AUTO_START=true in shell
    if vim.env.R_AUTO_START == "true" then
      opts.auto_start = "on startup"
      opts.objbr_auto_start = true
    end

    require("r").setup(opts)
  end,
}
