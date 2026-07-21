return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-mini/mini.nvim" },
    event = "VeryLazy",
    cmd = "FzfLua",
    keys = {
        { "<C-p>", [[<Cmd>lua require"fzf-lua".global()<CR>]], desc = "Global picker" },
        { "<C-S-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], desc = "Files" },
        { mode = { "n", "i" }, "<C-f>", [[<Cmd>lua require"fzf-lua".live_grep({resume = true})<CR>]], desc = "Search" },
        {
            mode = { "n", "i" },
            "<C-S-f>",
            [[<Cmd>lua require"fzf-lua".grep_cword()<CR>]],
            desc = "Search current word",
        },
        {
            mode = { "x" },
            "<C-S-f>",
            [[<Cmd>lua require"fzf-lua".grep_visual()<CR>]],
            desc = "Search visual selection",
        },

        { "<C-F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], desc = "Help tags" },
        { "<Leader>fp", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], desc = "Pickers" },
        { "<Leader>fk", [[<Cmd>lua require"fzf-lua".keymaps()<CR>]], desc = "Keymaps" },

        { "<Leader>fa", [[<Cmd>lua require"fzf-lua".lsp_code_actions()<CR>]], desc = "Code actions" },
        {
            "<Leader>fl",
            [[<Cmd>lua require"fzf-lua".lsp_finder()<CR>]],
            desc = "LSP definitions, declarations & references",
        },

        { "<Leader>fs", [[<Cmd>lua require"fzf-lua".lsp_document_symbols()<CR>]], desc = "Document symbols" },
        { "<Leader>fS", [[<Cmd>lua require"fzf-lua".lsp_workspace_symbols()<CR>]], desc = "Workspace symbols" },

        { "<Leader>fd", [[<Cmd>lua require"fzf-lua".lsp_document_diagnostics()<CR>]], desc = "Document diagnostics" },
        { "<Leader>fD", [[<Cmd>lua require"fzf-lua".lsp_workspace_diagnostics()<CR>]], desc = "Workspace diagnostics" },

        { "<Leader>fq", [[<Cmd>lua require"fzf-lua".quickfix()<CR>]], desc = "Quickfix" },

        {
            "<Leader>fh",
            function()
                require("fzf-lua").combine({ pickers = { "git_branches", "git_tags", "git_stash" } })
            end,
            desc = "Git refs (branches, tags, stash)",
        },

        { "<Leader>fu", [[<Cmd>lua require"fzf-lua".undotree()<CR>]], desc = "Undotree" },
    },
    config = function()
        local fzf = require("fzf-lua")
        ---@module "fzf-lua"
        ---@type fzf-lua.Config|{}
        ---@diagnostic disable: missing-fields
        local opts = {
            winopts = {
                preview = { default = "bat_native" },
            },
            defaults = {
                formatter = "path.filename_first",
                git_icons = true,
            },
            buffers = {
                winopts = {
                    preview = {
                        hidden = true,
                    },
                },
            },
            grep = {
                RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH,
            },
            lsp = {
                finder = {
                    winopts = {
                        height = 0.5,
                        width = 0.5,
                        row = 0.5,
                        col = 0.5,
                        preview = {
                            vertical = "down:60%",
                            layout = "vertical",
                        },
                    },
                },
                code_actions = {
                    previewer = "codeaction_native",
                    preview_pager = [[delta --width=$COLUMNS --hunk-header-style="omit" --file-style="omit"]],
                },
            },
        }
        ---@diagnostic enable: missing-fields
        fzf.setup(opts)

        require("fzf-lua").register_ui_select(function(ui_opts, items)
            local function clamp(val, min, max)
                if val < min then
                    return min
                elseif val > max then
                    return max
                else
                    return val
                end
            end
            local function to_percentage(val, total)
                return math.floor(0.5 + ((val / total) * 100))
            end
            local function to_ratio_h(lines, total)
                if total == nil then
                    total = vim.o.lines
                end
                return lines / total
            end
            local function to_ratio_w(columns, total)
                if total == nil then
                    total = vim.o.columns
                end
                return columns / total
            end
            local function to_lines(ratio, total)
                if total == nil then
                    total = vim.o.lines
                end
                return math.ceil(ratio * total)
            end
            local function to_columns(ratio, total)
                if total == nil then
                    total = vim.o.columns
                end
                return math.ceil(ratio * total)
            end

            local min_h, max_h = 0.15, 0.70
            local listui_h_pad = 2
            local preview_h_pad = 0

            local min_w, max_w = 0.20, 0.70
            local listui_w_pad = 9
            local preview_w_pad = 0

            if ui_opts.kind == "codeaction" then
                preview_h_pad = 20
                preview_w_pad = 10
                min_w = 0.5
            end

            local min_h_lines = to_lines(min_h)
            local max_h_lines = to_lines(max_h)
            local h_lines = clamp(#items + listui_h_pad + preview_h_pad, min_h_lines, max_h_lines)

            local longest_w = 0
            for _, e in ipairs(items) do
                local format_entry = ui_opts.format_item and ui_opts.format_item(e) or tostring(e)
                longest_w = math.max(tostring(format_entry):len(), longest_w)
            end

            local min_w_cols = to_columns(min_w)
            local max_w_cols = to_columns(max_w)
            local w_cols = clamp(longest_w + listui_w_pad + preview_w_pad, min_w_cols, max_w_cols)

            return {
                winopts = {
                    height = to_ratio_h(h_lines),
                    width = to_ratio_w(w_cols),
                    row = 0.5,
                    col = 0.5,
                    preview = {
                        vertical = "down:" .. to_percentage(preview_h_pad, h_lines) .. "%",
                        layout = "vertical",
                    },
                },
                fzf_opts = {
                    ["--layout"] = "reverse-list",
                    ["--info"] = "hidden",
                },
            }
        end)
    end,
}
