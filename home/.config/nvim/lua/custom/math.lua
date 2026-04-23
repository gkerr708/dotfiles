-- lua/custom/math.lua
local M = {}

function M.setup()
  -- grab inclusive selection
  local function get_visual_inclusive()
    vim.cmd("normal! <Esc>")
    local srow, scol = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local erow, ecol = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    if erow < srow or (erow == srow and ecol < scol) then
      srow, erow, scol, ecol = erow, srow, ecol, scol
    end
    local start_row, start_col = srow - 1, scol
    local end_row,   end_col   = erow - 1, ecol + 1
    local last = vim.api.nvim_buf_get_lines(0, end_row, end_row + 1, false)[1] or ""
    if end_col > #last then end_col = #last end
    local chunks = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
    return table.concat(chunks, "\n"), erow
  end

  -- evaluate math (tiny Lua parser for + - * / ^ ( ))
  local function eval_expr(expr)
    local f, err = load("return " .. expr:gsub("%^","^"))
    if not f then error("bad expr: " .. err) end
    return f()
  end

  local function paste_below_result()
    local sel, erow = get_visual_inclusive()
    if sel == "" then return end
    local ok, res = pcall(eval_expr, sel)
    if not ok then res = "ERROR" end
    -- Always append one line below the end of selection
    vim.api.nvim_buf_set_lines(0, erow, erow, false, { tostring(res) })
  end

  vim.keymap.set("v", "<leader>ls", function()
    vim.cmd("normal! <Esc>")
    vim.schedule(paste_below_result)
  end, { desc = "Eval selection → new line", silent = true })
end

return M
