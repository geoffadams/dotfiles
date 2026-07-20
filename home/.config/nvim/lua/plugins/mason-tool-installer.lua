return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
        "mason-org/mason.nvim",
    },
    event = "VeryLazy",
    config = function()
        require("mason-tool-installer").setup({
            ensure_installed = {
                "emmylua_ls",
                "stylua",
                "selene",
                "basedpyright",
                "ruff",
                "isort",
                "bash-language-server",
                "shfmt",
                "vtsls",
                "eslint-lsp",
                "prettierd",
                "json-lsp",
                "clojure-lsp",
                "cljfmt",
                "marksman",
                "ansible-language-server",
                "tombi",
            },
        })
    end,
}
