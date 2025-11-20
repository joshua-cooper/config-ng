vim.o.exrc = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.wrap = false
vim.o.winborder = "solid"
vim.o.colorcolumn = "80"
vim.o.showcmd = false

vim.o.statusline = "%!v:lua.require'zen'.statusline()"
vim.o.tabline = "%!v:lua.require'zen'.tabline()"

-- Completion

vim.o.pumheight = 10
vim.o.completeopt = "menuone,noinsert,fuzzy"

vim.lsp.enable({
	"zen/emmylua-ls",
})
