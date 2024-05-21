-- https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
return {
  settings = {
    pylsp = {
      plugins = {
        autopep8 = { enabled = false },
        pycodestyle = { enabled = false },
        mccabe = { enabled = false },
        flake8 = { enabled = true, ignore = { "W391", "F401", "E501", "F403" } },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        yapf = { enabled = false },
      },
    },
  },
}
