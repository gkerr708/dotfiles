-- Purpose: Buffer-local keymaps and LSP niceties that run when a server attaches.
-- Notes:
--   • Keep ONLY LSP buffer-scoped behavior here (keymaps, highlights, inlay toggles).
--   • This is referenced from plugins/lsp.lua via server.on_attach = on_attach.

local M = {}

-- Safe, optional use of Telescope pickers if present
local ok_tb, tb = pcall(require, 'telescope.builtin')

-- Helper: feature check that works on 0.10 and 0.11
local function client_supports_method(client, method, bufnr)
  if vim.fn.has('nvim-0.11') == 1 then
    return client:supports_method(method, bufnr)
  else
    return client.supports_method(client, method, { bufnr = bufnr })
  end
end

M.on_attach = function(client, bufnr)
  -- Convenience mapper that tags descriptions as 'LSP: ...'
  local function nmap(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc and ('LSP: ' .. desc) or nil })
  end

  ---------------------------------------------------------------------------
  -- Core navigation / actions (Telescope variants if available)
  ---------------------------------------------------------------------------
  --if ok_tb then
  --  nmap('grd', tb.lsp_definitions,               '[G]oto [D]efinition (Telescope)')
  --  nmap('grr', tb.lsp_references,                '[G]oto [R]eferences (Telescope)')
  --  nmap('gri', tb.lsp_implementations,           '[G]oto [I]mplementation (Telescope)')
  --  nmap('gO',  tb.lsp_document_symbols,          'Open Document Symbols')
  --  nmap('gW',  tb.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
  --  nmap('grt', tb.lsp_type_definitions,          '[G]oto [T]ype Definition')
  --end
  -- helper: fix 0.10 branch
  local function client_supports_method(client, method, bufnr)
    if vim.fn.has('nvim-0.11') == 1 then
      return client:supports_method(method, bufnr)
    else
      return client.supports_method and client.supports_method(method)
    end
  end

  -- jump to first implementation (fallbacks optional)
  local function goto_impl()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, 'textDocument/implementation', params, function(err, res)
      if err then vim.notify(err.message, vim.log.levels.ERROR); return end
      if not res or vim.tbl_isempty(res) then
        vim.notify('No implementation found', vim.log.levels.WARN); return
      end
      local loc = vim.tbl_islist(res) and res[1] or res
      vim.lsp.util.jump_to_location(loc, 'utf-16')
    end)
  end
  
  -- in M.on_attach(client, bufnr):
  vim.keymap.set('n', 'gI', goto_impl, { buffer = bufnr, desc = 'LSP: Goto Implementation', silent = true, nowait = true })
  -- (optional) also map 'gi' if you really want it:
  -- vim.keymap.set('n', 'gi', goto_impl, { buffer = bufnr, desc = 'LSP: Goto Implementation', silent = true, nowait = true })


  nmap('gd',  vim.lsp.buf.definition,           '[G]oto [D]efinition')
  nmap('gr',  vim.lsp.buf.references,           '[G]oto [R]eferences')
  --nmap('gi',  vim.lsp.buf.implementation,       '[G]oto [I]mplementation')
  nmap('grD', vim.lsp.buf.declaration,            '[G]oto [D]eclaration')
  nmap('grn', vim.lsp.buf.rename,                 '[R]e[n]ame')
  nmap('gra', vim.lsp.buf.code_action,            '[G]oto Code [A]ction')
  nmap('K',   vim.lsp.buf.hover,                  'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help,       'Signature Help')

  ---------------------------------------------------------------------------
  -- Optional: highlight symbol references on cursor hold, clear on move
  ---------------------------------------------------------------------------
  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
    local grp = vim.api.nvim_create_augroup('lsp-highlight-' .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      group = grp, buffer = bufnr, callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'BufLeave' }, {
      group = grp, buffer = bufnr, callback = vim.lsp.buf.clear_references,
    })
  end

  ---------------------------------------------------------------------------
  -- Optional: toggle inlay hints if server supports them
  ---------------------------------------------------------------------------
  if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, bufnr) then
    nmap('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
    end, '[T]oggle Inlay [H]ints')
  end

  -- You can add format-on-save here if desired; omitted for explicit control.
  -- Example (uncomment to enable for servers that support formatting):
  -- vim.api.nvim_create_autocmd('BufWritePre', {
  --   buffer = bufnr,
  --   callback = function() vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 }) end,
  -- })
end

return M
