local conform = require "conform"
local sources = vim.g.conform_list
local util = require "conform.util"

require("conform").setup {
          formatters_by_ft = sources,
}
