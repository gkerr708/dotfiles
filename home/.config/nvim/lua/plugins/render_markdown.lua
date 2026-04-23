return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    enabled = false,
    file_types = { "markdown", "Avante" },
  },
  ft = { "markdown", "Avante" },
  keys = {
    { "<leader>md", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Render Markdown" },
  },
}
