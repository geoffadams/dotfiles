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
vim.lsp.enable("jsonls")
vim.lsp.enable("clojure_lsp")
vim.lsp.enable("marksman")
vim.lsp.config("markdown_oxide", {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = {
                dynamicRegistration = true,
            },
        },
    },
})
vim.lsp.enable("markdown_oxide")

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
        "json-lsp",
        "clojure-lsp",
        "cljfmt",
        "marksman",
        "markdown-oxide",
    },
})

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

local function enable_lsp_functionality(event)
    local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    map("<Leader>cn", vim.lsp.buf.rename, "Rename")
    map("<Leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
    map("<Leader>cd", vim.lsp.buf.definition, "Go to definition")
    map("<Leader>cD", vim.lsp.buf.declaration, "Go to declaration")
    map("<Leader>ci", vim.lsp.buf.implementation, "Go to implementation")
    map("<Leader>cr", vim.lsp.buf.references, "Show references")
    map("<Leader>ct", vim.lsp.buf.type_definition, "Type definition")

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
        end, "Toggle inlay hints")
    end
end
util.lsp_attach_autocmd(nil, enable_lsp_functionality, "Enable LSP functionality")
