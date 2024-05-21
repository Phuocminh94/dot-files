--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function _G.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- highlights URLs in the current buffer using the "HighlightURL" highlight group.
function _G.matchURL()
  --- Regex used for matching a valid URL/URI string
  local url_matcher =
  "\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"
  for _, match in ipairs(vim.fn.getmatches()) do
    if match.group == "HighlightURL" then
      vim.fn.matchdelete(match.id)
    end
  end
  if vim.g.highlighturl_enabled then
    vim.fn.matchadd("HighlightURL", url_matcher, 15)
  end
end

--- Pretty print a Lua table using vim.inspect and print it to the console.
---@param tb (table) The Lua table to be pretty printed.
---@return (table) The input table, unchanged.
function _G.pprint(tb)
  vim.print(tb)
  return tb
end

--- Move to the next closed fold in the specified direction.
--- @param direction string: The direction to move. 'zO' to open folds, 'zc' to close folds.
--https://stackoverflow.com/questions/9403098/is-it-possible-to-jump-to-the-next-closed-fold-in-vim
function next_closed_fold(direction)
  local cmd = "norm! z" .. direction

  -- Save the current view information
  local view = vim.fn.winsaveview()

  -- Initialize variables to track the current and previous line numbers, and the fold state
  local l0, l, open = 0, view.lnum, true

  -- Loop until reaching the same line or an open fold is encountered
  while l ~= l0 and open do
    -- Execute the normal mode command
    vim.cmd(cmd)

    -- Update line numbers and check the fold state
    l0, l = l, vim.fn.line(".")
    open = vim.fn.foldclosed(l) < 0
  end

  -- If an open fold was encountered, restore the previous view
  if open then
    vim.fn.winrestview(view)
  end
end

--- Create a commented line with a custom message.
---@param length (number) The desired length of the comment line. Defaults to 90.
function _G.comment(length)
  local length = length or 90
  local message = vim.fn.input("Enter the custom message: ")
  local padding = length - #message

  local result = nil
  if padding > 0 then
    local leftPadding = math.floor(padding / 2)
    local rightPadding = padding - leftPadding
    result = string.rep("-", leftPadding) .. message .. string.rep("-", rightPadding)
  else
    result = string.sub(message, 1, length)
  end

  vim.fn.setreg('"', result) -- Copy the result to the unnamed register (clipboard)
  vim.cmd('normal! ""p')     -- Paste the result
end

-- Define the function to align columns
function _G.align()
  local p = "^%s*|%s.*%s|%s*$"
  if
      vim.fn.exists(":Tabularize") == 1
      and vim.fn.matchstr(vim.fn.getline("."), "^s*|") ~= -1
      and (
        vim.fn.matchstr(vim.fn.getline(vim.fn.line(".") - 1), p) ~= -1
        or vim.fn.matchstr(vim.fn.getline(vim.fn.line(".") + 1), p) ~= -1
      )
  then
    local column = string.len(vim.fn.substitute(vim.fn.getline(".", ".", true), "[^|]", "", "g"))
    local position = string.len(vim.fn.matchstr(vim.fn.getline(".", ".", true), ".*|\\s*\\zs.*"))
    vim.cmd("Tabularize/|/l1")
    vim.cmd("normal! 0")
    vim.fn.search(string.rep("[^|]*|", column) .. "\\s\\{-\\}" .. string.rep(".", position), "ce", vim.fn.line("."))
  end
end
