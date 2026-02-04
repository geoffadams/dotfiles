vim.cmd("scriptencoding utf-8")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

-- mini.nvim
require("mini.icons").setup()
require("mini.tabline").setup()
require("mini.statusline").setup()
require("mini.cmdline").setup()
require("mini.completion").setup()
require("mini.bufremove").setup()
require("mini.completion").setup()

require("keymap")
require("workspace")

require("interface")
require("editor")
require("recovery")

require("lsp")
require("filetypes")

require("debugger")
