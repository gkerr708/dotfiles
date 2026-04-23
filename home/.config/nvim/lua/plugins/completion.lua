return {
  {
    "saghen/blink.lib",
  },
  {
    "saghen/blink.cmp",
    dependencies = { "saghen/blink.lib" },
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
