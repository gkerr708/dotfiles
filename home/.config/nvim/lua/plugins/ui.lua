return{
  'nvim-tree/nvim-web-devicons',

  --{ 
  --  "ellisonleao/gruvbox.nvim", 
  --  priority = 1000,
  --  config = function()
  --    -- Default options:
  --    require("gruvbox").setup({
  --      terminal_colors = true, -- add neovim terminal colors
  --      undercurl = true,
  --      underline = true,
  --      bold = true,
  --      italic = {
  --        strings = true,
  --        emphasis = true,
  --        comments = true,
  --        operators = false,
  --        folds = true,
  --      },
  --      strikethrough = true,
  --      invert_selection = false,
  --      invert_signs = false,
  --      invert_tabline = false,
  --      inverse = true, -- invert background for search, diffs, statuslines and errors
  --      contrast = "hard", -- can be "hard", "soft" or empty string
  --      palette_overrides = {},
  --      overrides = {},
  --      dim_inactive = false,
  --      transparent_mode = false,
  --    })
  --    vim.cmd("colorscheme gruvbox")
  --  end,
  --},

  --{
  --  "EdenEast/nightfox.nvim",
  --  config = function()
  --    -- Default options
  --    require('nightfox').setup({
  --      options = {
  --        -- Compiled file's destination location
  --        compile_path = vim.fn.stdpath("cache") .. "/nightfox",
  --        compile_file_suffix = "_compiled", -- Compiled file suffix
  --        transparent = true,     -- Disable setting background
  --        terminal_colors = true,  -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
  --        dim_inactive = false,    -- Non focused panes set to alternative background
  --        module_default = true,   -- Default enable value for modules
  --        colorblind = {
  --          enable = false,        -- Enable colorblind support
  --          simulate_only = false, -- Only show simulated colorblind colors and not diff shifted
  --          severity = {
  --            protan = 0,          -- Severity [0,1] for protan (red)
  --            deutan = 0,          -- Severity [0,1] for deutan (green)
  --            tritan = 0,          -- Severity [0,1] for tritan (blue)
  --          },
  --        },
  --        styles = {               -- Style to be applied to different syntax groups
  --          comments = "NONE",     -- Value is any valid attr-list value `:help attr-list`
  --          conditionals = "NONE",
  --          constants = "NONE",
  --          functions = "NONE",
  --          keywords = "NONE",
  --          numbers = "NONE",
  --          operators = "NONE",
  --          strings = "NONE",
  --          types = "NONE",
  --          variables = "NONE",
  --        },
  --        inverse = {             -- Inverse highlight for different types
  --          match_paren = false,
  --          visual = false,
  --          search = false,
  --        },
  --        modules = {             -- List of various plugins and additional options
  --          -- ...
  --        },
  --      },
  --      -- Palettes are the base color defines of a colorscheme.
  --      palettes = {
  --        -- Everything defined under `all` will be applied to each style.
  --        all = {
  --          -- Each palette defines these colors:
  --          --   black, red, green, yellow, blue, magenta, cyan, white, orange, pink
  --          --
  --          -- These colors have 3 shades: base, bright, and dim
  --          --
  --          -- Defining just a color defines it's base color
  --          red = "#ff0000",
  --        },
  --        nightfox = {
  --          -- A specific style's value will be used over the `all`'s value
  --          red = "#c94f6d",
  --        },
  --        dayfox = {
  --          -- Defining multiple shades is done by passing a table
  --          blue = { base = "#4d688e", bright = "#4e75aa", dim = "#485e7d" },
  --        },
  --        nordfox = {
  --          -- A palette also defines the following:
  --          --   bg0, bg1, bg2, bg3, bg4, fg0, fg1, fg2, fg3, sel0, sel1, comment
  --          --
  --          -- These are the different foreground and background shades used by the theme.
  --          -- The base bg and fg is 1, 0 is normally the dark alternative. The others are
  --          -- incrementally lighter versions.
  --          bg1 = "#2e3440",
  --      
  --          -- sel is different types of selection colors.
  --          sel0 = "#3e4a5b", -- Popup bg, visual selection bg
  --          sel1 = "#4f6074", -- Popup sel bg, search bg
  --      
  --          -- comment is the definition of the comment color.
  --          comment = "#60728a",
  --        },
  --      },
  --      
  --      -- Spec's (specifications) are a mapping of palettes to logical groups that will be
  --      -- used by the groups. Some examples of the groups that specs map would be:
  --      --   - syntax groups (functions, types, keywords, ...)
  --      --   - diagnostic groups (error, warning, info, hints)
  --      --   - git groups (add, removed, changed)
  --      --
  --      -- You can override these just like palettes
  --      specs = {
  --        -- As with palettes, the values defined under `all` will be applied to every style.
  --        all = {
  --          syntax = {
  --            -- Specs allow you to define a value using either a color or template. If the string does
  --            -- start with `#` the string will be used as the path of the palette table. Defining just
  --            -- a color uses the base version of that color.
  --            keyword = "magenta",
  --      
  --            -- Adding either `.bright` or `.dim` will change the value
  --            conditional = "magenta.bright",
  --            number = "orange.dim",
  --          },
  --          git = {
  --            -- A color define can also be used
  --            changed = "#f4a261",
  --          },
  --        },
  --        nightfox = {
  --          syntax = {
  --            -- As with palettes, a specific style's value will be used over the `all`'s value.
  --            operator = "orange",
  --          },
  --        },
  --      },
  --      
  --      -- Groups are the highlight group definitions. The keys of this table are the name of the highlight
  --      -- groups that will be overridden. The value is a table with the following values:
  --      --   - fg, bg, style, sp, link,
  --      --
  --      -- Just like `spec` groups support templates. This time the template is based on a spec object.
  --      groups = {
  --        all = {
  --          Whitespace = { link = "Comment" },
  --          IncSearch  = { bg = "palette.cyan" },
  --        },
  --      
  --        nightfox = {
  --          PmenuSel = { bg = "#5df6ff", fg = "bg0" },             -- idk
  --          Comment      = { fg = "#999999", style = "italic" },   -- comments (medium gray)
  --          Keyword      = { fg = "#ffaf5f", style = "bold" },     -- keywords (light orange)
  --          Conditional  = { fg = "#fbff00", style = "bold" },     -- if/else (bright yellow)
  --          Repeat       = { fg = "#ffaf5f", style = "bold" },     -- loops (light orange)
  --          Operator     = { fg = "#87d7ff" },                     -- operators (soft cyan)
  --          Identifier   = { fg = "#5fd7af" },                     -- variable names (seafoam green)
  --          Function     = { fg = "#ffd787", style = "bold" },     -- function names (warm yellow)
  --          Type         = { fg = "#ffcd73", style = "bold" },     -- types (goldenrod)
  --          String       = { fg = "#9aff87" },                     -- strings (bright lime green)
  --          Number       = { fg = "#ffffff", style = "bold" },     -- numbers (amber)
  --          Boolean      = { fg = "#ff875f", style = "bold" },     -- booleans (burnt orange)
  --          Normal       = { fg = "#ffffff", bg = "NONE" },        -- normal text (white)
  --          NormalNC     = { fg = "#cfcfcf", bg = "NONE" },        -- inactive window text (soft gray)
  --          CursorLine   = { bg = "#262626" },                     -- current line (charcoal black)
  --          CursorLineNr = { fg = "#87d7ff", style = "bold" },     -- current line number (soft cyan)
  --          LineNr       = { fg = "#6c6c6c" },                     -- line numbers (dark gray)
  --          Visual       = { bg = "#3a3a3a" },                     -- selection (graphite)
  --          Search       = { bg = "#ffd75f", fg = "#1a1a1a", style = "bold" }, -- search highlight (amber)
  --          DiagnosticError   = { fg = "#ff4d4d" },                -- LSP errors (bright red)
  --          DiagnosticWarn    = { fg = "#ffcc33" },                -- LSP warnings (yellow gold)
  --          DiagnosticInfo    = { fg = "#4dccff" },                -- LSP info (sky blue)
  --          DiagnosticHint    = { fg = "#7aff7a" },                -- LSP hints (mint green)
  --          GitSignsAdd       = { fg = "#7aff7a" },                -- git added (mint green)
  --          GitSignsChange    = { fg = "#ffd966" },                -- git modified (pale yellow)
  --          GitSignsDelete    = { fg = "#ff6666" },                -- git deleted (soft red)
  --        },
  --      },
  --    })
  --    -- setup must be called before loading
  --    vim.cmd("colorscheme nightfox")
  --  end,
  --},


  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",   -- latte | frappe | macchiato | mocha
        transparent_background = false,
        integrations = {
          lualine = true,
          nvimtree = false,
          telescope = true,
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  --{
  --  'folke/tokyonight.nvim',
  --  priority = 1000,
  --  config = function()
  --    require('tokyonight').setup({
  --      style = 'night',       -- 'storm' | 'night' | 'moon' | 'day'

  --      integrations = {
  --        lualine = true,
  --        nvimtree = false,
  --        telescope = true,
  --      },

  --      transparent = true,
  --      styles = {
  --        sidebars = 'transparent',
  --        floats = 'transparent',
  --      },
  --    })
  --    vim.cmd.colorscheme('tokyonight')
  --  end,
  --},
  --{
  --  'navarasu/onedark.nvim',
  --  priority = 1000,
  --  config = function()
  --    require('onedark').setup {
  --      transparent = true,
  --    }
  --    require('onedark').load()
  --  end,
  --},
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          --theme = 'iceberg_dark',
          --theme = "catppuccin",
          component_separators = { left = '', right = ''},
          section_separators = { left = '', right = ''},
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          always_show_tabline = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
            refresh_time = 16, -- ~60fps
            events = {
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'SessionLoadPost',
              'FileChangedShellPost',
              'VimResized',
              'Filetype',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
            },
          }
        },
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end,
  },
}
