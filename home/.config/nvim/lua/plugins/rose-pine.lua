return {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    config = function()
        require("rose-pine").setup({
            variant = "moon",
            dark_variant = "moon",
            enable = {
                legacy_highlights = false,
            },
            styles = { italic = false, transparency = true },
            highlight_groups = {
                ColorfulWinSep = { link = "WinSeparator" },
                FidgetNotify = { fg = "subtle", bg = "overlay" },
                Visual = { bg = "foam" },
            },
        })
        vim.cmd("colorscheme rose-pine-moon")
    end,
}
