local STATUSLINE = "%!v:lua.require'zen.statusline'.statusline()"

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	group = vim.api.nvim_create_augroup("zen.statusline.quickfix", {
		clear = true,
	}),
	desc = "Use custom statusline for quickfix windows",
	callback = function(_)
		vim.wo.statusline = STATUSLINE
	end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = vim.api.nvim_create_augroup("zen.statusline.diagnostic", {
		clear = true,
	}),
	desc = "Redraw statusline when diagnostics change",
	callback = function(_)
		vim.cmd.redrawstatus({
			bang = true,
		})
	end,
})

vim.o.statusline = STATUSLINE
