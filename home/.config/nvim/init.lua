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

-- general behaviour
require("keymap")
require("interface")
require("editor")

-- tooling
require("workspace")
require("lsp")
require("debugger")

-- additional contexts
require("filetypes")
