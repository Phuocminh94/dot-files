local options = {
  ensure_installed = vim.g.ts_binaries_list or {},
  auto_install = false,
  highlight = {
    enable = true,
    use_languagetree = true,
    disable = function(lang, bufnr) -- Disable in files with more than 5K
      return vim.api.nvim_buf_line_count(bufnr) > 5000
    end,
  },

  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-Space>",
      node_incremental = "<TAB>",
      node_decremental = '<BS>'
    },
  },
}

return options
