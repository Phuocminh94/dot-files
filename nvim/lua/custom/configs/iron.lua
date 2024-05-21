return {
  config = {
    scratch_repl = true,
    repl_open_cmd = require("iron.view").right(40, 5),
    repl_definition = {
      python = {
        command = { "ipython" },
        format = require("iron.fts.common").bracketed_paste, -- send whole chunk to a single cell.
      },
    },
  },
  highlight = {
    italic = true,
  },
  ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
  keymaps = {
    -- others will be defined in custom.mappings
    interrupt = "<space>s<space>",
    cr = "<space>s<cr>",
    exit = "<space>sq",
    clear = "<space>sc",
  },
}
