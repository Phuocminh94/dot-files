return {
  messages = {
    enabled = false,              -- enables the Noice messages UI
  },
  redirect = { enabled = false },
  notify = { enabled = false, view = "notify" },
  commands = {
    last = { enabled = false },
    error = { enabled = false },
  },
  lsp = {
    progress = { enabled = false },
    override = {
      enabled = false,
    },
    hover = {
      enabled = false,
    },
    signature = { enabled = false },
    documentation = {
      enabled = false,
    },
    message = {
      enabled = false,
    },
  },
  health = {
    checker = true, -- Disable if you don't want health checks to run
  },
  popupmenu = { enabled = false },
  cmdline = {
    enabled = true,         -- enables the Noice cmdline UI
    view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
    opts = {},              -- global options for the cmdline. See section on views
    ---@type table<string, CmdlineFormat>
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = "🔍 ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = "🔍 ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
      input = {}, -- Used by input()
    },
  },
}
