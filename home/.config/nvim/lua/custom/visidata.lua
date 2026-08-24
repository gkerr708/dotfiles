-- lua/custom/visidata.lua
-- Open files (csv/tsv/json/parquet/sqlite/...) in VisiData in a floating terminal.
local M = {}

local function open_float(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.92)
  local height = math.floor(vim.o.lines * 0.88)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " visidata ",
    title_pos = "center",
  })
  vim.wo[win].winhl = "Normal:Normal,FloatBorder:FloatBorder"

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
      -- Reload in case visidata saved changes to the file
      vim.cmd("silent! checktime")
    end,
  })
  vim.cmd("startinsert")
end

--- Open `path` in visidata. With no path, uses the current buffer's file.
function M.open(path)
  if not path or path == "" then
    path = vim.api.nvim_buf_get_name(0)
  end
  if path == "" then
    vim.notify("visidata: no file for this buffer", vim.log.levels.WARN)
    return
  end
  if vim.fn.filereadable(path) == 0 then
    vim.notify("visidata: not readable: " .. path, vim.log.levels.ERROR)
    return
  end
  open_float({ "vd", path })
end

--- Open visidata's directory browser at `dir` (default: cwd).
function M.open_dir(dir)
  open_float({ "vd", dir or vim.fn.getcwd() })
end

function M.setup()
  if vim.fn.executable("vd") == 0 then
    return
  end

  vim.api.nvim_create_user_command("Visidata", function(o)
    M.open(o.args ~= "" and vim.fn.expand(o.args) or nil)
  end, { nargs = "?", complete = "file", desc = "Open a file in VisiData" })

  vim.keymap.set("n", "<leader>dv", function() M.open() end,
    { desc = "VisiData: current file" })
  vim.keymap.set("n", "<leader>dV", function() M.open_dir() end,
    { desc = "VisiData: browse cwd" })
  vim.keymap.set("n", "<leader>dp", function()
    vim.ui.input({ prompt = "VisiData file: ", completion = "file" }, function(input)
      if input and input ~= "" then M.open(vim.fn.expand(input)) end
    end)
  end, { desc = "VisiData: prompt for file" })

  -- <Esc><Esc> leaves terminal-insert so you can scroll/close the float
  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(args)
      if vim.b[args.buf].visidata_mapped then return end
      vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]], { buffer = args.buf })
      vim.b[args.buf].visidata_mapped = true
    end,
  })
end

return M
