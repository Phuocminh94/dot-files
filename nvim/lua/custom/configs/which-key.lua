return {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },

    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = false,
      nav = false,
      z = false,
      g = false,
    }
  },

  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label.
  triggers = {"z", "'", '"', "`"},          -- do not automatically setup triggers. use <leader>wk to query desired keys.
}
