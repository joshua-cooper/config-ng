vim.cmd.colorscheme("zen")

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.exrc = true

-- UI

vim.o.wrap = false
vim.o.ruler = false
vim.o.showcmd = false
vim.o.pumheight = 10
vim.o.winborder = "solid"
vim.o.fillchars =
	"fold: ,foldopen:▼,foldclose:▶,foldsep: ,foldinner: ,eob: ,trunc:›,truncrl:‹"
vim.o.quickfixtextfunc = "v:lua.require'zen.quickfix'.quickfixtextfunc"
vim.o.statusline = "%!v:lua.require'zen.statusline'.statusline()"
vim.o.tabline = "%!v:lua.require'zen.tabline'.tabline()"

-- Indentation

vim.o.shiftwidth = 0
vim.o.softtabstop = 0

-- Search

vim.o.ignorecase = true
vim.o.smartcase = true

-- Completion

vim.o.completeopt = "menuone,noinsert,fuzzy"

-- Splits

vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = "cursor"

-- Scrolling

vim.o.scrolloff = 3
vim.o.sidescrolloff = 3

-- Folding

vim.o.foldtext = ""
vim.o.foldmethod = "expr"
vim.o.foldlevelstart = 99
vim.o.foldexpr = "v:lua.require'zen.folding'.foldexpr()"

-- Persistence

vim.o.undofile = true

-- Keymaps

vim.keymap.set("n", "<leader>b", "<cmd>ls<cr>:buffer ")
vim.keymap.set("n", "<leader>f", ":find ")
vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>k", "<cmd>confirm bdelete<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>confirm quitall<cr>")

-- Diagnostics

vim.diagnostic.config({
	float = {
		header = "",
	},
	jump = {
		float = true,
		wrap = true,
	},
	severity_sort = true,
	signs = false,
	underline = false,
	update_in_insert = false,
	virtual_lines = false,
	virtual_text = false,
})

-- LSP

vim.lsp.enable({
	"zen/emmylua-ls",
	"zen/rust-analyzer",
})
