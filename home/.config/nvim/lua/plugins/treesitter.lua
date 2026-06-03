return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })

      -- Install parsers not already bundled with Neovim 0.12+
      -- (bundled: bash, c, lua, markdown, markdown_inline, python, query, vim, vimdoc)
      require('nvim-treesitter').install({
        'diff',
		    'html',
		    'lua',
		    'luadoc',
		    --'yaml', 
		    'json',
		    --'javascript', 
		    'typescript',
            'css',
		    'scss',
		    'tsx',
		    --'go', 
		    'rust',
		    --'r', 
		    --'rnoweb',
		    'python',
        })

      -- Enable treesitter highlighting for all filetypes that have a parser
      vim.api.nvim_create_autocmd('FileType', {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
}
