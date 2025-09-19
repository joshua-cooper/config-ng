vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = vim.api.nvim_create_augroup("zen.statusline.diagnostic", {
		clear = true,
	}),
	desc = "Redraw statusline when diagnostics change",
	callback = function()
		vim.cmd.redrawstatus({
			bang = true,
		})
	end,
})

vim.o.statusline = "%!v:lua.require'zen.statusline'.statusline()"
