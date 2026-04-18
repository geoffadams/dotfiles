require("vim._core.ui2").enable({})

-- leader (early)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- allow workspace-specific overrides
vim.o.exrc = true

-- session data to save
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
