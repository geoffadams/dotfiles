local u = require("util")
local devcontainers = require("devcontainers")

local in_docker_container = vim.uv.fs_stat("/.dockerenv") ~= nil

--- Ensure `bin` is on PATH inside the devcontainer for root_dir, installing
--- `npm_package` globally if it's missing.
---@param bin string
---@param npm_package string
---@return fun(config: vim.lsp.ClientConfig)
local function ensure_installed_in_container(bin, npm_package)
    return function(config)
        local cli = require("devcontainers.cli")
        local handle = require("fidget.progress").handle.create({
            title = bin,
            message = "Checking...",
            lsp_client = { name = "devcontainers" },
        })

        local has_bin = pcall(cli.exec, config.root_dir, { "sh", "-c", "command -v " .. bin })

        if has_bin then
            handle.message = "Found"
        else
            handle.message = "Installing..."
            cli.exec(config.root_dir, { "npm", "install", "-g", npm_package })
            handle.message = "Installed"
        end
        handle:finish()
    end
end

local function devcontainer_lsp_cmd(cmd, bin, npm_package)
    if not in_docker_container then
        return cmd
    end
    return devcontainers.lsp_cmd(cmd, {
        before_start = ensure_installed_in_container(bin, npm_package),
    })
end

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
vim.lsp.enable("bashls")
vim.lsp.config("vtsls", {
    -- run inside the project's devcontainer, if it has one
    cmd = devcontainer_lsp_cmd({ "vtsls", "--stdio" }, "vtsls", "@vtsls/language-server"),
    -- general config
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
    cmd = devcontainer_lsp_cmd(
        { "vscode-eslint-language-server", "--stdio" },
        "vscode-eslint-language-server",
        "vscode-langservers-extracted"
    ),
    settings = {
        -- workingDirectory = { mode = "location" },
    },
})
vim.lsp.enable("eslint")
vim.lsp.enable("jsonls")
vim.lsp.enable("clojure_lsp")
vim.lsp.enable("marksman")
vim.lsp.enable("ansiblels")
vim.lsp.enable("tombi")

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
    u.keymap_buf({ "n", "i" }, "<C-S-/>", vim.lsp.buf.signature_help, "Signature info", event.buf)
    u.keymap_buf({ "n", "i" }, "<C-S-.>", vim.lsp.buf.hover, "Symbol info", event.buf)
    u.keymap_buf("n", "K", vim.lsp.buf.hover, "Symbol info", event.buf)

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
