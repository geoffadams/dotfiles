local get_venv_command = function(command)
    if vim.env.VIRTUAL_ENV then
        return vim.env.VIRTUAL_ENV .. "/bin/" .. command
    else
        return command
    end
end

local conform = require("conform")
conform.setup({
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
                return client.name ~= "vtsls" or client.name ~= "jsonls"
            end,
        }
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

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})
