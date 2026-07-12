local treesitter = require("nvim-treesitter")

treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

local ts_ensure_installed = {
    "lua",
    "python",
    "bash",
    "zsh",
    "typescript",
    "clojure",
    "markdown",
    "kdl",
    "zsh",
}

local has_treesitter_cli = vim.fn.executable("tree-sitter") == 1

-- baseline auto-install
if has_treesitter_cli then
    treesitter.install(ts_ensure_installed)
else
    vim.notify("treesitter: tree-sitter CLI not found, skipping baseline parser install", vim.log.levels.WARN)
end

for _, parser in ipairs(ts_ensure_installed) do
    vim.treesitter.language.register(parser, parser)
    vim.api.nvim_create_autocmd("FileType", {
        pattern = parser,
        callback = function(event)
            vim.treesitter.start(event.buf, parser)
        end,
    })
end

-- auto-install parsers
vim.api.nvim_create_autocmd("BufRead", {
    callback = function(event)
        local bufnr = event.buf
        local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

        if filetype == "" then
            return
        end

        -- Skip if already handled by ts_ensure_installed
        if vim.tbl_contains(ts_ensure_installed, filetype) then
            return
        end

        local parser_name = vim.treesitter.language.get_lang(filetype)
        if not parser_name then
            return
        end

        local parser_configs = require("nvim-treesitter.parsers")
        if not parser_configs[parser_name] then
            return
        end

        local parser_installed = vim.treesitter.get_parser(bufnr, parser_name) ~= nil
        if not parser_installed then
            if not has_treesitter_cli then
                vim.notify(
                    "treesitter: tree-sitter CLI not found, skipping install of parser '" .. parser_name .. "'",
                    vim.log.levels.WARN
                )
                return
            end
            treesitter.install({ parser_name }):wait(30000)
        end

        parser_installed = vim.treesitter.get_parser(bufnr, parser_name) ~= nil

        if parser_installed then
            vim.treesitter.start(bufnr, parser_name)
        end
    end,
})

require("treesitter-context").setup({
    multiwindow = true,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        lookbehind = true,
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
