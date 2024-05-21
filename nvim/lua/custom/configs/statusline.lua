local M = {}
local fn = vim.fn

local function is_activewin()
  return vim.api.nvim_get_current_win() == vim.g.statusline_winid
end

local function stbufnr()
  return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

M.modes = {
  ["n"] = "NORMAL",
  ["no"] = "NORMAL (no)",
  ["nov"] = "NORMAL (nov)",
  ["noV"] = "NORMAL (noV)",
  ["noCTRL-V"] = "NORMAL",
  ["niI"] = "NORMAL i",
  ["niR"] = "NORMAL r",
  ["niV"] = "NORMAL v",
  ["nt"] = "NTERMINAL",
  ["ntT"] = "NTERMINAL (ntT)",

  ["v"] = "VISUAL",
  ["vs"] = "V-CHAR (Ctrl O)",
  ["V"] = "V-LINE",
  ["Vs"] = "V-LINE",
  [""] = "V-BLOCK",

  ["i"] = "INSERT",
  ["ic"] = "INSERT (completion)",
  ["ix"] = "INSERT completion",

  ["t"] = "TERMINAL",

  ["R"] = "REPLACE",
  ["Rc"] = "REPLACE (Rc)",
  ["Rx"] = "REPLACEa (Rx)",
  ["Rv"] = "V-REPLACE",
  ["Rvc"] = "V-REPLACE (Rvc)",
  ["Rvx"] = "V-REPLACE (Rvx)",

  ["s"] = "SELECT",
  ["S"] = "S-LINE",
  [""] = "S-BLOCK",
  ["c"] = "COMMAND",
  ["cv"] = "COMMAND",
  ["ce"] = "COMMAND",
  ["r"] = "PROMPT",
  ["rm"] = "MORE",
  ["r?"] = "CONFIRM",
  ["x"] = "CONFIRM",
  ["!"] = "SHELL",
}

M.mode = function()
  if not is_activewin() then
    return ""
  end

  local m = vim.api.nvim_get_mode().mode
  return "%#St_Mode#" .. string.format("  %s ", M.modes[m])
end

M.others = function()
  -- high to low priority: lsp, search count, recording
  local has_lsp = vim.lsp.status()[1]
  local has_search = vim.v.hlsearch == 1
  local has_rec = vim.fn.reg_recording() ~= ""
  local search_stat = nil

  if vim.v.hlsearch ~= 0 then
    local sinfo = vim.fn.searchcount { maxcount = 0 }
    if not (sinfo.incomplete == nil or sinfo.total == nil) then -- would throw errors in lazy installing new plugin without this line.
      search_stat = sinfo.incomplete > 0 and "🔍 [?/?]"
          or sinfo.total > 0 and ("🔍 [%s/%s]"):format(sinfo.current, sinfo.total)
          or nil
    end
  end

  local show_rec = not has_lsp and has_rec                       -- hide rec if lsp or search
  local show_search = not has_lsp and has_search and search_stat -- hide search if lsp
  local register = show_rec and " " .. "@" .. vim.fn.reg_recording() or ""
  return show_search and search_stat or register
end

M.tabWidth = function()
  local tab = vim.api.nvim_buf_get_option(0, "shiftwidth")
  local condition = vim.bo.filetype ~= "NvimTree" and vim.o.columns > 140
  local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
  local add_bar = #buf_clients == 0 and "| " or ""

  return condition --[[ "󰌒 :" ]]
      and add_bar .. " :" --[[ " :" ]]
      .. tab
      .. " "
      or ""
end

M.LSP_Diagnostics = function()
  if not rawget(vim, "lsp") then
    return ""
  end

  local errors = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.HINT })
  local info = #vim.diagnostic.get(stbufnr(), { severity = vim.diagnostic.severity.INFO })

  errors = (errors and errors > 0) and ("󰅚 " .. errors .. " ") or ""
  warnings = (warnings and warnings > 0) and (" " .. warnings .. " ") or ""
  hints = (hints and hints > 0) and ("󰛩 " .. hints .. " ") or ""
  info = (info and info > 0) and (" " .. info .. " ") or ""

  return (vim.o.columns > 140 and vim.g.diagnostic_mode_num > 0) and errors .. warnings .. hints .. info or ""
end

M.fileInfo = function()
  local icon = "󰈚 "
  local path = vim.api.nvim_buf_get_name(stbufnr())
  local name = (path == "" and "Empty ") or path:match "([^/\\]+)[/\\]*$"

  if name ~= "Empty " then
    local devicons_present, devicons = pcall(require, "nvim-web-devicons")

    if devicons_present then
      local ft_icon = devicons.get_icon(name)
      icon = (ft_icon ~= nil and ft_icon) or icon
    end

    local is_readonly = (not vim.bo.modifiable or vim.bo.readonly) and " " or ""
    name = " " .. vim.bo.ft .. is_readonly .. " "
  end

  return "%#StText# " .. " " .. icon .. name
end

M.cwd = function()
  -- check if git
  has_git = vim.b[stbufnr()].gitsigns_head or vim.b[stbufnr()].gitsigns_git_status

  -- trim dir
  local max_dirname = 7
  local function trim_dirname(dirname, max_length)
    local max_length = max_length or max_dirname
    if #dirname <= max_length then
      return dirname
    else
      local trim_notation = "..."
      local extension = dirname:match "%.[^%.]+$" or ""
      local basename = dirname:sub(1, max_length - #trim_notation - #extension)
      return basename .. trim_notation .. extension
    end
  end

  -- icon
  icon = has_git and "%#St_Mode#  " or "%#St_Mode#  "
  local dir_name = --[[ "%#St_Mode# 󰉖 " ]]
      icon .. trim_dirname(fn.fnamemodify(fn.getcwd(), ":t")) .. " "
  return dir_name
end

M.LSP_status = function()
  local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
  local buf_client_names = {}
  local has_copilot = false
  local condition = vim.bo.filetype ~= "nvdash" and vim.o.columns > 85

  -- check if treesitter is valid + toggled on
  local treesitter_available = function(bufnr)
    if not package.loaded["nvim-treesitter"] then
      return false
    end
    if type(bufnr) == "table" then
      bufnr = bufnr.bufnr
    end
    local ok, parsers = pcall(require, "nvim-treesitter.parsers")
    return ok and parsers.has_parser(parsers.get_buf_lang(bufnr or vim.api.nvim_get_current_buf())) or nil
  end

  -- local TS = (treesitter_available(0) and (vim.bo[0].syntax == "" or vim.bo[0].syntax == "on")) and "🌳" or nil
  local TS = (treesitter_available(0) and (vim.bo[0].syntax == "" or vim.bo[0].syntax == "on")) and "✨" or nil

  -- has at least one client or treesitter available
  if #buf_clients == 0 and #buf_client_names == 0 then
    return "LSP Inactive "
  end

  if rawget(vim, "lsp") then
    for _, client in ipairs(buf_clients) do
      if client.name ~= "null-ls" and client.name ~= "copilot" then
        table.insert(buf_client_names, client.name)
        table.sort(buf_client_names)
      end

      if client.name == "copilot" then
        has_copilot = true
      end
    end
  end

  local copilot = (has_copilot and " ") or "" --[[ " " ]]
  if has_copilot then
    table.insert(buf_client_names, 1, copilot)
  end

  -- add formatter & linter
  local list_registered_providers_names = function()
    return {}
  end -- assign nil cause error
  local list_registered = function()
    return {}
  end
  local FORMATTER = {}
  local LINTER = {}
  if vim.g.loadedFormatter and vim.g.loadedLinter then
    local null_ls = require "null-ls"
    FORMATTER = null_ls.methods.FORMATTING
    LINTER = null_ls.methods.DIAGNOSTICS
    list_registered_providers_names = function(filetype)
      local ok, s = pcall(require, "null-ls.sources")
      if not ok then
        return ""
      else
        local available_sources = s.get_available(filetype)
        local registered = {}
        for _, source in ipairs(available_sources) do
          for method in pairs(source.methods) do
            registered[method] = registered[method] or {}
            table.insert(registered[method], source.name)
          end
        end
        return registered
      end
    end

    list_registered = function(filetype, method)
      local registered_providers = list_registered_providers_names(filetype)
      return registered_providers[method] or {}
    end
  end

  local supported_formatters = list_registered(vim.bo.ft, FORMATTER) or ""
  local supported_linters = list_registered(vim.bo.ft, LINTER) or ""
  vim.list_extend(buf_client_names, supported_formatters)
  vim.list_extend(buf_client_names, supported_linters)

  -- add treesitter to the end
  if TS then
    -- if #buf_clients > 0 then -- this guarantee it won't cause error.
    table.insert(buf_client_names, TS)
    -- end
  end

  return condition
      and "%#StText#" .. "  ~ "
      .. table.concat(buf_client_names, ",")
      .. (vim.o.columns > 140 and " | " or " ") -- condition from cursor_postition
      or ""
end

M.cursorPos = function()
  return vim.o.columns > 140 and "%#StText#:%l :%c  " or ""
end

return M
