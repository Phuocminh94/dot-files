-- refer to this for a full list of language sever names
-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md

local configs = require("plugins.configs.lspconfig")
local on_attach = configs.on_attach
local capabilities = configs.capabilities

local lspconfig = require "lspconfig"

for _, server in ipairs(vim.g.mason_binaries_list) do
  local opts = { on_attach = on_attach, capabilities = capabilities }
  local require_ok, settings = pcall(require, "custom.configs.lspsettings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", settings, opts)
  end

  lspconfig[server].setup(opts)
end

-- NOTE: update node/npm to use typescript-language-server 
