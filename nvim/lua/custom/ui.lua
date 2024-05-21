local function bool2str(bool) return bool and "on" or "off" end
local function ui_notify(silent, ...) return not silent and vim.notify(...) end
local function diagnostic(mode)
  if mode == 0 then
    return { signs = false, underline = false, update_in_insert = false, virtual_text = false }
  elseif mode == 1 then
    return { signs = false, underline = true, update_in_insert = true, virtual_text = false }
  elseif mode == 2 then
    return { signs = true, underline = true, update_in_insert = false, virtual_text = false }
  elseif mode == 3 then
    return { virtual_text = { prefix = "" }, signs = true, underline = true, update_in_insert = true }
  end
end

local M = {}

--- Toggle URL/URI syntax highlighting rules
---@param silent? boolean if true then don't sent a notification
function M.toggle_url_match(silent)
  vim.g.highlighturl_enabled = not vim.g.highlighturl_enabled
  matchURL()
  ui_notify(silent, string.format("URL highlighting %s", bool2str(vim.g.highlighturl_enabled)))
end

--- Toggle wrap
---@param silent? boolean if true then don't sent a notification
function M.toggle_wrap(silent)
  vim.wo.wrap = not vim.wo.wrap -- local to window
  ui_notify(silent, string.format("wrap %s", bool2str(vim.wo.wrap)))
end

--- Change the number display modes
---@param silent? boolean if true then don't sent a notification
function M.change_number(silent)
  local number = vim.wo.number                 -- local to window
  local relativenumber = vim.wo.relativenumber -- local to window
  if not number and not relativenumber then
    vim.wo.number = true
  elseif number and not relativenumber then
    vim.wo.relativenumber = true
  elseif number and relativenumber then
    vim.wo.number = false
  else -- not number and relativenumber
    vim.wo.relativenumber = false
  end
  ui_notify(
    silent,
    string.format("number %s, relativenumber %s", bool2str(vim.wo.number), bool2str(vim.wo.relativenumber))
  )
end

--- Set the indent and tab related numbers
---@param silent? boolean if true then don't sent a notification
function M.set_indent(silent)
  local input_avail, input = pcall(vim.fn.input, "Set indent value (>0 expandtab, <=0 noexpandtab): ")
  if input_avail then
    local indent = tonumber(input)
    if not indent or indent == 0 then return end
    vim.bo.expandtab = (indent > 0) -- local to buffer
    indent = math.abs(indent)
    vim.bo.tabstop = indent         -- local to buffer
    vim.bo.softtabstop = indent     -- local to buffer
    vim.bo.shiftwidth = indent      -- local to buffer
    ui_notify(silent, string.format("indent=%d %s", indent, vim.bo.expandtab and "expandtab" or "noexpandtab"))
  end
end

--- Toggle autopairs
---@param silent? boolean if true then don't sent a notification
function M.toggle_autopairs(silent)
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if ok then
    if autopairs.state.disabled then
      autopairs.enable()
    else
      autopairs.disable()
    end
    vim.g.autopairs_enabled = autopairs.state.disabled
    ui_notify(silent, string.format("autopairs %s", bool2str(not autopairs.state.disabled)))
  else
    ui_notify(silent, "autopairs not available")
  end
end

--- Toggle buffer semantic token highlighting for all language servers that support it
---@param bufnr? number the buffer to toggle the clients on
---@param silent? boolean if true then don't sent a notification
function M.toggle_buffer_semantic_tokens(bufnr, silent)
  bufnr = bufnr or 0
  vim.b[bufnr].semantic_tokens_enabled = not vim.b[bufnr].semantic_tokens_enabled
  local toggled = false
  for _, client in ipairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
    if client.server_capabilities.semanticTokensProvider then
      vim.lsp.semantic_tokens[vim.b[bufnr].semantic_tokens_enabled and "start" or "stop"](bufnr, client.id)
      toggled = true
    end
  end
  ui_notify(
    not toggled or silent,
    string.format("Buffer lsp semantic highlighting %s", bool2str(vim.b[bufnr].semantic_tokens_enabled))
  )
end

--- Toggle syntax highlighting and treesitter
---@param bufnr? number the buffer to toggle syntax on
---@param silent? boolean if true then don't sent a notification
function M.toggle_buffer_syntax(bufnr, silent)
  -- HACK: this should just be `bufnr = bufnr or 0` but it looks like `vim.treesitter.stop` has a bug with `0` being current
  bufnr = (bufnr and bufnr ~= 0) and bufnr or vim.api.nvim_win_get_buf(0)
  local ts_avail, parsers = pcall(require, "nvim-treesitter.parsers")
  if vim.bo[bufnr].syntax == "off" then
    if ts_avail and parsers.has_parser() then vim.treesitter.start(bufnr) end
    vim.bo[bufnr].syntax = "on"
    if not vim.b[bufnr].semantic_tokens_enabled then M.toggle_buffer_semantic_tokens(bufnr, true) end
  else
    if ts_avail and parsers.has_parser() then vim.treesitter.stop(bufnr) end
    vim.bo[bufnr].syntax = "off"
    if vim.b[bufnr].semantic_tokens_enabled then M.toggle_buffer_semantic_tokens(bufnr, true) end
  end
  ui_notify(silent, string.format("syntax highlighting %s", vim.bo[bufnr].syntax))
end

--- Toggle diagnostics
---@param silent? boolean if true then don't sent a notification
function M.change_diagnostic_mode(silent)
  local tb = {
    ["0"] = extend_tbl(vim.g.diagnostic_mode, diagnostic(0)),
    ["1"] = extend_tbl(vim.g.diagnostic_mode, diagnostic(1)),
    ["2"] = extend_tbl(vim.g.diagnostic_mode, diagnostic(2)),
    ["3"] = extend_tbl(vim.g.diagnostic_mode, diagnostic(3)),
  }
  vim.g.diagnostic_mode_num = (vim.g.diagnostic_mode_num + 1) % 4
  vim.diagnostic.config(tb[tostring(vim.g.diagnostic_mode_num)])
  if vim.g.diagnostic_mode_num == 0 then
    ui_notify(silent, "all diagnostics off")
  elseif vim.g.diagnostic_mode_num == 1 then
    ui_notify(silent, "only status diagnostics")
  elseif vim.g.diagnostic_mode_num == 2 then
    ui_notify(silent, "virtual text off")
  else
    ui_notify(silent, "all diagnostics on")
  end
end

--- Toggle barbecue
---@param silent? boolean if true then don't send a notification
function M.toggle_context_bar(silent)
  if vim.g.toggle_barbecue then
    vim.cmd [[lua require "barbecue.ui".toggle(false)]]
  else
    vim.cmd [[lua require "barbecue.ui".toggle(true)]]
  end
  vim.g.toggle_barbecue = not vim.g.toggle_barbecue
end

return M
