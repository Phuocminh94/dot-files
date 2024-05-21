return {
  settings = {
    pyright = { autoImportCompletion = true, }, -- auto import from other files in workspace
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "standard",
      }
    }
  }
}
