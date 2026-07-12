return {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    config = function()
        require("nvim-treesitter-textobjects").setup({
            select = {
                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = false,
                lookbehind = false,
                selection_modes = {
                    ["@parameter.outer"] = "v",
                    ["@function.outer"] = "v",
                    ["@local.scope"] = "v",
                    ["@class.outer"] = "V",
                },
            },
        })

        local u = require("util")
        local ts_select = require("nvim-treesitter-textobjects.select")
        local function keymap_textobject(lhs_suffix, textobject, scope)
            local fq_textobject = "@" .. textobject
            local desc = textobject .. " 🌳"
            u.keymap({ "x", "o" }, "a" .. lhs_suffix, function()
                ts_select.select_textobject(fq_textobject .. ".outer", scope)
            end, desc)
            u.keymap({ "x", "o" }, "i" .. lhs_suffix, function()
                ts_select.select_textobject(fq_textobject .. ".inner", scope)
            end, desc)
        end
        local function keymap_scope(lhs_suffix, textobject, scope)
            local fq_textobject = "@" .. textobject
            local desc = textobject .. " scope 🌳"
            u.keymap({ "x", "o" }, "a" .. lhs_suffix, function()
                ts_select.select_textobject(fq_textobject .. ".scope", scope)
            end, desc)
        end

        keymap_textobject("m", "function", "textobjects")
        keymap_textobject("c", "class", "textobjects")
        keymap_scope("s", "local", "locals")
    end,
}
