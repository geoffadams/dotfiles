return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
        local u = require("util")
        ---@type gitsigns.main
        local gitsigns = require("gitsigns")
        gitsigns.setup({
            current_line_blame_opts = {
                virt_text_pos = "right_align",
            },
            on_attach = function(bufnr)
                -- motions
                u.keymap_buf("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, "Next hunk", bufnr)

                u.keymap_buf("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, "Previous hunk", bufnr)

                u.keymap_buf({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk", bufnr)

                -- operations
                u.keymap_buf("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk", bufnr)
                u.keymap_buf("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk", bufnr)

                u.keymap_buf("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage range", bufnr)
                u.keymap_buf("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset range", bufnr)

                u.keymap_buf("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer", bufnr)
                u.keymap_buf("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer", bufnr)

                -- preview
                u.keymap_buf("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, "Blame (line)", bufnr)
                u.keymap_buf("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk", bufnr)
                u.keymap_buf("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview hunk inline", bufnr)

                -- quickfix
                u.keymap_buf("n", "<leader>hq", gitsigns.setqflist, "Quickfix buffer hunks", bufnr)
                u.keymap_buf("n", "<leader>hQ", function()
                    gitsigns.setqflist("all")
                end, "Quickfix workspace hunks", bufnr)

                -- buffer views
                u.keymap_buf("n", "<leader>vb", gitsigns.toggle_current_line_blame, "Toggle blame", bufnr)
                u.keymap_buf("n", "<leader>vw", gitsigns.toggle_word_diff, "Toggle word diffs", bufnr)
            end,
        })
    end,
}
