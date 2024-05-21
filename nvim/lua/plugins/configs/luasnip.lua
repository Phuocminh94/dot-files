return function(opts)
  require("luasnip").config.set_config(opts)

  -- vscode format
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

  -- snipmate format
  require("luasnip.loaders.from_snipmate").load()
  require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

  -- lua format
  require("luasnip.loaders.from_lua").load()
  require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

  -- load custom snippets
  local ok, _ = pcall(require, vim.g.lua_snippets_path)
  local _, neotab = pcall(require, "neotab")

  -- set keymaps
  local _, ls = pcall(require, "luasnip")
  vim.keymap.set({ "i" }, "<C-s>", function()
    ls.expand()
  end, { silent = true }) -- mnemonic: show
  vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if ls.jumpable(1) then
      ls.jump(1)
    else
      neotab.tabout()
    end
  end, { silent = true })
  vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    ls.jump(-1)
  end, { silent = true })
  vim.keymap.set({ "i", "s" }, "<C-a>", function() -- down
    if ls.choice_active() then
      ls.change_choice(1)
    end
  end, { silent = true })

  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      if
          require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
          and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end
