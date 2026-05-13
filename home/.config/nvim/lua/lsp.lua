local u = require("util")

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
        -- workingDirectory = { mode = "location" },
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

vim.lsp.enable("ansiblels")

local function enable_lsp_functionality(event)
    u.keymap_buf("n", "grn", vim.lsp.buf.rename, "Rename", event.buf)
    u.keymap_buf({ "n", "x" }, "gra", vim.lsp.buf.code_action, "Code action", event.buf)
    u.keymap_buf("n", "grd", vim.lsp.buf.definition, "Go to definition", event.buf)
    u.keymap_buf("n", "grD", vim.lsp.buf.declaration, "Go to declaration", event.buf)
    u.keymap_buf("n", "gri", vim.lsp.buf.implementation, "Go to implementation", event.buf)
    u.keymap_buf("n", "grr", vim.lsp.buf.references, "Show references", event.buf)
    u.keymap_buf("n", "grt", vim.lsp.buf.type_definition, "Type definition", event.buf)
    u.keymap_buf("n", "grx", vim.lsp.codelens.run, "Codelens", event.buf)
    u.keymap_buf("n", "gO", vim.lsp.buf.document_symbol, "Document symbols", event.buf)

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/documentHighlight", event.buf) then
        u.lsp_highlight_autocmd({ "CursorHold", "CursorHoldI" }, event.buf, vim.lsp.buf.document_highlight)
        u.lsp_highlight_autocmd({ "CursorMoved", "CursorMovedI" }, event.buf, vim.lsp.buf.clear_references)

        function clear_highlights(buf)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = buf })
        end
        u.lsp_detach_autocmd(nil, function(ev)
            clear_highlights(ev.buf)
        end, "Clear highlights")
    end

    if client and client:supports_method("textDocument/inlayHint", event.buf) then
        u.keymap_buf("n", "<leader>vh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "Toggle inlay hints", event.buf)
    end
end
u.lsp_attach_autocmd(nil, enable_lsp_functionality, "Enable LSP functionality")
