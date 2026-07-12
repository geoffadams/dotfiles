return {
    "folke/trouble.nvim",
    dependencies = { "nvim-mini/mini.nvim" },
    cmd = "Trouble",
    keys = {
        {
            "<Leader>td",
            "<Cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Document diagnostics",
        },
        {
            "<Leader>tD",
            "<Cmd>Trouble major_diagnostics toggle<cr>",
            desc = "Workspace diagnostics",
        },
        {
            "<Leader>ts",
            "<Cmd>Trouble lsp_document_symbols toggle focus=false win.position=bottom<cr>",
            desc = "Document symbols",
        },
        {
            "<Leader>tc",
            "<Cmd>Trouble lsp toggle focus=false win.position=right<cr>",
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
            "<Leader>tf",
            "<Cmd>Trouble fzf toggle<cr>",
            desc = "fzf file list",
        },
    },
    config = function()
        local icons = require("mini.icons")
        icons.mock_nvim_web_devicons()

        require("trouble").setup({
            warn_no_results = false,
            open_no_results = true,
            modes = {
                diagnostics = {
                    preview = {
                        type = "split",
                        relative = "win",
                        position = "right",
                        size = 0.5,
                    },
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
                },
            },
        })

        local config = require("fzf-lua.config")
        local actions = require("trouble.sources.fzf").actions
        config.defaults.actions.files["ctrl-t"] = actions.open
    end,
}
