---@type ChadrcConfig
local M = {}

M.ui = {

  --[[ General ]]
  blankline = { style = nil, blank = false }, -- style: rainbow/nil, blank = true/false
  cmp = { style = "atom" },
  extended_integrations = { "dap", "rainbowdelimiters", "todo" },
  hl_override = {
    CursorLineNr = { fg = "yellow" },
    FoldColumn = { bg = "none", fg = "lightbg" },
    LspReferenceRead = { bg = "lightbg", fg = "none" },
    LspReferenceText = { bg = "lightbg", fg = "none" }, -- same Visual highlight but lighter
    LspReferenceWrite = { bg = "lightbg", fg = "none" },
    NvDashAscii = { bg = "red" },
    TodoBgFix = { fg = "#00dfff", bg = "none" },
    TodoBgHack = { fg = "#ff007c", bg = "none" },
    TodoBgNote = { fg = "#8fa025", bg = "none" },
    TodoBgTodo = { fg = "#ff8c00", bg = "none" },
    TodoBgWarn = { fg = "#f02d0f", bg = "none" },
    TodoFgFix = { fg = "#00dfff" },
    TodoFgHack = { fg = "#ff007c" },
    TodoFgNote = { fg = "#8fa025" },
    TodoFgTodo = { fg = "#ff8c00" },
    TodoFgWarn = { fg = "#f02d0f" },
  },
  theme_toggle = { "neovim", "neovim" },
  theme = "neovim",

  --[[ Stline ]]
  statusline = {
    theme = "vscode",
    overriden_modules = function(modules)
      local custom = require("custom.configs.statusline")
      modules[1] = custom.mode()
      modules[2] = custom.fileInfo()
      modules[4] = custom.LSP_Diagnostics()
      modules[9] = custom.LSP_status()
      modules[10] = custom.tabWidth()
      modules[11] = custom.cursorPos()
      modules[12] = ""
      modules[13] = custom.cwd()
      table.insert(modules, 6, custom.others())
    end,
  },

  --[[ Dashboard ]]
  nvdash = {
    header = {
      [[ ╓─────────────────────────────────────╖ ]],
      [[ ║           █████████████             ║ ]],
      [[ ║          █▒  ██   ██                ║ ]],
      [[ ║              ██   ██                ║ ]],
      [[ ║              ██   ██                ║ ]],
      [[ ║             ███   ██                ║ ]],
      [[ ║            ▓██▒   ██▒  █            ║ ]],
      [[ ║           ███▓    ▓████             ║ ]],
      [[ ║                                     ║ ]],
      [[ ║    𝜋 𝑖𝑠 𝑖𝑟𝑟𝑎𝑡𝑖𝑜𝑛𝑎𝑙 𝑗𝑢𝑠𝑡 𝑙𝑖𝑘𝑒 𝑚𝑒!    ║ ]],
      [[ ╙─────────────────────────────────────╜ ]],
    },
    buttons = {
      { "󱙔  Find Files", "f", "Telescope find_files" },
      { "󱦺  Recent Files", "o", "Telescope oldfiles" },
      { "  Find Text", "w", "Telescope live_grep_args" },
      { "  Bookmarks", "b", "Telescope marks" },
      { "  Themes", "t", "Telescope themes" },
      { "  Projects", "p", "Telescope project" },
      { "󰒲  Lazy", "l", "Lazy" },
      { "  Exit", "q", "q" },
    },
  },
}

M.plugins = "custom.plugins"

M.mappings = require("custom.mappings")

return M
