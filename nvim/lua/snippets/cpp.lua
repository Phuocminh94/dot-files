local ls = require("snippets")
local c = ls.c
local fmt = ls.fmt
local i = ls.i
local s = ls.s

return {
  -- function
  s(
    { trig = "func", dscr = "function" },
    c(1, {
      fmt(
        [[
          {} {} ({}){{
            {};
            return {};
          }}
        ]],
        {
          i(1, "type_func"),
          i(2, "name"),
          i(3, ""),
          i(4, "your code here"),
          i(5, "value"),
        }
      ),

      fmt( -- function without return
        [[
          {} {} ({}){{
            {};
          }}
        ]],
        { i(1, "type_func"), i(2, "name"), i(3, ""), i(4, "your code here") }
      ),
    })
  ),

  -- import
  s({ trig = "#", dscr = "import" }, fmt("#include <{}>", { i(1, "package") })),

  -- var
  s({ trig = "var", dscr = "variable" }, fmt("{}{} = {}", { i(0, ""), i(1, "name"), i(2, "value") })),
}
