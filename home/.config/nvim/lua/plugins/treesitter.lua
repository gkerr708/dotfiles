-- lua/plugins/treesitter.lua
return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html',
        'lua', 'luadoc', 'markdown', 'markdown_inline', 'query',
        'vim', 'vimdoc', 'yaml', 'json', 'javascript', 'typescript',
        'css', 'scss', 'tsx', 'python', 'go', 'rust', 'r', 'rnoweb', 'yaml', 'latex'},
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
}
