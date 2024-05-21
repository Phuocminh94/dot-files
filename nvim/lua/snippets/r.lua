local ls = require "snippets"
local c = ls.c
local fmt = ls.fmt
local i = ls.i
local s = ls.s

return {
  s(
    { trig = "var", "Variable" },
    c(1, {
      fmt("{} <- {}", { i(1, "name"), i(2, "value") }),
      fmt("{} = {}", { i(1, "name"), i(2, "value") }),
    })
  ),
  s(
    { trig = "func", "create function" },
    c(1, {
      fmt(
        [[
          {} <- function({}){{
            {}
          }}
        ]],
        { i(1, "name"), i(2, ""), i(3, "your code here") }
      ),
      fmt(
        [[
          {} <- function({}){{
            {}
            return {}
          }}
        ]],
        { i(1, "name"), i(2, ""), i(3, "your code here"), i(4, "value") }
      ),
    })
  ),
}
