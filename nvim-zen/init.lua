vim.o.colorcolumn = "80"
vim.o.exrc = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.wrap = false

-- Completion

vim.o.pumheight = 10
vim.o.completeopt = "menuone,noinsert,fuzzy"

vim.lsp.enable({
	"zen/emmylua-ls",
})
