vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI

vim.o.showcmd = false
vim.o.ruler = false
vim.o.winborder = "solid"
vim.o.fillchars = "fold: ,foldsep: ,foldinner: ,eob: ,trunc:›,truncrl:‹"
vim.o.tabline = "%!v:lua.require'zen.tabline'.tabline()"
vim.o.quickfixtextfunc = "v:lua.require'zen.quickfix'.quickfixtextfunc"

-- Indentation

vim.o.shiftwidth = 0
vim.o.softtabstop = 0

-- Search

vim.o.ignorecase = true
vim.o.smartcase = true

-- Completion

vim.o.pumheight = 10
vim.o.completeopt = "menuone,noinsert,fuzzy"

-- Splits

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = "cursor"

-- Scrolling

vim.o.scrolloff = 3
vim.o.wrap = false

-- Behavior

vim.o.exrc = true
vim.o.undofile = true
