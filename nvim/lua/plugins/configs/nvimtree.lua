local my_on_attach = function(bufnr)
  local api = require "nvim-tree.api"

  -- useful telescope functions
  local start_telescope = function(telescope_mode)
    local node = require("nvim-tree.lib").get_node_at_cursor()
    local abspath = node.link_to or node.absolute_path
    local is_folder = node.open ~= nil
    local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
    require("telescope.builtin")[telescope_mode] {
      cwd = basedir,
    }
  end

  local function telescope_find_files(_)
    start_telescope "find_files"
  end

  local function telescope_live_grep(_)
    start_telescope "live_grep"
  end

  -- set neccessary keymaps
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local key_tbl = {
    ["?"] = { api.tree.toggle_help, "Help" },
    ["<BS>"] = { api.tree.change_root_to_parent, "Up" },
    ["c"] = { api.fs.copy.node, "Copy" },
    ["p"] = { api.fs.paste, "Paste" },
    ["d"] = { api.fs.remove, "Remove" },
    ["x"] = { api.fs.cut, "Cut" },
    ["<2-LeftMouse>"] = { api.node.open.edit, "Open" },
    ["."] = { api.tree.change_root_to_node, "CD" },
    ["y"] = { api.fs.copy.relative_path, "Copy relative path " },
    ["Y"] = { api.fs.copy.absolute_path, "Copy absolute path " },
    ["r"] = { api.fs.rename, "Rename" },
    ["R"] = { api.tree.reload, "Reload" },
    ["K"] = { api.node.show_info_popup, "Info" },
    ["n"] = { api.fs.create, "New" },
    ["z"] = { api.tree.expand_all, "Expand " },
    ["Z"] = { api.tree.collapse_all, "Collapse " },
    ["/"] = { api.live_filter.start, "Find" },
    ["<C-v>"] = { api.node.open.vertical, "Open: vertical split" },
    ["<C-x>"] = { api.node.open.horizontal, "Open: horizontal split" },
    ["<Tab>"] = { api.node.open.preview, "Open Preview" },
    ["h"] = { api.node.navigate.parent_close, "Close directory" },
    ["l"] = { api.node.open.edit, "Open" },
    ["<CR>"] = { api.node.open.edit, "Open" },
    ["f"] = { api.live_filter.start, "Filter" },
    ["F"] = { api.live_filter.clear, "Clear filter" },
    ["tg"] = { telescope_live_grep, "Tree live grep" },
    ["tf"] = { telescope_find_files, "Tree find file" },
    ["H"] = { api.tree.toggle_hidden_filter, "Hide/Show dot files" },
  }

  for key, mappingInfo in pairs(key_tbl) do
    vim.keymap.set("n", key, mappingInfo[1], opts(mappingInfo[2]))
  end
end

local options = {
  on_attach = my_on_attach,
  filters = {
    dotfiles = true,  -- True = exclude dotfiles, weird!!!
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
  },
  git = {
    enable = false,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },

  live_filter = {
    prefix = " : ",
    always_show_folders = true,
  },

  renderer = {
    root_folder_label = false,
    highlight_git = false,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },

      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}

return options
