vim.cmd.colorscheme("zen")

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.qf_disable_statusline = 1

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.o.exrc = true

-- UI

vim.o.wrap = false
vim.o.ruler = false
vim.o.showcmd = false
vim.o.pumheight = 10
vim.o.winborder = "solid"
vim.o.list = true
vim.o.listchars = "tab:  ,nbsp:⍽"
vim.o.fillchars = "eob: ,trunc:›,truncrl:‹"
	.. ",fold: ,foldsep: ,foldinner: ,foldopen:▼,foldclose:▶"
vim.o.quickfixtextfunc = "v:lua.require'zen.quickfix'.quickfixtextfunc"
vim.o.statuscolumn = "%!v:lua.require'zen.statuscolumn'.statuscolumn()"
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
vim.o.foldexpr = "v:lua.require'zen.fold'.foldexpr()"

-- Formatting

vim.o.formatexpr = "v:lua.require'zen.format'.formatexpr()"

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
		prefix = function(_, i, total)
			if total == 1 then
				return "", ""
			end

			return string.format("%d. ", i), ""
		end,
	},
	jump = {
		on_jump = function(diagnostic, _)
			assert(diagnostic)

			vim.diagnostic.open_float({
				bufnr = diagnostic.bufnr,
				namespace = diagnostic.namespace,
				pos = {
					diagnostic.lnum,
					diagnostic.col,
				},
				severity = diagnostic.severity,
				focus = false,
			})
		end,
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

-- Plugins

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("zen.pack", {}),
	desc = "Execute pack callbacks",
	callback = function(args)
		require("zen.pack").on_changed(args.data.kind, args.data.spec)
	end,
})

vim.pack.add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = vim.version.range("0.10"),
		data = {
			on_update = function(_)
				require("zen.tree-sitter").on_update()
			end,
		},
	},
	{
		src = "https://github.com/stevearc/oil.nvim",
		version = vim.version.range("2.15"),
	},
	{
		src = "https://github.com/stevearc/conform.nvim",
		version = vim.version.range("9.1"),
	},
	{
		src = "https://github.com/nvim-mini/mini.surround",
		version = vim.version.range("0.17"),
	},
	{
		src = "https://github.com/nvim-mini/mini.trailspace",
		version = vim.version.range("0.17"),
	},
})
