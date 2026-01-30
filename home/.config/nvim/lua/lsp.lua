require("mason").setup()
vim.lsp.enable("basedpyright")
vim.lsp.enable("emmylua_ls")
vim.lsp.config("bashls", {
  filetypes = {"bash", "sh", "zsh", ".zshrc", ".zshenv"}
})
vim.lsp.enable("bashls")
require("mason-tool-installer").setup({
    ensure_installed = {
        "emmylua_ls",
        "stylua",
        "selene",
        "basedpyright",
        "ruff",
        "isort",
        "bash-language-server",
        "beautysh",
    },
})
