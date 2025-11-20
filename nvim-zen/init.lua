vim.o.exrc = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.wrap = false
vim.o.winborder = "solid"
vim.o.statusline = "%!v:lua.require'zen'.statusline()"
vim.o.colorcolumn = "80"

-- Completion

vim.o.pumheight = 10
vim.o.completeopt = "menuone,noinsert,fuzzy"

vim.lsp.enable({
	"zen/emmylua-ls",
})
