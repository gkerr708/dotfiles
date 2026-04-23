-- lua/plugins/project.lua
return {
  "ahmedkhalf/project.nvim",
  lazy = false,
  config = function()
	require("project_nvim").setup({
    manual_mode = true,
	  detection_methods = { "lsp", "pattern" },
	  patterns = { ".git", "Makefile", "package.json", "poetry.lock", "uv.lock" },
	  silent_chdir = true,
	  show_hidden = false,
	  scope_chdir = 'global',
	})
	require("telescope").load_extension("projects")
  end,
  dependencies = {
	"nvim-telescope/telescope.nvim",
  },
}
