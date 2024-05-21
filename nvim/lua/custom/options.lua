-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
local opt = vim.opt
local g = vim.g

-- =============================== globals ===============================
g.dap_list = { "python", "cpp" }
g.formatters_list = {
  "black",
  "clang_format",
  "isort",
  "prettierd",
  "stylua",
}
g.conform_list = { -- deprecated
  lua = { "stylua" },
  python = { "isort", "black" },
  cpp = { "clang_format" },
}
g.linters_list = {}
g.mason_binaries_list = { "marksman", "pylsp", "vimls", "r_language_server", "clangd", "emmet_ls" }
g.ts_binaries_list = { "markdown", "lua", "python", "vimdoc", "html", "javascript", "cpp", "r" }
g.highlighturl_enabled = true
g.diagnostic_mode = { virtual_text = false, signs = false, underline = false, update_in_insert = false }
g.diagnostic_mode_num = 1
g.python3_host_prog = "~/.local/lib/virtualvenvs/ds/bin/python"
g.toggle_barbecue = true
g.lua_snippets_path = "~/.config/nvim/lua/snippets/"
g.personal_note_path = "/mnt/c/Users/PhuocMinh/iCloudDrive/iCloud~md~obsidian/Notes/Personal/vim-todo.md"

-- =============================== options ===============================
opt.foldcolumn = "1"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "⌄",
  foldsep = " ",
  foldclose = "›",
}
opt.history = 100         -- number of commands to remember in a history table
opt.number = true         -- show numberline
opt.relativenumber = true -- show relative numberline
opt.swapfile = false
opt.wrap = false          -- disable wrapping of lines longer than the width of window
opt.writebackup = false   -- disable making a backup before overwriting a fileopt.writebackup = false   -- disable making a backup before overwriting a file
