local util = require("util")

require("mason").setup()
vim.lsp.enable("emmylua_ls")
vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            analysis = {
                autoImportCompletions = true,
            },
        },
    },
})
vim.lsp.enable("basedpyright")
vim.lsp.config("bashls", {
    filetypes = { "bash", "sh", "zsh" },
})
vim.lsp.enable("bashls")
vim.lsp.config("vtsls", {
    settings = {
        typescript = {
            inlayHints = {
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = true },
                variableNames = { enabled = true },
                variableTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
            },
            suggest = {
                completeFunctionCalls = true,
            },
            tsserver = {
                log = vim.fn.stdpath("state") .. "vtsls.log",
                experimental = {
                    enableProjectDiagnostics = true,
                },
            },
            updateImportsOnFileMove = { enabled = "always" },
        },
        vtsls = {
            autoUseWorkspaceTsdk = true,
        },
    },
})
vim.lsp.enable("vtsls")
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
        "vtsls",
        "eslint-lsp",
        "prettierd",
    },
})

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff", "isort" },
        bash = { "beautysh" },
        sh = { "beautysh" },
        zsh = { "beautysh" },
        typescript = { "prettierd", lsp_format = "fallback" },
        markdown = { "prettierd" },
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

local function enable_lsp_functionality(event)
    local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
    map("gra", vim.lsp.buf.code_action, "[G]oto Code [a]ction", { "n", "x" })
    map("grd", vim.lsp.buf.definition, "[G]oto [d]efinition")
    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight", event.buf) then
        util.lsp_highlight_autocmd({ "CursorHold", "CursorHoldI" }, event.buf, vim.lsp.buf.document_highlight)
        util.lsp_highlight_autocmd({ "CursorMoved", "CursorMovedI" }, event.buf, vim.lsp.buf.clear_references)

        function clear_highlights(buf)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = buf })
        end
        util.lsp_detach_autocmd(nil, function(ev)
            clear_highlights(ev.buf)
        end, "Clear highlights")
    end

    if client and client:supports_method("textDocument/inlayHint", event.buf) then
        map("<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "[T]oggle Inlay [H]ints")
    end
end
util.lsp_attach_autocmd(nil, enable_lsp_functionality, "Enable LSP functionality")
