vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.completeopt = "menuone,noinsert,fuzzy"
vim.o.list = true
vim.o.number = true
vim.o.pumheight = 10
vim.o.quickfixtextfunc = "v:lua.require'zen.quickfix'.quickfixtextfunc"
vim.o.relativenumber = true
vim.o.showcmd = false
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.tabline = "%!v:lua.require'zen.tabline'.tabline()"
vim.o.undofile = true
vim.o.winborder = "solid"
vim.o.wrap = false

vim.o.guifont = "monospace:h10"
