return {
  {
    -- Core LSP client integration for Neovim
    'neovim/nvim-lspconfig',

    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },

    config = function()
      ---------------------------------------------------------------------------
      -- 1) Diagnostics: severity sorting, visuals, floating borders
      ---------------------------------------------------------------------------
      vim.diagnostic.config({
        severity_sort = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN ] = '󰀪 ',
            [vim.diagnostic.severity.INFO ] = '󰋽 ',
            [vim.diagnostic.severity.HINT ] = '󰌶 ',
          },
        } or {},
        virtual_text = { source = 'if_many', spacing = 2, format = function(d) return d.message end },
        float = { border = 'rounded', source = 'if_many' },
      })
      vim.o.winborder = 'rounded'

      ---------------------------------------------------------------------------
      -- 2) Capabilities (via blink.cmp) + unify position encodings
      ---------------------------------------------------------------------------
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { 'utf-16' }
      capabilities.offsetEncoding = { 'utf-16' }

      ---------------------------------------------------------------------------
      -- 3) Inline on_attach (buffer-local LSP behavior only)
      ---------------------------------------------------------------------------
      local function already(bufnr)
        local ok, val = pcall(vim.api.nvim_buf_get_var, bufnr, 'user_lsp_on_attach_done')
        return ok and val
      end
      local function mark(bufnr)
        pcall(vim.api.nvim_buf_set_var, bufnr, 'user_lsp_on_attach_done', true)
      end

      local function on_attach(client, bufnr)
        if already(bufnr) then return end
        mark(bufnr)

        local function nmap(lhs, rhs, desc)
          vim.keymap.set('n', lhs, rhs, { buffer = bufnr, silent = true, nowait = true, desc = desc and ('LSP: ' .. desc) or nil })
        end

        -- Jumps (prefer gI; `gi` is Vim's "go to last insert")
        nmap('gd',  vim.lsp.buf.definition,        '[G]oto [D]efinition')
        nmap('gr',  vim.lsp.buf.references,        '[G]oto [R]eferences')
        nmap('gI',  vim.lsp.buf.implementation,    '[G]oto [I]mplementation')
        nmap('K',   vim.lsp.buf.hover,             'Hover')
        nmap('<C-k>', vim.lsp.buf.signature_help,  'Signature Help')

        -- Symbol highlights (if supported)
        if client and client:supports_method('textDocument/documentHighlight') then
          local grp = vim.api.nvim_create_augroup('lsp-highlight-' .. bufnr, { clear = true })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { group = grp, buffer = bufnr, callback = vim.lsp.buf.document_highlight })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, { group = grp, buffer = bufnr, callback = vim.lsp.buf.clear_references })
        end

        -- Inlay hints toggle (NVIM ≥0.10)
        if vim.lsp.inlay_hint and client and client:supports_method('textDocument/inlayHint') then
          nmap('<leader>th', function()
            local en = vim.lsp.inlay_hint.is_enabled and vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
            vim.lsp.inlay_hint.enable(not en, { bufnr = bufnr })
          end, '[T]oggle Inlay [H]ints')
        end
      end

      -- Safety-net: ensure on_attach runs for ANY client that attaches
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-on_attach', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          on_attach(client, args.buf)
        end,
      })

      ---------------------------------------------------------------------------
      -- 4) Servers to enable
      ---------------------------------------------------------------------------
      local servers = {
        pyright = {},
        ruff = {},
        rust_analyzer = {},
        lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' } } } },
      }

      ---------------------------------------------------------------------------
      -- 5) Ensure tools via Mason Tool Installer
      ---------------------------------------------------------------------------
      local ensure = vim.tbl_keys(servers)
      vim.list_extend(ensure, { 'stylua', 'ruff' })
      require('mason-tool-installer').setup({ ensure_installed = ensure })

      ---------------------------------------------------------------------------
      -- 6) Setup servers (mason-lspconfig handler)
      ---------------------------------------------------------------------------
      require('mason-lspconfig').setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            server.on_attach = on_attach
            require('lspconfig')[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
