local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new {
  cmd = "lazygit",
  direction = "float",
  hidden = true,
  float_opts = {
    height = 35,
    width = 150,
  },
}
function _lazygit_toggle()
  lazygit:toggle()
end
vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

local ipython = Terminal:new {
  cmd = "ipython",
  direction = "vertical",
  hidden = true,
}
function _ipython_toggle()
  ipython:toggle()
end
vim.api.nvim_set_keymap("n", "<A-p>", "<cmd>lua _ipython_toggle()<CR>", { noremap = true, silent = true })


return {
  size = function(term)
    if term.direction == "vertical" then
      return vim.o.columns * 0.3
    elseif term.direction == "horizontal" then
      return 12
    end
  end,

  float_opts = {
    width = 90,
    height = 20,
    title_pos = "center",
  },
}
