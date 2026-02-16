vim.cmd("scriptencoding utf-8")

-- leader (early)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.exrc = true

-- lazy.nvim
require("config.lazy")

-- mini.nvim
require("mini.icons").setup()
require("mini.tabline").setup()
require("mini.statusline").setup()
require("mini.cmdline").setup()
require("mini.bufremove").setup()

-- general behaviour
require("keymap")
require("interface")
require("editor")
require("workspace")

-- tooling
require("git")
require("lsp")
require("completions")
require("debugger")

-- additional contexts
require("filetypes")
