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
}

-- baseline auto-install
treesitter.install(ts_ensure_installed)
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
