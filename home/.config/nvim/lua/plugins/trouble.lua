return {
    "folke/trouble.nvim",
    dependencies = { "nvim-mini/mini.nvim" },
    cmd = "Trouble",
    keys = {
        {
            "<Leader>td",
            "<Cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>",
            desc = "Diagnostics",
        },
        {
            "<Leader>tD",
            "<Cmd>Trouble major_diagnostics toggle focus=false<cr>",
            desc = "Workspace diagnostics",
        },
        {
            "<Leader>ts",
            "<Cmd>Trouble lsp_document_symbols toggle<cr>",
            desc = "Document symbols",
        },
        {
            "<Leader>tc",
            "<Cmd>Trouble lsp toggle<cr>",
            desc = "Refs, defs, decls, impls, types",
        },
        {
            "<Leader>tl",
            "<Cmd>Trouble loclist toggle<cr>",
            desc = "Location list",
        },
        {
            "<Leader>tq",
            "<Cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix list",
        },
        {
            "<Leader>fp",
            "<Cmd>Trouble fzf toggle<cr>",
            desc = "fzf file list",
        },
    },
    config = function()
        require("trouble").setup({
            warn_no_results = false,
            open_no_results = true,
            auto_follow = false,
            modes = {
                diagnostics = {
                    preview = {
                        type = "split",
                        relative = "win",
                        position = "right",
                        size = 0.5,
                    },
                    focus = false,
                },
                major_diagnostics = {
                    mode = "diagnostics",
                    filter = {
                        any = {
                            buf = 0, -- current buffer
                            {
                                severity = vim.diagnostic.severity.ERROR, -- errors only
                                -- filter out irrelevant diagnostics
                                function(item)
                                    local inCurrentProject = item.filename:find(vim.uv.cwd(), 1, true)
                                    local isNodeModules = item.filename:find("/node_modules/", 1, true)
                                    return inCurrentProject and not isNodeModules
                                end,
                            },
                        },
                    },
                    focus = false,
                },
                lsp_references = {},
                lsp_document_symbols = {
                    auto_refresh = true,
                    focus = false,
                    win = { position = "right" },
                },
                lsp = {
                    auto_refresh = false,
                    focus = false,
                    win = { position = "right" },
                },
            },
        })

        local config = require("fzf-lua.config")
        local actions = require("trouble.sources.fzf").actions
        config.defaults.actions.files["ctrl-t"] = actions.open
    end,
}
