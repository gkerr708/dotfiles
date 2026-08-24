-- lua/custom/sqlite_pick.lua
-- Pick a sqlite file with a fuzzy finder and open it, instead of typing a URL.
local M = {}

local EXTS = { "db", "sqlite", "sqlite3", "db3" }

-- Cheap magic-byte check so we don't hand a non-sqlite ".db" to dadbod.
local function is_sqlite(path)
  local f = io.open(path, "rb")
  if not f then return false end
  local head = f:read(15)
  f:close()
  return head == "SQLite format 3"
end

local function find_dbs(dir)
  if vim.fn.executable("fd") == 0 then
    local out = {}
    for _, e in ipairs(EXTS) do
      vim.list_extend(out, vim.fn.glob(dir .. "/**/*." .. e, false, true))
    end
    return out
  end
  local cmd = { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
  for _, e in ipairs(EXTS) do
    table.insert(cmd, "--extension")
    table.insert(cmd, e)
  end
  table.insert(cmd, ".")
  table.insert(cmd, dir)
  local res = vim.system(cmd, { text = true }):wait()
  return vim.split(res.stdout or "", "\n", { trimempty = true })
end

--- Pick a sqlite file under `dir` (default cwd) and pass it to `on_choice`.
function M.pick(dir, on_choice)
  dir = dir or vim.fn.getcwd()
  local files = vim.tbl_filter(is_sqlite, find_dbs(dir))
  if #files == 0 then
    vim.notify("No sqlite files found under " .. dir, vim.log.levels.WARN)
    return
  end
  vim.ui.select(files, {
    prompt = "sqlite file:",
    format_item = function(p) return vim.fn.fnamemodify(p, ":~:.") end,
  }, function(choice)
    if choice then on_choice(vim.fn.fnamemodify(choice, ":p")) end
  end)
end

--- Pick a db and open it in dadbod-ui as the current connection.
function M.open_dbui(dir)
  M.pick(dir, function(path)
    vim.g.db = "sqlite:" .. path
    vim.cmd("DBUI")
    vim.notify("db: " .. vim.fn.fnamemodify(path, ":~"))
  end)
end

--- Pick a db and open it in VisiData.
function M.open_visidata(dir)
  M.pick(dir, function(path)
    require("custom.visidata").open(path)
  end)
end

function M.setup()
  vim.keymap.set("n", "<leader>do", function() M.open_dbui() end,
    { desc = "Database: pick sqlite file -> DBUI" })
  vim.keymap.set("n", "<leader>ds", function() M.open_visidata() end,
    { desc = "Database: pick sqlite file -> VisiData" })

  vim.api.nvim_create_user_command("DBPick", function() M.open_dbui() end,
    { desc = "Pick a sqlite file and open it in DBUI" })
end

return M
