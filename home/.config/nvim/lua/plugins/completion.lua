return {
  {
    "saghen/blink.lib",
  },
  {
    -- Bridge so nvim-cmp sources (e.g. vim-dadbod-completion) work in blink
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.lib", "saghen/blink.compat" },
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        -- Table/column/alias completion inside SQL buffers
        per_filetype = {
          sql = { inherit_defaults = true, "dadbod" },
          mysql = { inherit_defaults = true, "dadbod" },
          plsql = { inherit_defaults = true, "dadbod" },
        },
        providers = {
          dadbod = {
            name = "dadbod",
            module = "blink.compat.source",
            score_offset = 100,
          },
        },
      },
    },
  },
}
