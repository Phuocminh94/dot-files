local ls = require("snippets")
local c = ls.c
local f = ls.f
local fmt = ls.fmt
local fmta = ls.fmta
local i = ls.i
local s = ls.s
local t = ls.t
local d = ls.d
local sn = ls.sn
local parser = ls.parser
local l = ls.l
local copy = ls.copy

return {
  s(
    { trig = "kbd", dscr = "html keyboard" },
    fmt(
      [[
      <kbd>{}</kbd>
    ]],
      {
        i(1)
      }
    )
  ),

  s(
    { trig = "mat", dscr = "Insert matrix" },
    fmt(
      [[
      \begin{{{}{}}}
        {}
      \end{{{}}}
      ]],
      {
        i(1, "p/b/v/V/B/small"),
        l(l._1:gsub(l._1, "matrix"), 1),
        i(2),
        l(l._1 .. "matrix", 1),
      }
    )
  ),

  s({ trig = "m", dscr = "Expand $ into '$' or '$$'" }, {
    i(0),
    c(1, {
      fmt("${}$", { i(1) }),
      fmt("$${}$$", { i(1) }),
    }),
  }),
  -- Greek letter snippets, autotriggered for efficiency
  s({ trig = ",a" }, { t("\\alpha") }),
  s({ trig = ",bt" }, { t("\\beta") }),
  s({ trig = ",c" }, { t("\\chi") }),
  s({ trig = ",d" }, { t("\\delta") }),
  s({ trig = ",g" }, { t("\\gamma") }),
  s({ trig = ",s" }, { t("\\sigma") }),
  s({ trig = ",t" }, { t("\\theta") }),

  s(
    { trig = "begin", dscr = "Begin an environment" },
    fmt(
      [[
          \begin{{{}}}
            {}
          \end{{{}}}
        ]],
      { i(1), i(2), f(copy, { 1 }) }
    )
  ),

  -- \texttt
  s({ trig = "tt", dscr = "Insert typewritter text" }, fmta("\\texttt{<>}", { i(1) })),

  -- \textit
  s({ trig = "it", dscr = "Insert  italic text" }, fmta("\\textit{<>}", { i(1, "text") })),

  -- \textbf
  s({ trig = "bf", dscr = "Insert bold text" }, fmta("\\textbf{<>}", { i(1, "text") })),

  -- \textbf
  s({ trig = "em", dscr = "Emphasize text" }, fmta("\\emph{<>}", { i(1, "text") })),

  -- \mathbf
  s({ trig = "mbf", dscr = "Math bold font" }, fmta("\\mathbf{<>}", { i(1, "text") })),

  -- \superscript
  s({ trig = "**", dscr = "Superscript" }, fmta("^{<>}", { i(1) })),

  -- \hat
  s({ trig = "^", dscr = "Hat" }, fmta("\\hat{<>}", { i(1) })),

  -- \vector
  s({ trig = "->", dscr = "Vector overhead" }, fmta("\\vec{<>}", { i(1) })),

  -- \frac
  s(
    { trig = "fractioninline", dscr = "Insert inline fraction notation" },
    fmt(
      "\\frac{<>}{<>}",
      {
        i(1),
        i(2),
      },
      { delimiters = "<>" } -- manually specifying angle bracket delimiters
    )
  ),
  s(
    { trig = "fractionlarge", dscr = "Expands 'ff' into '\frac{}{}'" },
    fmt(
      "\\displaystyle\\frac{<>}{<>}",
      {
        i(1),
        i(2),
      },
      { delimiters = "<>" } -- manually specifying angle bracket delimiters
    )
  ),
}
