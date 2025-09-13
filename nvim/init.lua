vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.completeopt = "menuone,noinsert,fuzzy"
vim.o.list = true
vim.o.pumheight = 10
vim.o.showcmd = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.winborder = "solid"
vim.o.wrap = false
vim.o.quickfixtextfunc = "v:lua.require'zen.quickfix'.quickfixtextfunc"

vim.o.guifont = "monospace:h10"
