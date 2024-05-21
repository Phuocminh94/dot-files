local custom = vim.api.nvim_create_augroup("CustomAutocmd", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

--[[ Highlight yanked text  ]]
autocmd("TextYankPost", {
  desc = "Highlight yanked text",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual" })
  end,
  group = custom,
})

--[[ Execute code ]]
autocmd({ "FileType", "BufEnter" }, {
  desc = "Execute code file/block",
  pattern = { "*" },
  callback = function()
    if vim.bo.ft == "lua" then
      vim.cmd([[nnoremap <silent> <buffer> <leader><C-M> :so %<CR>]])
      -- vim.cmd [[vnoremap <silent> <buffer> <F5> :w so %<CR>]]
    elseif vim.bo.ft == "python" then
      vim.cmd([[nnoremap <silent> <buffer> <leader><C-M> : !python3 %<CR>]])
      vim.cmd([[vnoremap <silent> <buffer> <leader><C-M> :w !python3 <CR>]])
    elseif vim.bo.ft == "javascript" then
      vim.cmd([[nnoremap <silent> <buffer> <leader><C-M> : !node %<CR>]])
      vim.cmd([[vnoremap <silent> <buffer> <leader><C-M> :w !node <CR>]])
    elseif vim.bo.ft == "vim" then
      vim.cmd([[nnoremap <silent> <buffer> <leader><C-M> :so %<CR>]])
    elseif vim.bo.ft == "r" then
      vim.cmd([[nnoremap <silent> <buffer> <leader><C-M> : !Rscript %<CR>]])
    elseif vim.bo.ft == "cpp" then
      vim.cmd([[nnoremap <silent> <buffer> <leader><C-M> :w<CR>:!g++ % -o %:r && ./%:r<CR>]])
    end
  end,
  group = custom,
})

--[[ Quick escape with q ]]
autocmd({ "FileType" }, {
  group = custom,
  pattern = {
    "Markdown",
    "checkhealth",
    "dap floats",
    "help",
    "lazy",
    "lspinfo",
    "man",
    "qf",
    "git",
    "spectre_panel",
    "sh",
  },
  desc = "Quick escape with q",
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      nnoremap <silent> <buffer> <esc> :close<CR>
      set nobuflisted
    ]])
  end,
})

--[[ Fix indent blankline ]]
vim.g.refreshBlankline = true
autocmd(
  { "LspAttach" }, -- what if there is no lsp sever attach to this buffer.
  {                -- use BufRead, BufEnter, ... could defer the loading flow.
    pattern = { "*" },
    desc = "Refresh indent blankline on startup",
    callback = function()
      vim.defer_fn(function()
        -- FIX: Fixed buffer with no server attach by check if package.loaded?
        if vim.g.refreshBlankline and package.loaded["indent_blankline"] then
          vim.cmd([[IndentBlanklineRefresh]])
          vim.g.refreshBlankline = nil
        end
      end, 1)
    end,
    group = custom,
  }
)

--[[ Reload indent blankline on changes ]]
vim.g.initialColorscheme = require("core.utils").load_config().ui.theme
vim.g.initialIndentBlank = require("core.utils").load_config().ui.blankline.blank
vim.g.initialIndentChar = require("core.utils").load_config().ui.blankline.style
autocmd({ "BufWritePost" }, {
  pattern = { "*" },
  desc = "Reload indent on theme changed",
  group = custom,
  callback = function()
    local current_blank = require("core.utils").load_config().ui.blankline.blank
    local current_char = require("core.utils").load_config().ui.blankline.style
    local current_color = require("core.utils").load_config().ui.theme
    if
        vim.g.initialColorscheme ~= current_color
        or vim.g.initialIndentBlank ~= current_blank
        or vim.g.initialIndentChar ~= current_char
    then
      require("plenary.reload").reload_module("plugins.configs.blankline")
      -- Defer the execution of the second line by 50 milliseconds
      vim.defer_fn(function()
        vim.cmd([[Lazy reload indent-blankline.nvim]])
        vim.cmd([[IndentBlanklineRefresh]])
      end, 50)
      vim.g.initialColorscheme = current_color
      vim.g.initialIndentChar = current_char
      vim.g.initialIndentBlank = current_blank
    end
  end,
})

-- --- Prevent custom.configs.section from loading null-ls on startup. ---
-- The timing does matter.
vim.g.loadedFormatter = false
vim.g.loadedLinter = false
autocmd({ "BufRead" }, {
  pattern = { "*" },
  desc = "Prevent custom.configs.section from loading null-ls on startup",
  callback = function()
    vim.schedule(function()
      if not (vim.g.loadedFormatter and vim.g.loadedFormatter) then
        local ok, s = pcall(require, "null-ls.sources")
        if ok then
          vim.g.loadedFormatter = true
          vim.g.loadedLinter = true
        end
      end
    end)
  end,
})

--[[ Highlight URL ]]
autocmd({
  "VimEnter", --[[ "FileType", "BufEnter", "WinEnter" ]]
}, {
  desc = "URL Highlighting",
  group = custom,
  callback = function()
    -- Define HighlightURL highlight group
    vim.api.nvim_exec([[ hi def link HighlightURL Underlined ]], false)
    vim.cmd("highlight HighlightURL gui=underline,italic guifg=#1174b1")
    matchURL()
  end,
})

--[[ Press dd in qflist to remove an item  ]]
autocmd({ "FileType" }, {
  group = custom,
  pattern = { "qf" },
  desc = "Remove quickfix item when press dd",
  callback = function()
    function _G.removeQFItem()
      local curqfidx = vim.fn.line(".") - 1
      local qfall = vim.fn.getqflist()
      table.remove(qfall, curqfidx + 1)
      vim.fn.setqflist(qfall, "r")
      vim.cmd(curqfidx + 1 .. "cfirst")
      vim.cmd(":copen")
    end

    vim.cmd("command! RemoveQFItem lua removeQFItem()")
    vim.api.nvim_buf_set_keymap(0, "n", "dd", "<cmd> RemoveQFItem <CR>", { silent = true })
  end,
})

--[[ Remove statusline on startup  ]]
vim.g.hasBufName = false
vim.g.autocmdEnabled = true
autocmd({ "BufRead", "FileType" }, {
  pattern = { "*" },
  desc = "Remove statusline on startup",
  callback = function()
    if vim.g.autocmdEnabled then
      if vim.g.hasBufName then
        vim.cmd([[set laststatus=3]])
        vim.g.autocmdEnabled = false
      else
        vim.cmd([[set laststatus=0]])
        vim.g.hasBufName = vim.api.nvim_buf_get_name(0) ~= "" and not vim.g.hasBufName or vim.g.hasBufName
      end
    end
  end,
})

--[[  Auto resize panels  ]]
autocmd("VimResized", {
  desc = "Auto resize panes when resizing nvim window",
  group = custom,
  pattern = "*",
  command = "tabdo wincmd =",
})

--[[ Set short keymap for nvdash  ]]
autocmd({ "FileType" }, {
  pattern = { "nvdash" },
  group = custom,
  desc = "Set Nvdash short keybinds",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "f", "<cmd> Telescope find_files <CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "w", "<cmd> Telescope live_grep_args <CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "o", "<cmd> Telescope oldfiles <CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "b", "<cmd> Telescope marks <CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "t", "<cmd> Telescope themes <CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd> q! <CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "L", "<cmd> Lazy <CR>", { silent = true })
    vim.api.nvim_buf_set_keymap(0, "n", "p", "<cmd> Telescope project <CR>", { silent = true })
  end,
  group = custom,
})

--[[ Restore save view ]]
--Credit to https://github.com/askfiy/SimpleNvim/blob/master/lua/core/command/autocmd.lua
autocmd("BufReadPost", {
  pattern = { "*" },
  group = custom,
  desc = "return at where I was",
  callback = function()
    if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
      ---@diagnostic disable-next-line: param-type-mismatch
      vim.fn.setpos(".", vim.fn.getpos("'\""))
      -- how do I center the buffer in a sane way??
      -- vim.cmd('normal zz')
      vim.cmd("silent! foldopen")
    end
  end,
})

--[[ Handy for hiding numbers in Iron.Repl ]]
autocmd("TermOpen", {
  pattern = "*",
  group = custom,
  desc = "Hide line number on term open",
  callback = function()
    vim.cmd("setlocal nonumber norelativenumber")
  end,
})

--[[ UFO stuff  ]]
autocmd("FileType", {
  pattern = { "nvcheatsheet" },
  group = custom,
  desc = "detach ufo on nvcheatsheet",
  callback = function()
    vim.cmd([[lua require "ufo".detach()]])
  end,
})

autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "Save view with mkview for real files",
  group = custom,
  callback = function(event)
    if vim.b[event.buf].view_activated then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})

autocmd("BufWinEnter", {
  desc = "Try to load file view if available and enable view saving for real files",
  group = custom,
  callback = function(event)
    if not vim.b[event.buf].view_activated then
      local filetype = vim.bo[event.buf].filetype
      local buftype = vim.bo[event.buf].buftype
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
      if
          buftype == ""
          and filetype
          and filetype ~= ""
          and filetype ~= ""
          and not vim.tbl_contains(ignore_filetypes, filetype)
      then
        vim.b[event.buf].view_activated = true
        vim.cmd.loadview({ mods = { emsg_silent = true } })
      end
    end
  end,
})

--[[ Turn off auto comment on next line ]]
autocmd("FileType", {
  desc = "Disable automatic comment insertion",
  group = custom,
  pattern = { "*" },
  callback = function()
    vim.cmd("setlocal formatoptions-=c formatoptions-=r formatoptions-=o")
  end,
})

--[[ Correction for Neovim colorscheme ]]
autocmd({ "BufReadPost", "BufWritePost" }, {
  desc = "Auto change some HL group on Neovim colorscheme",
  group = custom,
  pattern = { "*" },
  callback = function()
    local yellow = "#e4e41e"
    local blue = "#1174b1"
    if vim.g.nvchad_theme == "neovim" then
      vim.cmd("highlight CursorLineNr" .. " guifg=" .. yellow)
      vim.cmd("highlight Search" .. " guibg=" .. blue)
      vim.cmd("highlight DiffRemoved" .. " guifg=" .. yellow)
      vim.cmd("highlight HighlightURL gui=underline,italic guifg=#25cf6f")
      vim.cmd("highlight UfoCustom" .. " guifg=" .. "#25f0ff" .. " guibg=none")
    elseif vim.g.nvchad_theme == "github_official" then
      vim.cmd("highlight HighlightURL gui=underline,italic guifg=#1174b1")
      vim.cmd("highlight UfoCustom" .. " guifg=" .. "#a5d3fb" .. " guibg=none")
      vim.cmd("highlight Search" .. " guibg=" .. "#a5d3fb")
    else
      vim.cmd("highlight UfoCustom" .. " guifg=" .. "#aaadae" .. " guibg=none")

    end
  end,
})
