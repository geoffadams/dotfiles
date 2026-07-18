local u = require("util")
local treesitter = require("nvim-treesitter")

treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})
local has_treesitter_cli = vim.fn.executable("tree-sitter") == 1

local default_parsers = {
    "lua",
    "python",
    "bash",
    "zsh",
    "typescript",
    "clojure",
    "markdown",
    "kdl",
    "json",
    "yaml",
    "toml",
    "ini",
}

local function ts_auto_install(bufnr)
    -- local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    local filetype = vim.bo[bufnr].filetype

    if filetype == "" then
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
        vim.notify("treesitter: installing parser '" .. parser_name .. "'")
        treesitter.install({ parser_name }):wait(30000)
        parser_installed = vim.treesitter.get_parser(bufnr, parser_name) ~= nil
    end

    if parser_installed then
        vim.treesitter.start(bufnr, parser_name)
    end
end

u.on_very_lazy(function()
    -- loaded buffer parsers
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
            ts_auto_install(bufnr)
        end
    end

    -- ts_ensure_installed parsers
    if has_treesitter_cli then
        local missing = vim.tbl_filter(function(parser)
            return vim.treesitter.language.add(parser) ~= true
        end, default_parsers)
        if #missing > 0 then
            vim.notify("treesitter: installing missing default parsers:\n" .. table.concat(missing, "\n"))
            treesitter.install(missing)
        end
    else
        vim.notify("treesitter: tree-sitter CLI not found, skipping baseline parser install", vim.log.levels.WARN)
    end

    -- on-demand parsers
    vim.api.nvim_create_autocmd("BufRead", {
        callback = function(event)
            return ts_auto_install(event.buf)
        end,
    })
end)
