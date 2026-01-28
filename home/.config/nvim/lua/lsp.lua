require("mason").setup()
vim.lsp.enable("basedpyright")
vim.lsp.enable("emmylua_ls")
vim.lsp.config("bashls", {
  filetypes = {"bash", "sh", "zsh", ".zshrc", ".zshenv"}
})
vim.lsp.enable("bashls")
