return {
  "lervag/vimtex",
  lazy = false,
  ft = { "tex" },
  init = function()
    vim.g.maplocalleader = " "

    -- PDF viewer
    vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_view_automatic = 1

    -- Compiler
    vim.g.vimtex_compiler_method = "latexmk"
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "",
      callback = 1,
      continuous = 1,
      executable = "latexmk",
      options = {
        "-pdf",
        "-shell-escape",
        "-file-line-error",
        "-synctex=1",
        "-interaction=nonstopmode",
      },
    }

    -- QoL
    vim.g.vimtex_quickfix_mode = 1
    vim.g.vimtex_fold_enabled = 0

    -- Function to run latexmk in therminal
    --vim.cmd([[
    --  function! VimtexCompileSS()
    --    let l:cmd = 'latexmk -pdf -shell-escape -file-line-error -synctex=1 -interaction=nonstopmode ' . expand('%:p')
    --    execute 'terminal ' . l:cmd
    --  endfunction
    --]])


    -- Keymaps
    vim.cmd([[
      nmap <localleader>ll <cmd>VimtexCompile<CR>
      nmap <localleader>lv <cmd>VimtexCompileSS<CR>
      nmap <localleader>lk <cmd>VimtexStop<CR>
      nmap <localleader>le <cmd>VimtexErrors<CR>
      nmap <localleader>li <cmd>VimtexInfo<CR>
      nmap <localleader>lc <cmd>VimtexClean<CR>
    ]])
  end,
}
