dofile(vim.g.base46_cache .. "lsp")
require("nvchad.lsp")

local M = {}
local utils = require("core.utils")

-- overwrite symbols and diagnostics
local function lspSymbol(name, icon)
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
end

lspSymbol("Error", "󰅚")
lspSymbol("Info", "")
lspSymbol("Hint", "󰛩")
lspSymbol("Warn", "")

vim.diagnostic.config(vim.tbl_deep_extend("force", vim.g.diagnostic_mode, { float = { source = "always" } }))

-- highlight symbols under cursor
M.highlight_symbols = function(client)
  local ok, highlight_supported = pcall(function()
    return client.supports_method("textDocument/documentHighlight")
  end)

  if not ok or not highlight_supported then
    return
  else
    vim.api.nvim_exec(
      [[
              augroup lsp_document_highlight
              autocmd! * <buffer>
              autocmd CursorHold <buffer> silent! lua vim.lsp.buf.document_highlight()
              autocmd CursorHoldI <buffer> silent! lua vim.lsp.buf.document_highlight()
              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
              augroup END
      ]],
      false
    )
  end
end

-- export on_attach & capabilities for custom lspconfigs
M.on_attach = function(client, bufnr)
  -- highlight symbol undercursor
  M.highlight_symbols(client)

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

require("lspconfig").lua_ls.setup({
  on_attach = M.on_attach,
  capabilities = M.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      hint = { -- inlay_hints neovim >= 0.10.0
        enable = true,
      },
      workspace = {
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          [vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

return M
