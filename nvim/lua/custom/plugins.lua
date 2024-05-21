local key_opts = { noremap = true, silent = true }

return {

  --[[ Navigation ]]
  {
    "psliwka/vim-smoothie",
    keys = { "<C-d>", "<C-u>" },
  },

  {
    "smoka7/hop.nvim",
    version = "*",
    keys = {
      "f",
      "F",
      "t",
      "T",
      "vf",
      "vF",
      "vt",
      "vT",
      "gs",
      "<leader>yy",
      "<leader>pp",
    },
    config = function()
      require("custom.configs.hop")()
      vim.cmd("highlight HopNextKey" .. " guifg='#4AF626'" .. "guibg=" .. vim.g.mylightbg)
    end,
  },

  {
    "sam4llis/nvim-lua-gf",
    keys = { "gf" },
  },

  {
    "max397574/better-escape.nvim",
    event = "InsertCharPre",
    opts = { mapping = { "jk", "jj" }, timeout = 300 }, -- a table with mappings to use
  },

  {
    "chentoast/marks.nvim",
    keys = { "'", "`", "m", "<leader>bm" },
    init = function()
      vim.cmd("highlight MarkSignNumHL" .. " guifg='#ff007c'")
    end,
    config = function()
      require("marks").setup({
        default_mappings = true,
        mappings = {
          delete = "dm",
          delete_line = "dml",
          next = "m]",
          prev = "m[",
          preview = "mp",
          set = "m",
        },
      })
    end,
  },

  {
    "rmagatti/goto-preview",
    event = "LspAttach",
    opts = { default_mappings = true },
  },

  --[[ Text-editing ]]
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    keys = {
      "ys",
      "cs",
      "ds",
      "v",
      "V",
    },
    opts = {},
  },

  {
    "mg979/vim-visual-multi",
    event = "BufRead",
    enabled = true,
    init = function()
      vim.cmd("highlight VisualMulti" .. " guibg='#3e3f53'" .. " guifg='#ff007c'") -- same Hop color
      -- vim.api.nvim_set_hl(0, "VisualMulti", { link = "Visual" })
      vim.api.nvim_set_hl(0, "VM_Mono", { link = "VisualMulti" })
      vim.api.nvim_set_hl(0, "VM_Extend", { link = "VisualMulti" })
      vim.api.nvim_set_hl(0, "VM_Cursor", { link = "VisualMulti" })
      vim.cmd([[let g:VM_default_mappings = 0]])
      vim.cmd([[let g:VM_mouse_mappings = 1]])
      vim.cmd([[let g:VM_leader = '\\\\']])
      vim.cmd([[ let g:VM_set_statusline = 0 ]])
      vim.cmd([[ let g:VM_show_warnings = 0 ]])
      vim.cmd([[ let g:VM_silent_exit = 1 ]])
    end,
  },

  {
    "Wansmer/treesj",
    config = true,
  },

  {
    "junegunn/vim-easy-align",
    keys = { "ga" },
  },

  --[[ Terminal ]]
  {
    "voldikss/vim-floaterm",
    enabled = false,
    cmd = { "FloatermNew", "FloatermToggle", "FloatermSend" },
    init = function()
      require("core.utils").load_mappings("fterm")
      -- vim.cmd("highlight FloatermBorderCustom" .. " guifg='#ff007c'") -- same Hop color
      vim.cmd([[let g:floaterm_titleposition = 'right']])
      vim.cmd([[let g:floaterm_height = 0.7]])
      vim.cmd([[let g:floaterm_width = 0.65]])
      vim.cmd([[let g:floaterm_title = " Minh's Terminal ($1/$2) "]])
      -- vim.cmd([[hi link FloatermBorder NormalFloat]])
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    version = "*",
    enabled = false,
    keys = { "<A-\\>", "<C-\\>", "<A-v>", "<A-h>", "<leader>lg" },
    opts = function()
      return require("custom.configs.tterm")
    end,
    config = function(_, opts)
      require("toggleterm").setup(opts)
      require("core.utils").load_mappings("tterm")
    end,
  },

  --[[ Git ]]
  {
    "tpope/vim-fugitive",
    cmd = { "Git" },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  --[[ DAP ]]
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint", "DapContinue" },
    dependencies = {
      -- Creates a beautiful debugger UI
      "rcarriga/nvim-dap-ui",

      -- Installs the debug adapters
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      require("custom.configs.dapconfig")
    end,
  },

  --[[ Folding ]]
  {
    "kevinhwang91/nvim-ufo",
    keys = { "zr", "zm", "za", "zo", "[z", "]z" },
    event = { "BufRead" },
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            setopt = true,       -- Whether to set the 'statuscolumn' option, may be set to false for those who
            relculright = false, -- whether to right-align the cursor line number with 'relativenumber' set
            -- Builtin 'statuscolumn' options
            ft_ignore = nil,     -- lua table with 'filetype' values for which 'statuscolumn' will be unset
            bt_ignore = nil,     -- lua table with 'filetype' values for which 'statuscolumn' will be unset
            bt_ignore = nil,     -- lua table with 'filetype' values for which 'statuscolumn' will be unset
            bt_ignore = nil,     -- lua table with 'buftype' values for which 'statuscolumn' will be unset
            segments = {
              -- https://github.com/askfiy/SimpleNvim/blob/master/lua/core/depends/statuscol/init.lua
              {
                sign = {
                  name = { "Dap*", "Diag*" },
                  namespace = { "bulb*", "gitsign*" },
                  colwidth = 1,
                },
                click = "v:lua.ScSa",
              },
              {
                text = { " ", builtin.lnumfunc },
                condition = { true, builtin.not_empty },
                click = "v:lua.ScLa",
              },
              {
                text = { " ", builtin.foldfunc, "  " },
                condition = { true, builtin.not_empty },
                click = "v:lua.ScFa",
              },
            },
          })
        end,
      },
    },
    config = function()
      require("custom.configs.ufo")
      vim.keymap.set("n", "zj", "<cmd>lua next_closed_fold('j') <CR>", { desc = "Previous closed fold" })
      vim.keymap.set("n", "zk", "<cmd>lua next_closed_fold('k') <CR>", { desc = "Next closed fold" })
    end,
  },

  --[[ REPL ]]
  {
    "hkupty/iron.nvim",
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
    opts = function()
      return require("custom.configs.iron")
    end,
    config = function(_, opts)
      require("iron.core").setup(opts)
    end,
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },

  --[[ UI ]]
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODO" },
    },
    opts = {
      signs = false,
      highlight = {
        before = "fg",  -- "fg" or "bg" or empty
        keyword = "fg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg",   -- "fg" or "bg" or empty
      },
    },
  },

  {
    -- having some problems with hop; try gs + char
    "folke/noice.nvim",    -- used this help fix the problem with searching display in statusline.
    -- keys = { ":", "/", "?" },
    event = { "BufRead" }, -- fixed the above problem with hop
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup(require("custom.configs.noice"))
    end,
  },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    enabled = false,
    event = "LspAttach",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      show_dirname = true,
      show_basename = true,
    },
  },

  {
    "mbbill/undotree",
    cmd = { "UndotreeToggle" },
    keys = { "<leader>ut" },
    config = function()
      vim.keymap.set({ "i", "n", "v" }, "<leader>ut", ":UndotreeToggle<CR>", { desc = "Toggle undotree" })
    end,
  },

  {
    "hedyhli/outline.nvim",
    keys = { "<leader>o" },
    opts = function()
      return require("custom.configs.outline")
    end,
    config = function(_, opts)
      -- Example mapping to toggle outline
      vim.keymap.set("n", "<leader>o", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
      vim.api.nvim_set_hl(0, "OutlineCurrent", { link = "Visual" })

      require("outline").setup(opts)
    end,
  },

  {
    "Pocco81/true-zen.nvim",
    cmd = { "TZAtaraxis" },
    keys = { "<leader>z" },
    config = function()
      require("true-zen").setup({})
      vim.keymap.set("n", "<leader>z", "<cmd>TZMinimalist<CR>", { desc = "Zen mode" })
    end,
  },

  {
    "LudoPinelli/comment-box.nvim",
    keys = { "<leader>cbb", "<leader>cbl", "<leader>cby", "<leader>cba", "<leader>cbd" },
    opts = {
      lines = { -- symbols used to draw a line
        line = "=",
        line_start = "=",
        line_end = "=",
        title_left = "=",
        title_right = "=",
      },
    },
    config = function(_, opts)
      require("comment-box").setup(opts)
      vim.keymap.set({ "n", "v" }, "<leader>cbb", "<cmd>lua require 'comment-box'.cabox(9)<CR>", key_opts)
      vim.keymap.set({ "n", "v" }, "<leader>cbl", "<cmd>lua require 'comment-box'.lcline()<CR>", key_opts)
      vim.keymap.set({ "n", "v" }, "<leader>cbd", "<cmd>lua require('comment-box').dbox()<CR>", key_opts)
      vim.keymap.set({ "n", "v" }, "<leader>cby", "<cmd>lua require('comment-box').yank()<CR>", key_opts)
      vim.keymap.set({ "n" }, "<leader>cba", "<cmd>lua require('comment-box').catalog()<CR>", key_opts)
    end,
  },

  {
    "Phuocminh94/new_ui", -- get back when more modules added
    enabled = false,
    branch = "v2.5",
    init = function()
      require("core.utils").load_mappings("mterm")
    end,
  },

  --[[ Filetype ]]
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    enabled = true,
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  --[[ Session ]]

  --[[ Code assistant ]]
  {
    "siawkz/nvim-cheatsh",
    cmd = { "Cheat" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = true,
  },
}
