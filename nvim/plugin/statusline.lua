local group = vim.api.nvim_create_augroup("zen.statusline", {})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = group,
	desc = "Redraw statusline when diagnostics change",
	callback = function(_)
		vim.cmd.redrawstatus({
			bang = true,
		})
	end,
})
