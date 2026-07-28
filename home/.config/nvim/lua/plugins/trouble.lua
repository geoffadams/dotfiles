return {
    "folke/trouble.nvim",
    dependencies = { "nvim-mini/mini.nvim" },
    cmd = "Trouble",
    keys = {
        {
            "<Leader>dd",
            "<Cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>",
            desc = "Diagnostics",
        },
        {
            "<Leader>dD",
            "<Cmd>Trouble major_diagnostics toggle focus=false<cr>",
            desc = "Workspace diagnostics",
        },
        {
            "<Leader>ra",
            "<Cmd>Trouble lsp toggle<cr>",
            desc = "Symbol details",
        },
        {
            "<Leader>rd",
            "<Cmd>Trouble lsp_definitions toggle<CR>",
            desc = "Definitions",
        },
        {
            "<Leader>rD",
            "<Cmd>Trouble lsp_declarations toggle<CR>",
            desc = "Declarations",
        },
        {
            "<Leader>ri",
            "<Cmd>Trouble lsp_implementations toggle<CR>",
            desc = "Implementations",
        },
        {
            "<Leader>rr",
            "<Cmd>Trouble lsp_references toggle<CR>",
            desc = "References",
        },
        {
            "<Leader>rt",
            "<Cmd>Trouble lsp_type_definitions toggle<CR>",
            desc = "Type definitions",
        },
        {
            "<Leader>rO",
            "<Cmd>Trouble lsp_document_symbols toggle<cr>",
            desc = "Document symbols",
        },
        {
            "<Leader>vl",
            "<Cmd>Trouble loclist toggle<cr>",
            desc = "Location list",
        },
        {
            "<Leader>vq",
            "<Cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix list",
        },
        {
            "<Leader>vf",
            "<Cmd>Trouble fzf toggle<cr>",
            desc = "fzf file list",
        },
    },
    config = function()
        require("trouble").setup({
            warn_no_results = true,
            open_no_results = false,
            auto_follow = false,
            preview = {
                type = "float",
                relative = "win",
                anchor = "SW",
                border = "rounded",
                title = "Preview",
                title_pos = "center",
                position = { 0, 0 },
                size = { width = 1, height = 1 },
                zindex = 200,
            },
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
                lsp_base = {
                    auto_refresh = false,
                    focus = false,
                    win = { position = "bottom" },
                },
                lsp_declaration = {
                    auto_jump = true,
                },
                lsp_definition = {
                    auto_jump = true,
                },
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
