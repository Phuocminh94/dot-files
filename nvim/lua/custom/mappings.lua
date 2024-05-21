local opts = { silent = true }

return {
  general = {
    n = {

      -- change without yank
      ["c"] = { '"_c', "Change without yanking" },

      -- swap lines
      ["<A-j>"] = { ":m .+1<CR>==", "Swap below", opts = opts },
      ["<A-k>"] = { ":m .-2<CR>==", "Swap above", opts = opts },

      -- open link in defaukt browser
      ["gx"] = { "<cmd>silent !open <cfile><CR>", "Open link in browser" },

      -- markdown preview
      ["<leader>md"] = { "<cmd>MarkdownPreview<CR>", "Markdown preview" },

      -- buffer
      ["<Tab>"] = { "<cmd> e# <CR>", "Alternative buffer" },

      -- resize windows
      ["<C-Up>"] = { "<cmd>resize -2<CR>", "Resize up" },
      ["<C-Down>"] = { "<cmd>resize +2<CR>", "Resize down" },
      ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", "Resize left" },
      ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", "Resize right" },

      -- auto recenter search
      -- NOTE: behavior of n/N depend on / or ?
      -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
      ["n"] = { "nzz", "Recenter next search", cheatsheet = false, opts = opts },
      ["N"] = { "Nzz", "Recenter previous search", cheatsheet = false, opts = opts },

      -- clone VsCode style
      ["<A-S-k>"] = { "<cmd>t-1<CR>", "Copy line up" },
      ["<A-S-j>"] = { "<cmd>t.<CR>", "Copy line down" },

      -- change cwd
      ["<leader>cd"] = {
        function()
          vim.cmd([[execute 'set autochdir']])
          vim.cmd([[execute 'tcd '. expand('%:p:h')]])
        end,
        "Change cwd",
        opts = { silent = true, noremap = true },
      },

      -- quick fix
      ["]q"] = { "<cmd>cnext<CR>", "Next quickfix" },
      ["[q"] = { "<cmd>cprev<CR>", "Previous quickfix" },
      ["Q"] = { "<cmd>copen<CR>", "Open quickfix" },

      -- better join/split
      ["gJ"] = { "<cmd> lua require 'treesj'.toggle() <CR>", "Treesj toggle" },

      -- quit
      ["<leader>q"] = { "<cmd>confirm q<CR>", "Quit window" },
      ["<leader>Q"] = { "<cmd>confirm qall<CR>", "Quit all windows" },
    },

    i = {
      -- escape insert mode
      ["jk"] = { "<Esc>", "Escape insert mode" },
      ["JK"] = { "<Esc>", "Escape insert mode" },

      -- swap lines
      ["<A-j>"] = { "<Esc>:m .+1<CR>==gi", "Swap below", opts = opts },
      ["<A-k>"] = { "<Esc>:m .-2<CR>==gi", "Swap above", opts = opts },

      ["<C-f>"] = { "<C-o>de", "Delete till next word" },
    },

    v = {
      ["<A-S-j>"] = { "y'>:put<CR>`<gv", "Copy block down", opts = opts },
      ["<A-S-k>"] = { "<cmd>t-1<CR>", "Copy block up", opts = opts },
      ["<A-j>"] = { ":m '>+1<CR>gv-gv", "Visual swap below", opts = opts },
      ["<A-k>"] = { ":m '<-2<CR>gv-gv", "Visual swap above", opts = opts },
      ["<leader>s"] = { ":sort<CR>", "Sort lines", opts = opts },
      ["d"] = { '"_d', "Delete char without yank" },
    },
  },

  multicursor = {
    n = {
      ["<C-M-j>"] = { "<Plug>(VM-Add-Cursor-Down)", "Multicursor down" },
      ["<C-M-k>"] = { "<Plug>(VM-Add-Cursor-Up)", "Multicursor up" },

      ["\\\\a"] = { "<Plug>(VM-Select-All)", "Multicursor All" },
      ["\\\\A"] = { "<Plug>(VM-Align)", "Multicursor Align" },

      ["\\\\d"] = { "<Plug>(VM-Duplicate)", "Multicursor duplicate" },
      ["\\\\y"] = { "<Plug>(VM-Yank)", "Multicursor Yank" },
      ["\\\\p"] = { "<Plug>(VM-Paste)", "Multicursor Paste" },
    },
  },

  dapconfig = {
    n = {
      -- toggle breakpoint
      ["<leader>db"] = { "<cmd> lua require 'dap'.toggle_breakpoint() <CR>", "Toggle Breakpoint (F9)" },
      ["<F9>"] = { "<cmd> lua require 'dap'.toggle_breakpoint() <CR>", "Toggle Breakpoint (F9" },

      -- start/continue/stop/restart
      ["<leader>dc"] = { "<cmd> lua require 'dap'.continue() <CR>", "Start/Continue (F5)" },
      ["<F5>"] = { "<cmd> lua require 'dap'.continue() <CR>", "Start/Continue (F5)" },
      ["<F17>"] = {
        function()
          require("dap").terminate()
        end,
        "Stop",
      }, -- Shift+F5
      ["<leader>ds"] = {
        function()
          require("dap").terminate()
        end,
        "Stop (S-F5)",
      },
      ["<F29>"] = {
        function()
          require("dap").restart_frame()
        end,
        "Restart",
      }, -- Control+F5
      ["<leader>dr"] = {
        function()
          require("dap").restart_frame()
        end,
        "Restart",
      },

      -- step into/over/out
      ["<leader>di"] = { "<cmd> lua require 'dap'.step_into() <CR>", "Step Into (F11)" },
      ["<F11>"] = {
        function()
          require("dap").step_into()
        end,
        "Step Into",
      },

      ["<leader>do"] = { "<cmd> lua require 'dap'.step_over() <CR>", "Step Over (F10)" },
      ["<F10>"] = {
        function()
          require("dap").step_over()
        end,
        "Step Over",
      },

      ["<leader>dO"] = { "<cmd> lua require 'dap'.step_out() <CR>", "Step Out (Shift + F11)" },
      ["<F23>"] = {
        function()
          require("dap").step_out()
        end,
        "Step Out",
      }, -- Shift+F11

      -- conditional breakpoint
      ["<leader>dC"] = {
        function()
          require("dap").set_breakpoint(vim.fn.input("Condition: "))
        end,
        "Conditional Breakpoint (S-F9)",
      },
      ["<F21>"] = { -- Shift+F9
        function()
          vim.ui.input({ prompt = "Condition: " }, function(condition)
            if condition then
              require("dap").set_breakpoint(condition)
            end
          end)
        end,
        "Conditional Breakpoint",
      },

      ["<leader>dq"] = {
        function()
          require("dap").close()
        end,
        "Close Session",
      },
      ["<leader>dp"] = {
        function()
          require("dap").pause()
        end,
        "Pause (F6)",
      },
      ["<F6>"] = {
        function()
          require("dap").pause()
        end,
        "Pause",
      },
      ["<leader>dt"] = {
        function()
          require("dap").run_to_cursor()
        end,
        "Run To Cursor",
      },

      ["<leader>dE"] = {
        function()
          vim.ui.input({ prompt = "Expression: " }, function(expr)
            if expr then
              require("dapui").eval(expr, { enter = true })
            end
          end)
        end,
        "Evaluate Input",
      },
      ["<leader>du"] = {
        function()
          require("dapui").toggle()
        end,
        "Toggle Debugger UI",
      },
      ["<leader>dh"] = {
        function()
          require("dap.ui.widgets").hover()
        end,
        "Debugger Hover",
      },
    },
  },

  ["ui/ux"] = {
    n = {
      ["<leader>id"] = { [[ <cmd> lua require "custom.ui".set_indent() <CR> ]], "Set indent" },
      ["<leader>uh"] = { [[ <cmd> lua require "custom.ui".toggle_buffer_syntax() <CR> ]], "Toggle syntax highlight" },
      ["<leader>ul"] = { [[ <cmd> lua require "custom.ui".toggle_url_match() <CR> ]], "Toggle URL highlight" },
      ["<leader>un"] = { [[ <cmd> lua require "custom.ui".change_number() <CR> ]], "Change number mode" },
      ["<leader>up"] = { [[ <cmd> lua require "custom.ui".toggle_autopairs() <CR> ]], "Toggle autopairs" },
      ["<leader>uw"] = { [[ <cmd> lua require "custom.ui".toggle_wrap() <CR> ]], "Toggle wrap" },
      ["<leader>ud"] = { [[ <cmd> lua require "custom.ui".change_diagnostic_mode() <CR> ]], "Change diagnostic mode" },
      ["<leader>uc"] = { [[ <cmd> Lazy load nvim-colorizer.lua  <CR> ]], "Load colorizer" },
    },
  },

  REPL = {
    n = {
      ["<leader>st"] = { "<cmd> lua require 'iron.core'.send_until_cursor() <CR>", "Send till cursor" },
      ["<leader>so"] = { "<cmd> IronRepl <CR>", "Open/Close" },
      ["<leader>sf"] = { "<cmd> IronFocus <CR>", "Focus" },
      ["<leader>sa"] = { "<cmd> lua require 'iron.core'.send_file() <CR>", "Send all" },
      ["<leader>sr"] = { "<cmd> IronRestart <CR>", "Restart" },
      ["<leader>sl"] = { "<cmd> lua require 'iron.core'.send_line() <CR>", "Send line" },
    },

    v = {
      ["<leader>sv"] = { "<cmd> lua require 'iron.core'.visual_send() <CR>", "Send visual" },
    },

    x = {
      ["<leader>sv"] = { "<cmd> lua require 'iron.core'.visual_send() <CR>", "Send visual" },
    },
  },

  -----------------------------------Not meant to be set------------------------------------
  -- to be shown up on cheatsheet only
  -- set plugin = true
  -- add ~ make it appear at the end of cheatsheet.

  ["~ts-textobject"] = {
    plugin = true,
    select = {
      ["a="] = { "", "Outer assignment" },
      ["i="] = { "", "Inner assignment" },
      ["aa"] = { "", "Outer parameter" },
      ["ia"] = { "", "Inner parameter" },

      ["al"] = { "", "Outer loop" },
      ["il"] = { "", "Inner loop" },

      ["ab"] = { "", "Outer block" },
      ["ib"] = { "", "Inner block" },

      ["af"] = { "", "Outer function" },
      ["if"] = { "", "Inner function" },

      ["ac"] = { "", "Outer class" },
      ["ic"] = { "", "Inner class" },
    },

    move = {
      ["]m"] = { "", "Next start outer function" },
      ["]]"] = { "", "Next start outer class" },
      ["]a"] = { "", "Next start inner parameter" },

      ["]M"] = { "", "Next end outer function" },
      ["]["] = { "", "Next end outer class" },
      ["]A"] = { "", "Next end inner parameter" },

      ["[m"] = { "", "Previous start outer function" },
      ["[["] = { "", "Previous start outer class" },
      ["[a"] = { "", "Previous start inner parameter" },

      ["[M"] = { "", "Previous end outer function" },
      ["[]"] = { "", "Previous end outer class" },
      ["[A"] = { "", "Previous end inner parameter" },
    },
  },

  ["~telescope file-browser"] = {
    plugin = true,
    ["n,i"] = {
      ["[A-c]/c"] = { "", "Create file/folder at cwd" }, -- select/unselect file with tab/shift-tab
      ["[A-r]/r"] = { "", "Rename files/folders" },
      ["[A-y]/y"] = { "", "Copy files/folders to cwd" },
      ["[A-m]/m"] = { "", "Move files/folders to cwd" },
      ["[A-d]/d"] = { "", "Delete files/folders" },

      ["[C-h]/h"] = { "", "Toggle files/folders" },
      ["[C-f]/f"] = { "", "Toggle files/folders browser" },
      ["[C-g]/g"] = { "", "Go to parent directory" },
      ["[C-e]/e"] = { "", "Go to home directory" },
      ["[C-o]/o"] = { "", "Open with default apps" },
    },
  },

  ["~VIM: Ranger"] = {
    -- https://github.com/mhinz/vim-galore?tab=readme-ov-file#ranges
    plugin = true,
    ["c"] = {
      ["d"] = { "", "Current line" },
      [".d"] = { "", "Current line" },
      ["1d"] = { "", "First line" },
      ["$d"] = { "", "Last line" },
      ["1,$d"] = { "", "All lines" },
      ["%d"] = { "", "All lines (syntactic sugar for 1,$)" },
      [".,5d"] = { "", "Current line to 5" },
      [",5d"] = { "", "Current line to 5" },
      [",+3d"] = { "", "Current line and next 3 lines" },
      ["1,+3d"] = { "", "First line to current line + 3" },
      [",-3d"] = { "", "Current line and the last 3 lines" },
      ["3,'xdelete"] = { "", "Lines 3 to the line marked by mark x" },
      ["/^foo/,$delete"] = { "", 'From next line with "foo" till end' },
      ["/^foo/+1,$delete"] = { "", 'From line after line with "foo " till end' },
    },
  },
}
