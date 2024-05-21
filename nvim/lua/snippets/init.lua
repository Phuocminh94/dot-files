-- NOTE:
-- + use <backspace> to get to normal mode and paste text in the placeholder.
-- + LaTeX, markdown, and lua are probably used the most.
-- + use <C-d> to change between choices. use <C-s> to exapand expandable nodes (or just use <Enter> when cmp is visible)
--https://www.ejmastnak.com/tutorials/vim-latex/luasnip/

local ls = require "luasnip"

local M = {}

M.s = ls.snippet
M.sn = ls.snippet_node
M.t = ls.text_node
M.i = ls.insert_node
M.f = ls.function_node
M.c = ls.choice_node
M.d = ls.dynamic_node
M.r = ls.restore_node
M.l = require("luasnip.extras").lambda
M.rep = require("luasnip.extras").rep
M.p = require("luasnip.extras").partial
M.m = require("luasnip.extras").match
M.n = require("luasnip.extras").nonempty
M.dl = require("luasnip.extras").dynamic_lambda
M.fmt = require("luasnip.extras.fmt").fmt
M.fmta = require("luasnip.extras.fmt").fmta
M.types = require "luasnip.util.types"
M.conds = require "luasnip.extras.conditions"
M.conds_expand = require "luasnip.extras.conditions.expand"
M.parser = ls.parser

-- some useful functions
M.copy = function(
  args,     -- text from i(2) in this example i.e. { { "456" } }
  parent,   -- parent snippet or parent node
  user_args -- user_args from opts.user_args
)
  return args[1][1]
end


return M
