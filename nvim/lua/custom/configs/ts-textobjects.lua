require 'nvim-treesitter.configs'.setup {
  textobjects = {
    select = {
      enable = true,
      include_surrounding_whitespace = true,
      keymaps = {
        ["a="] = "@assignment.outer",
        ["i="] = "@assignment.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",

        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",

        ["af"] = "@function.outer",
        ["if"] = "@function.inner",

        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
        ["]a"] = "@parameter.inner",
      },

      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
        ["]A"] = "@parameter.inner",
      },

      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[a"] = "@parameter.inner",
      },

      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
        ["[A"] = "@parameter.inner",
      },
    }
  }
}
