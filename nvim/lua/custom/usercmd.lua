---@diagnostic disable: need-check-nil
local create_cmd = vim.api.nvim_create_user_command
local g = vim.g
local fn = vim.fn

-- ----------------- yank path, full path, last messages -----------------
local function yank_file_path(expr)
  fn.setreg("+", fn.expand(expr))
  vim.notify("Yanked file path: " .. fn.getreg("+"))
end

create_cmd("YankPath", function()
  yank_file_path("%")
end, { desc = "Yank current file's path relative to cwd" })

create_cmd("YankPathFull", function()
  yank_file_path("%:~")
end, { desc = "Yank current file's absolute path" })

local function getLatestMessages(count)
  local messages = vim.fn.execute("messages")
  local lines = vim.split(messages, "\n")
  lines = vim.tbl_filter(function(line)
    return line ~= ""
  end, lines)
  count = count and tonumber(count) or nil
  count = (count ~= nil and count > 0) and count - 1 or #lines
  return table.concat(vim.list_slice(lines, #lines - count), "\n")
end

local function yankMessages(register, count)
  local default_register = "+"
  register = (register and register ~= "") and register or default_register
  vim.fn.setreg(register, getLatestMessages(count), "l")
end

create_cmd("YankMessages", function(opts)
  return yankMessages(opts.reg, opts.count)
end, { count = 10, register = true })
