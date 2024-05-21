local colors = require("base46").get_theme_tb "base_30"
local ibl = require "core.utils".load_config().ui.blankline
local style = ibl.style

-- export lightbg to use later
vim.g.mylightbg = colors.lightbg
vim.g.myGreen = colors.green
vim.g.myRed = colors.red
vim.g.myDarkbg = colors.darker_black

local function addHighlights()
  local common = "IndentBlankline"

  if ibl.blank then
    style = "blank"
    return {
      [common:gsub("line", "") .. "Dark"] = " guibg=" .. colors.darker_black .. " gui=nocombine",
      [common:gsub("line", "") .. "Light"] = " guibg=" .. colors.black .. " gui=nocombine",
    }
  else
    -- remove space if style ~= "blank"
    vim.cmd("highlight clear IndentBlankDark")
    vim.cmd("highlight clear IndentBlankLight")

    if style == "rainbow" then
      return {
        [common .. "Rainbow1"] = " guifg=" .. colors.red,
        [common .. "Rainbow2"] = " guifg=" .. colors.yellow,
        [common .. "Rainbow3"] = " guifg=" .. colors.green,
        [common .. "Rainbow4"] = " guifg=" .. colors.cyan,
        [common .. "Rainbow5"] = " guifg=" .. colors.blue,
        [common .. "Rainbow6"] = " guifg=" .. colors.purple,
      }
    end
    return
  end
end

local function getHighlights()
  local hl = addHighlights()

  if not hl then
    return nil
  end

  for name, strColor in pairs(hl) do
    vim.cmd("highlight " .. name .. strColor)
  end

  local hl_names = vim.tbl_keys(hl)
  table.sort(hl_names, function(a, b)
    return b > a
  end)
  return hl_names
end

local options = {
  ---------------------------------------------
  char_highlight_list = getHighlights(),
  char = style == "blank" and "" or "▏",
  space_char_highlight_list = style == "blank" and getHighlights() or nil,
  show_trailing_blankline_indent = style == "blank" and true or false,
  filetype_exclude = {
    "help",
    "terminal",
    "lazy",
    "lspinfo",
    "TelescopePrompt",
    "TelescopeResults",
    "mason",
    "nvdash",
    "nvcheatsheet",
    "NvimTree",
    "Outline",
    "",
  },
  buftype_exclude = { "terminal" },
}

return options
