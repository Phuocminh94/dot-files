local ls = require "snippets"
local c = ls.c
local fmt = ls.fmt
local i = ls.i
local s = ls.s

return {
  s(
    { trig = "var", "Variable" },
    c(1, {
      fmt("var {} = {};", { i(1, "name"), i(2, "value") }),
      fmt("const {} = {};", { i(1, "name"), i(2, "value") }),
      fmt("let {} = {};", { i(1, "name"), i(2, "value") }),
    })
  ),
}
