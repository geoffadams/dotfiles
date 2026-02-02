require("mason").setup()
vim.lsp.enable("emmylua_ls")
vim.lsp.enable("basedpyright")
vim.lsp.config("bashls", {
    filetypes = { "bash", "sh", "zsh" },
})
vim.lsp.enable("bashls")
vim.lsp.enable("ts_ls")
vim.lsp.config("eslint", {
    settings = {
        workingDirectory = { mode = "location" },
    },
})
vim.lsp.enable("eslint")

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
        "typescript-language-server",
        "eslint-lsp",
    },
})

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff", "isort" },
        bash = { "beautysh" },
        sh = { "beautysh" },
        zsh = { "beautysh" },
        typescript = { lsp_format = "prefer" },
    },
})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({
            timeout_ms = 500,
            bufnr = args.buf,
            lsp_format = "fallback",
            filter = function(client)
                return client.name ~= "ts_ls"
            end,
        })
    end,
})
