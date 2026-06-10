return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({
        install_dir = vim.fn.stdpath('data') .. '/site',
      })

      require('nvim-treesitter').install({
        -- languages
        'bash',
        'c',
        'cpp',
        'css',
        'dockerfile',
        'html',
        'json',
        'latex',
        'lua',
        'luadoc',
        'python',
        'rust',
        'scss',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'yaml',
        -- markup / notes
        'bibtex',
        'markdown',
        'markdown_inline',
        -- git
        'git_config',
        'gitcommit',
        'gitignore',
        -- system / config
        'desktop',
        'hyprlang',
        'ini',
        'kitty',
        'xresources',
        -- misc
        'diff',
        'regex',
        'requirements',
      })

      vim.api.nvim_create_autocmd('FileType', {
        callback = function() pcall(vim.treesitter.start) end,
      })
    end,
  },
}
