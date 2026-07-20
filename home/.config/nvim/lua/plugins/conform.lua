return {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
        local u = require("util")
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff", "isort" },
                bash = { "shfmt" },
                sh = { "shfmt" },
                zsh = { "shfmt" },
                typescript = { "prettierd", lsp_format = "fallback" },
                markdown = { "flowmark", "prettierd", lsp_format = "fallback" },
                json = { "prettierd", lsp_format = "fallback" },
                clojure = { "cljfmt" },
            },
            formatters = {
                prettierd = {
                    require_cwd = true,
                    cwd = require("conform.util").root_file({
                        ".prettierrc",
                        ".prettierrc.json",
                        ".prettierrc.yml",
                        ".prettierrc.yaml",
                        ".prettierrc.json5",
                        ".prettierrc.js",
                        ".prettierrc.cjs",
                        ".prettierrc.mjs",
                        ".prettierrc.toml",
                        "prettier.config.js",
                        "prettier.config.cjs",
                        "prettier.config.mjs",
                    }),
                },
                flowmark = {
                    command = u.get_venv_command("flowmark"),
                    args = { "-s" },
                    require_cwd = true,
                    cwd = require("conform.util").root_file({
                        "pyproject.toml",
                    }),
                },
            },
            format_on_save = function(bufnr)
                -- Disable with a global or buffer-local variable
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                    bufnr = bufnr,
                    filter = function(client)
                        return client.name ~= "vtsls" and client.name ~= "jsonls"
                    end,
                }
            end,
        })
    end,
}
