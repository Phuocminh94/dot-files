require "custom.options"
require "custom.globals"
require "custom.autocmds"
require "custom.usercmd"

-- load extended colorshemes
local extended_base46_files = require("core.utils").load_config().ui.extended_integrations
for _, file in ipairs(extended_base46_files) do
  local file_path = vim.g.base46_cache .. file
  if vim.fn.filereadable(file_path) == 1 then
    dofile(file_path)
  else
    print(string.format("Error: base46 %s not found or not readable.", file))
  end
end

-- go to i-buf keybinds
for i = 1, 9, 1 do
  vim.keymap.set("n", string.format("<M-%s>", i), function()
    vim.api.nvim_set_current_buf(vim.t.bufs[i])
  end)
end
