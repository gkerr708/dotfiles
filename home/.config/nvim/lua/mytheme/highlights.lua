local M = {}

-- ======================
--  COLOR PALETTE
-- ======================
-- Rosé Pine palette (black background)
local p = {
    white     = "#e0def4", -- text
    black     = "#000000", -- base
    gray      = "#6e6a86", -- muted
    cyan      = "#9ccfd8", -- foam
    gold      = "#f6c177", -- gold
    red       = "#eb6f92", -- love
    yellow    = "#f6c177", -- gold
    mint      = "#9ccfd8", -- foam
    green     = "#31748f", -- pine
    aqua      = "#9ccfd8", -- foam
    teal      = "#31748f", -- pine
    pink      = "#c4a7e7", -- iris
    purple    = "#c4a7e7", -- iris
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
