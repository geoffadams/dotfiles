require("mason").setup()
vim.lsp.enable("basedpyright")
vim.lsp.enable("emmylua_ls")
vim.lsp.config("bashls", {
    filetypes = { "bash", "sh", "zsh" },
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

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff", "isort" },
        bash = { "beautysh" },
        sh = { "beautysh" },
        zsh = { "beautysh" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})
