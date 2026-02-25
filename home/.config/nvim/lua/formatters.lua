local get_venv_command = function(command)
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. "/bin/" .. command
    else
        return command
    end
end

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff", "isort" },
        bash = { "beautysh" },
        sh = { "beautysh" },
        zsh = { "beautysh" },
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
            command = get_venv_command("flowmark"),
            args = { "-s" },
            require_cwd = true,
            cwd = require("conform.util").root_file({
                "pyproject.toml",
            }),
        },
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
                return client.name ~= "vtsls"
            end,
        })
    end,
})
vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })
