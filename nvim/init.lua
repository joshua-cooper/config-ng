vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI

vim.o.fillchars = "fold: ,foldsep: ,foldinner: ,eob: ,trunc:›,truncrl:‹"
vim.o.quickfixtextfunc = "v:lua.require'zen.quickfix'.quickfixtextfunc"
vim.o.ruler = false
vim.o.showcmd = false
vim.o.tabline = "%!v:lua.require'zen.tabline'.tabline()"
vim.o.winborder = "solid"

-- Indentation

vim.o.shiftwidth = 0
vim.o.softtabstop = 0

-- Search

vim.o.ignorecase = true
vim.o.smartcase = true

-- Completion

vim.o.completeopt = "menuone,noinsert,fuzzy"
vim.o.pumheight = 10

-- Splits

vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true

-- Scrolling

vim.o.scrolloff = 3
vim.o.wrap = false

-- Behavior

vim.o.exrc = true
vim.o.undofile = true
