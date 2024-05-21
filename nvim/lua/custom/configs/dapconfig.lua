local dap = require "dap"
local dapui = require "dapui"

require("mason-nvim-dap").setup {
  automatic_setup = true,

  -- see mason-nvim-dap README for more information
  handlers = {},

  ensure_installed = vim.g.dap_list,
}

-- Dap UI setup
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn" })

-- For more information, see |:help nvim-dap-ui|
dapui.setup {
  -- Set icons to characters that are more likely to work in every terminal.
  --    Feel free to remove or use ones that you like more! :)
  --    Don't feel like these are good choices.
  icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
  controls = {
    icons = {
      pause = " ",
      play = " ",
      step_into = " ",
      step_over = " ",
      step_out = " ",
      step_back = " ",
      run_last = " ",
      terminate = " ",
      disconnect = " ",
    },
  },
}

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close
