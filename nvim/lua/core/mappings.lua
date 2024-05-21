-- n, v, i, t = mode names

-- Move or create
---@param key 'h'|'j'|'k'|'l'
local function move_or_create_win(key)
  local fn = vim.fn
  local curr_win = fn.winnr()
  vim.cmd("wincmd " .. key)      --> attempt to move

  if curr_win == fn.winnr() then --> didn't move, so create a split
    if key == "h" or key == "l" then
      vim.cmd("wincmd v")
    else
      vim.cmd("wincmd s")
    end

    vim.cmd("wincmd " .. key)
  end
end

---@param ft 'filetype'
local get_ft_cmd = function(ft)
  local filepath = vim.fn.expand("%:p")   -- full path of the current file (including directory)
  local dirname = vim.fn.expand("%:p:h")  -- directory of the current file
  local basename = vim.fn.expand("%:t:r") -- filename without extension of the current file
  local executable_dir = dirname          -- Use the directory of the current file

  ft_cmds = {
    cpp = string.format("g++ %s -o %s/%s && %s/%s", filepath, dirname, basename, dirname, basename),
    python = string.format("python3 %s", filepath),
  }
  return ft_cmds[ft]
end

---@param t 'TODO'|'WARN'|'NOTE'|'FIX'
local todo_comment = function(t)
  local isLoaded = package.loaded["todo-comments"] ~= nil

  if not isLoaded then
    vim.cmd([[lua require "todo-comments"]])
  end

  vim.api.nvim_put({ t .. ": " }, "", false, true)
  vim.cmd([[lua require("Comment.api").toggle.linewise()]])
  vim.cmd([[normal! A ]])
  vim.cmd([[startinsert]])
end

local M = {}

M.general = {
  i = {
    -- go to  beginning and end
    ["<C-b>"] = { "<ESC>^i", "Beginning of line" },
    ["<C-e>"] = { "<End>", "End of line" },

    -- navigate within insert mode
    ["<C-h>"] = { "<Left>", "Move left" },
    ["<C-l>"] = { "<Right>", "Move right" },
    ["<C-j>"] = { "<Down>", "Move down" },
    ["<C-k>"] = { "<Up>", "Move up" },
  },

  n = {
    ["<leader><leader>"] = { "<cmd> noh <CR>", "Clear highlights" },

    -- smartly switch between windows https://github.com/BrunoKrugel/dotfiles/blob/master/lua/mappings.lua
    ["<C-h>"] = {
      function()
        move_or_create_win("h")
      end,
      "Window left",
    },
    ["<C-l>"] = {
      function()
        move_or_create_win("l")
      end,
      "Window right",
    },
    ["<C-j>"] = {
      function()
        move_or_create_win("j")
      end,
      "Window down",
    },
    ["<C-k>"] = {
      function()
        move_or_create_win("k")
      end,
      "Window up",
    },

    -- save
    ["<C-s>"] = { "<cmd> w <CR>", "Save file" },

    -- Copy all
    -- ["<C-c>"] = { "<cmd> %y+ <CR>", "Copy whole file" },

    -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
    -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
    -- empty mode is same as using <cmd> :map
    -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
    ["j"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true },
    },
    ["k"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      "Move up",
      opts = { expr = true },
    },
    ["<Up>"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      "Move up",
      opts = { expr = true },
    },
    ["<Down>"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true },
    },

    -- new buffer
    ["<leader>b"] = { "<cmd> enew <CR>", "New buffer" },
    ["<leader>ch"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "LSP formatting",
    },
  },

  t = {
    ["<C-x>"] = {
      vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true),
      "Escape terminal mode",
    },
  },

  v = {
    ["<Up>"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      "Move up",
      opts = { expr = true },
    },
    ["<Down>"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true },
    },
    ["<"] = { "<gv", "Indent line" },
    [">"] = { ">gv", "Indent line" },
    ["<leader>fm"] = {
      function()
        vim.lsp.buf.format({ async = true })
      end,
      "LSP formatting",
    },
  },

  x = {
    ["j"] = {
      'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
      "Move down",
      opts = { expr = true },
    },
    ["k"] = {
      'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
      "Move up",
      opts = { expr = true },
    },
    -- Don't copy the replaced text after pasting in visual mode
    -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
    ["p"] = {
      'p:let @+=@0<CR>:let @"=@0<CR>',
      "Dont copy replaced text",
      opts = { silent = true },
    },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- buffers
    ["]b"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["[b"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },

    -- close buffer + hide terminal buffer
    ["<leader>x"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },

    -- close buffers at direction
    ["<leader>cr"] = {
      function()
        require("nvchad.tabufline").closeBufs_at_direction("right")
      end,
      "Close buffer(s) right",
    },

    ["<leader>cl"] = {
      function()
        require("nvchad.tabufline").closeBufs_at_direction("left")
      end,
      "Close buffer(s) left",
    },

    ["<leader>X"] = {
      function()
        require("nvchad.tabufline").closeAllBufs()
      end,
      "Close buffer(s) all",
    },

    ["<leader>bo"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs()
      end,
      "Close buffer(s) all except the current",
    },

    [">b"] = {
      function()
        require("nvchad.tabufline").move_buf(1)
      end,
      "Move buffer to right",
    },

    ["<b"] = {
      function()
        require("nvchad.tabufline").move_buf(-1)
      end,
      "Move buffer to left",
    },

    -- tab
    ["<leader><tab><tab>"] = { "<cmd>tabnew<CR>", "New tab" },
    ["<leader><tab>d"] = { "<cmd>tabclose<CR>", "Close tab" },
  },
}

M.comment = {
  plugin = true,

  -- toggle comment in both modes
  n = {
    ["<leader>/"] = {
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      "Toggle comment",
    },

    ["gctd"] = {
      -- NOTE: Don't call the todo_comment function directly
      function()
        todo_comment("TODO")
      end,
      "TODO comment",
    },

    ["gcn"] = {
      function()
        todo_comment("NOTE")
      end,
      "NOTE comment",
    },

    ["gcw"] = {
      function()
        todo_comment("WARN")
      end,
      "WARNING comment",
    },

    ["gcf"] = {
      function()
        todo_comment("FIX")
      end,
      "FIX comment",
    },
  },

  v = {
    ["<leader>/"] = {
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
      "Toggle comment",
    },
  },
}

M.lspconfig = {
  plugin = true,

  -- See `<cmd> :help vim.lsp.*` for documentation on any of the below functions

  n = {
    ["gD"] = {
      function()
        vim.lsp.buf.declaration()
      end,
      "LSP declaration",
    },

    ["gd"] = {
      function()
        vim.lsp.buf.definition()
      end,
      "LSP definition",
    },

    ["K"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },

    ["gi"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "LSP implementation",
    },

    ["<leader>ls"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature help",
    },

    ["<leader>D"] = {
      function()
        vim.lsp.buf.type_definition()
      end,
      "LSP definition type",
    },

    ["<leader>rn"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },

    ["gr"] = {
      function()
        vim.lsp.buf.references()
      end,
      "LSP references",
    },

    ["gl"] = {
      function()
        vim.diagnostic.open_float({ border = "rounded" })
      end,
      "Floating diagnostic",
    },

    ["gh"] = {
      function()
        if vim.lsp.inlay_hint then
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end
      end,
      "Toggle inlay hint",
    },

    ["[d"] = {
      function()
        vim.diagnostic.goto_prev({ float = { border = "rounded" } })
      end,
      "Goto prev",
    },

    ["]d"] = {
      function()
        vim.diagnostic.goto_next({ float = { border = "rounded" } })
      end,
      "Goto next",
    },

    ["<leader>q"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "Diagnostic setloclist",
    },

    ["<leader>wa"] = {
      function()
        vim.lsp.buf.add_workspace_folder()
      end,
      "Add workspace folder",
    },

    -- symbols
    ["<leader>sd"] = { "<cmd> Telescope lsp_document_symbols <CR>", "Document symbols" },
    ["<leader>sw"] = { "<cmd> Telescope lsp_workspace_symbols <CR>", "Workspace symbols" },

    ["<leader>wr"] = {
      function()
        vim.lsp.buf.remove_workspace_folder()
      end,
      "Remove workspace folder",
    },

    ["<leader>wl"] = {
      function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end,
      "List workspace folders",
    },
  },

  v = {
    ["<leader>ca"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },
  },
}

M.nvimtree = {
  plugin = true,

  n = {
    -- toggle
    ["<leader>e"] = { "<cmd> NvimTreeToggle <CR>", "Toggle nvimtree" },
  },
}

M.telescope = {
  plugin = true,

  n = {
    -- find
    ["<leader>ff"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>fa"] = {
      "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>",
      "Find all",
    },
    -- ["<leader>fw"] = { "<cmd> Telescope live_grep <CR>", "Live grep" },
    ["<leader>fb"] = { "<cmd> Telescope buffers <CR>", "Find buffers" },
    ["<leader>fh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["<leader>fH"] = { "<cmd> Telescope highlights <CR>", "Find highlights" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "Find oldfiles" },
    ["<leader>fg"] = { "<cmd> Telescope live_grep_args <CR>", "Live grep args" },
    ["<leader>fp"] = { "<cmd> Telescope project <CR>", "Find project" },
    ["<leader>f/"] = {
      "<cmd> Telescope current_buffer_fuzzy_find <CR>",
      "Find in current buffer",
    },
    ["<leader>fe"] = { "<cmd> Telescope file_browser <CR>", "Telescope explorer" },
    ["<leader>fE"] = {
      "<cmd> Telescope file_browser files=false <CR>",
      "Telescope explorer folders",
    },
    ["<leader>fN"] = {
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      "Find Neovim files",
    },

    ["<leader>fn"] = {
      function()
        require("telescope.builtin").find_files({
          cwd = "/Users/minhbui/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes",
        })
      end,
      "Find personal notes",
    },

    ["<leader>f<CR>"] = {
      function()
        require("telescope.builtin").resume()
      end,
      "Resume previous search",
    },

    -- git
    ["<leader>cm"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "Git status" },

    -- pick a hidden term
    ["<leader>pt"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },
    -- ["<leader>pt"] = { "<cmd> TermSelect <CR>", "Pick hidden term" },

    -- theme switcher
    ["<leader>th"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },

    ["<leader>bm"] = { "<cmd> Telescope marks <CR>", "Telescope bookmarks" },

    -- find word under cursor
    ["<leader>fw"] = {
      function()
        local word = vim.fn.expand("<cword>")
        require("telescope.builtin").grep_string({ search = word })
      end,
      "Find word under cursor",
    },

    ["<leader>fW"] = {
      function()
        local word = vim.fn.expand("<cWORD>")
        require("telescope.builtin").grep_string({ search = word })
      end,
      "Find WORD under cursor",
    },
  },
}

M.nvterm = {
  plugin = true,

  t = {
    -- toggle in terminal mode
    ["<A-\\>"] = {
      function()
        require("nvterm.terminal").toggle("float")
      end,
      "Toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle("horizontal")
      end,
      "Toggle horizontal term",
    },

    ["\\ip"] = {
      function()
        vim.cmd([[lua require("nvterm.terminal").new("vertical")]])
        vim.cmd([[lua require("nvterm.terminal").send("ipython")]])
        vim.cmd([[startinsert]])
      end,
      "New ipython term",
    },

    ["\\rn"] = {
      function()
        require("nvterm.terminal").send(get_ft_cmd(vim.bo.ft), "float")
      end,
      "Run code on filetype",
    },

    -- new
    ["\\nht"] = {
      function()
        require("nvterm.terminal").new("horizontal")
      end,
      "New horizontal term",
    },

    ["\\nvt"] = {
      function()
        require("nvterm.terminal").new("vertical")
      end,
      "New vertical term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle("vertical")
      end,
      "Toggle vertical term",
    },

    ["<C-\\>"] = {
      [[ <cmd> let $DIR=expand('%:p:h') | lua require('nvterm.terminal').toggle 'float' <CR> cd $DIR && clear <CR> ]],
      "Toggle cwd floating term",
    },
  },

  n = {
    -- toggle in normal mode
    ["<A-\\>"] = {
      function()
        require("nvterm.terminal").toggle("float")
      end,
      "Toggle floating term",
    },

    ["<A-h>"] = {
      function()
        require("nvterm.terminal").toggle("horizontal")
      end,
      "Toggle horizontal term",
    },

    ["\\rn"] = {
      function()
        require("nvterm.terminal").send(get_ft_cmd(vim.bo.filetype), "float")
      end,
      "Run code on filetype",
    },

    ["\\ip"] = {
      function()
        vim.cmd([[lua require("nvterm.terminal").new("vertical")]])
        vim.cmd([[lua require("nvterm.terminal").send("ipython")]])
        vim.cmd([[startinsert]])
      end,
      "New ipython term",
    },

    ["<A-v>"] = {
      function()
        require("nvterm.terminal").toggle("vertical")
      end,
      "Toggle vertical term",
    },

    ["<C-\\>"] = {
      [[ <cmd> let $DIR=expand('%:p:h') | lua require('nvterm.terminal').toggle 'float' <CR> cd $DIR && clear <CR> ]],
      "Toggle cwd floating term",
    },

    -- new
    ["\\nht"] = {
      function()
        require("nvterm.terminal").new("horizontal")
      end,
      "New horizontal term",
    },

    ["\\nvt"] = {
      function()
        require("nvterm.terminal").new("vertical")
      end,
      "New vertical term",
    },
  },
}

M.whichkey = {
  plugin = true,

  n = {
    ["<leader>wK"] = {
      function()
        vim.cmd("WhichKey")
      end,
      "Which-key all keymaps",
    },
    ["<leader>wk"] = {
      function()
        local input = vim.fn.input("WhichKey: ")
        vim.cmd("WhichKey " .. input)
      end,
      "Which-key query lookup",
    },
  },
}

M.blankline = {
  plugin = true,

  n = {
    ["<leader>cc"] = {
      function()
        local ok, start = require("indent_blankline.utils").get_current_context(
          vim.g.indent_blankline_context_patterns,
          vim.g.indent_blankline_use_treesitter_scope
        )

        if ok then
          vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start, 0 })
          vim.cmd([[normal! _]])
        end
      end,

      "Jump to current context",
    },
  },
}

M.gitsigns = {
  plugin = true,

  n = {
    -- Navigation through hunks
    ["]h"] = {
      function()
        if vim.wo.diff then
          return "]h"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end,

      "Jump to next hunk",
      opts = { expr = true },
    },

    ["[h"] = {
      function()
        if vim.wo.diff then
          return "[h"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end,

      "Jump to prev hunk",
      opts = { expr = true },
    },

    -- Actions
    ["<leader>hr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,

      "Reset hunk",
    },

    ["<leader>hp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,

      "Preview hunk",
    },

    ["<leader>hb"] = {
      function()
        package.loaded.gitsigns.blame_line()
      end,

      "Blame line",
    },

    ["<leader>hib"] = {
      function()
        package.loaded.gitsigns.toggle_current_line_blame()
      end,

      "Blame inline",
    },

    ["<leader>hd"] = {
      function()
        require("gitsigns").diffthis()
      end,

      "Diff this",
    },

    ["<leader>hD"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,

      "Toggle deleted",
    },

    ["<leader>hs"] = {
      function()
        require("gitsigns").stage_hunk()
      end,

      "Stage hunk",
    },

    ["<leader>hS"] = {
      function()
        require("gitsigns").stage_buffer()
      end,

      "Stage hunk",
    },

    ["<leader>hu"] = {
      function()
        require("gitsigns").undo_stage_hunk()
      end,

      "Undo stage hunk",
    },
  },
}

return M
