local paths = require("util.paths")

vim = vim or {} -- idk why this is bad but I hope I'm not being a dumbass

-- Python
vim.keymap.set('n', '<Leader>rp', function()
  local python_cmd = paths.get_python_path()
  local filename = vim.fn.shellescape(paths.get_current_file_path())
  local project_root = vim.fn.getcwd()

  local cmd = "cd " .. vim.fn.shellescape(project_root) .. " && PYTHONPATH=. " .. python_cmd .. " " .. filename
  vim.cmd("belowright split | terminal echo '" .. python_cmd .. " " .. filename .. "' && echo '' && " .. cmd)
  vim.cmd("stopinsert")
end, { silent = false })

vim.keymap.set('n', '<Leader>rm', function()
  --local file = vim.fn.expand("%:p")          -- full path
  local ext  = vim.fn.expand("%:e")          -- extension
  local project_root = vim.fn.getcwd()
  local module_name = paths.get_module_name()

  if ext == "rs" then
    -- Check for Cargo project
    if vim.fn.filereadable(project_root .. "/Cargo.toml") == 1 then
      local rel = vim.fn.expand("%:r")            -- relative path without extension
      local name = vim.fn.expand("%:t:r")         -- file name without extension
      local cargo_cmd
      if rel:match("src/main$") then
        -- main.rs → default binary
        cargo_cmd = "cargo run"
      elseif rel:match("src/bin/") then
        -- src/bin/foo.rs → cargo run --bin foo
        cargo_cmd = "cargo run --bin " .. name
      else
        -- unknown context: no runnable binary
        vim.notify("No runnable Rust binary in this location", vim.log.levels.WARN)
        return
      end
      local cmd = "cd " .. project_root .. " && " .. cargo_cmd
      vim.cmd("belowright split | terminal echo '" .. cargo_cmd .. "' && echo '' && " .. cmd)
      vim.cmd("stopinsert")
      return
    end
  end

  -- Python
  if ext == "py" then
    module_name = module_name:gsub("%.py$", "")

    local python_cmd
    if vim.fn.filereadable(project_root .. "/uv.lock") == 1 then
      python_cmd = "uv run"
    elseif vim.fn.filereadable(project_root .. "/poetry.lock") == 1 then
      python_cmd = "poetry run python3"
    else
      python_cmd = "python3"
    end  

    local cmd = "cd " .. project_root .. " && PYTHONPATH=. " .. python_cmd .. " -m " .. module_name

    vim.cmd("belowright split | terminal echo '" .. python_cmd .. " -m " .. module_name .. "' && echo '' && " .. cmd)
    vim.cmd("stopinsert")
  end
end, { silent = false })

-- Alt way to run latex files
--vim.keymap.set('n', '<Leader>rl', function()
--  local file = vim.fn.expand("%:p")
--  local cmd = "latexmk -pdf -shell-escape -file-line-error -synctex=1 -interaction=nonstopmode " ..
--              vim.fn.shellescape(file)
--
--  if vim.bo.filetype ~= "tex" then
--    vim.notify("Not a LaTeX file", vim.log.levels.WARN)
--    return
--  end
--  vim.cmd("belowright split | terminal " .. cmd)
--  vim.cmd("stopinsert")
--end, { silent = false })

-- Run tests
vim.keymap.set('n', '<Leader>rt', function()
  local ext = vim.fn.expand("%:e")
  local project_root = vim.fn.getcwd()

  ---------------------------------------------------------
  -- RUST: cargo test
  ---------------------------------------------------------
  if ext == "rs" then
    if vim.fn.filereadable(project_root .. "/Cargo.toml") == 1 then
      local cmd = "cd " .. project_root .. " && cargo test -- --nocapture"
      vim.cmd("belowright split | terminal echo 'cargo test' && echo '' && " .. cmd)
      vim.cmd("stopinsert")
      return
    end
  end

  ---------------------------------------------------------
  -- PYTHON: pytest (uv/poetry/system python)
  ---------------------------------------------------------
  if ext == "py" then
    local python_cmd
    if vim.fn.filereadable(project_root .. "/uv.lock") == 1 then
      python_cmd = "uv run"
    elseif vim.fn.filereadable(project_root .. "/poetry.lock") == 1 then
      python_cmd = "poetry run"
    else
      python_cmd = "python3 -m"
    end

    -- pytest command
    local cmd = "cd " .. project_root .. " && " .. python_cmd .. " pytest -v -s"

    vim.cmd("belowright split | terminal echo '" .. python_cmd .. " pytest -v -s' && echo '' && " .. cmd)
    vim.cmd("stopinsert")
    return
  end

  ---------------------------------------------------------
  -- If neither type
  ---------------------------------------------------------
  vim.notify("No test runner defined for this file type.", vim.log.levels.WARN)
end, { silent = false })

-- C/C++
vim.keymap.set('n', '<Leader>cp', function()
  local project_root = vim.fn.getcwd()
  local build_dir = project_root .. "/build"
  if vim.fn.isdirectory(build_dir) == 0 then
    vim.fn.mkdir(build_dir, "p")
  end
  local detect_cmd = "cd " .. build_dir .. " && cmake .. && make && find . -maxdepth 1 -type f -executable ! -name '*.*' -printf '%T@ %p\\n' | sort -n | tail -1 | cut -d' ' -f2"
  local cmd = "cd " .. build_dir .. " && exe=$(" .. detect_cmd .. ") && echo Running $exe && $exe"
  local msg = "Building and auto-running latest executable"
  vim.cmd("belowright split | terminal echo '" .. msg .. "' && echo '' && " .. cmd)
  vim.cmd("stopinsert")
end, { silent = false })

vim.keymap.set('n', '<Leader>cc', function()
  local project_root = vim.fn.getcwd()
  local build_dir = project_root .. "/build/Release"
  if vim.fn.isdirectory(build_dir) == 0 then
    vim.fn.mkdir(build_dir, "p")
  end

  local cmd = table.concat({
    "cd " .. build_dir,
    "conan install ../.. --build=missing -of .",
    "cmake ../.. -DCMAKE_TOOLCHAIN_FILE=generators/conan_toolchain.cmake",
    "cmake --build .",
    "echo Running ./myapp",
    "./myapp"
  }, " && ")

  vim.cmd("belowright split | terminal " .. cmd)
  vim.cmd("stopinsert")
end, { silent = false })

-- vimtex
vim.keymap.set('n', '<leader>lv', '<cmd>VimtexView<CR>', { desc = 'View PDF in Zathura' })
vim.keymap.set('n', '<leader>lb', function()
  -- Bibtex build command
  vim.cmd('!bibtex main')
end, { desc = "bibtex main" })


-- Find and replace commands
local opts = {}
vim.api.nvim_set_keymap("v", "<C-r>", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-s>", "<CMD>SearchReplaceWithinVisualSelection<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-b>", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rs", "<CMD>SearchReplaceSingleBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ro", "<CMD>SearchReplaceSingleBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rw", "<CMD>SearchReplaceSingleBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>re", "<CMD>SearchReplaceSingleBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rf", "<CMD>SearchReplaceSingleBufferCFile<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", opts)

-- show the effects of a search / replace in a live preview window
vim.o.inccommand = "split"

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', '<Leader><Tab>', '<C-w>w')
vim.keymap.set('n', '<Leader>wc', ':w !wc -w<CR>') -- gets word count

-- quit window
vim.keymap.set('n', '<Leader>q', ':q <CR>', { noremap = true, silent = false })

-- Markdown files 
vim.keymap.set('n', '<Leader>mp', ':MarkdownPreview<CR>') -- % means current file
vim.keymap.set('n', '<Leader>ms', ':MarkdownPreviewStop<CR>') -- % means current file
vim.keymap.set('n', '<Leader>mt', ':MarkdownPreviewToggle<CR>') -- % means current file

-- Show diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Show diagnostics" })

-- Open a Terminal
vim.api.nvim_set_keymap('n', '<Leader>th', ':split | terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tv', ':vsplit | terminal<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tt', ':tabnew | terminal<CR>', { noremap = true, silent = true })

-- Close the Current Terminal or Window
vim.api.nvim_set_keymap('t', '<Leader>tc', '<C-\\><C-n>:q<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>tc', ':q<CR>', { noremap = true, silent = true })

-- Switch between Terminal and Normal Mode
vim.api.nvim_set_keymap('t', '<Leader>tn', '<C-\\><C-n>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>ti', 'i', { noremap = true, silent = true })

---- Autocommand to enter insert mode on terminal open
vim.cmd([[
  augroup Terminal
    autocmd!
    autocmd TermOpen * startinsert
  augroup END
]])
