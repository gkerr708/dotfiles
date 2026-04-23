local M = {}

-- ======================
--  COLOR PALETTE
-- ======================
local p = {
    white     = "#ffffff",
    black     = "#000000",
    gray      = "#777777",
    cyan      = "#00d7ff",
    gold      = "#ffbf00",
    red       = "#ff1e00",
    yellow    = "#fff700",
    mint      = "#00ff9c",
    green     = "#00ff00",
    aqua      = "#00eaff",
    teal      = "#00ffcc",
    pink      = "#ff5faf",
    purple    = "#af00ff",
}

-- ======================
--  HIGHLIGHT GROUPS
-- ======================
M.highlights = {

    -- BASIC VIM GROUPS
    Normal       = { fg = p.white, bg = p.black },
    Comment      = { fg = p.gray, italic = true },

    Keyword      = { fg = p.pink, bold = true },
    Function     = { fg = p.gold, bold = true },
    Type         = { fg = p.gold, bold = true },

    String       = { fg = p.green},
    Number       = { fg = p.yellow },
    Boolean      = { fg = p.pink },

    -- TREESITTER
    ["@keyword"]       = { fg = p.red, bold = true },
    ["@function"]      = { fg = p.gold },
    ["@type"]          = { fg = p.gold },
    ["@string"]        = { fg = p.mint },
    ["@number"]        = { fg = p.yellow },
    ["@boolean"]       = { fg = p.pink },

    ["@property"]      = { fg = p.white},
    ["@field"]         = { fg = p.white},
    ["@variable"]      = { fg = p.white },

    -- LSP
    ["@lsp.type.property"] = { fg = p.white},
    ["@lsp.type.variable"] = { fg = p.white},
}

return M
