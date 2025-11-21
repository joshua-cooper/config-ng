vim.o.exrc = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.undofile = true
vim.o.wrap = false
vim.o.winborder = "solid"
vim.o.colorcolumn = "80"
vim.o.showcmd = false

vim.o.foldexpr = "v:lua.require'zen.folding'.foldexpr()"
vim.o.statusline = "%!v:lua.require'zen'.statusline()"
vim.o.tabline = "%!v:lua.require'zen'.tabline()"

-- Completion

vim.o.pumheight = 10
vim.o.completeopt = "menuone,noinsert,fuzzy"

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

vim.lsp.enable({
	"zen/emmylua-ls",
})
