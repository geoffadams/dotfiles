local treesitter = require("nvim-treesitter")
treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})
treesitter.install({
    "lua",
    "python",
    "bash",
    "zsh",
    "typescript",
    "clojure",
    "markdown",
})
