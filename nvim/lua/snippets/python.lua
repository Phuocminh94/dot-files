local ls = require "snippets"
local c = ls.c
local fmt = ls.fmt
local i = ls.i
local s = ls.s

return {
  s(
    "im",
    c(1, {
      fmt("import {} as {}", { i(1), i(2) }),
      fmt("from {} import {} as {}", { i(1), i(2), i(3) }),
      fmt("from {} import {}", { i(1), i(2) }),
      fmt("import {}", { i(1) }),
      fmt("from {} import *", { i(1) }),
    })
  )
}
