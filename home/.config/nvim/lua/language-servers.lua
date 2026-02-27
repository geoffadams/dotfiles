local util = require("util")

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
                log = vim.fn.stdpath("state") .. "/lsp/vtsls.log",
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

local function enable_lsp_functionality(event)
    local map = function(keys, func, desc, mode)
        mode = mode or "n"
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    -- all defaults...
    map("grn", vim.lsp.buf.rename, "Rename")
    map("gra", vim.lsp.buf.code_action, "Code action", { "n", "x" })
    map("grd", vim.lsp.buf.definition, "Go to definition")
    map("grD", vim.lsp.buf.declaration, "Go to declaration")
    map("gri", vim.lsp.buf.implementation, "Go to implementation")
    map("grr", vim.lsp.buf.references, "Show references")
    map("grt", vim.lsp.buf.type_definition, "Type definition")
    map("gO", vim.lsp.buf.document_symbol, "Document symbols")

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
