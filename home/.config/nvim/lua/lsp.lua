require("mason").setup()
vim.lsp.enable("emmylua_ls")
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
                log = "/Users/geoff.adams/.local/state/nvim/lsp/vtsls.log",
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

vim.api.nvim_create_autocmd("LspAttach", {
    desc = "Enable inlay hints",
    callback = function(event)
        local id = vim.tbl_get(event, "data", "client_id")
        local client = id and vim.lsp.get_client_by_id(id)
        if client == nil or not client.supports_method("textDocument/inlayHint") then
            return
        end

        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end,
})

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
                return client.name ~= "vtsls"
            end,
        })
    end,
})
