local STATUSLINE = "%!v:lua.require'zen.statusline'.statusline()"

local group = vim.api.nvim_create_augroup("zen.statusline", {
	clear = true,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf",
	group = group,
	desc = "Set custom statusline for quickfix windows",
	callback = function(_)
		vim.wo[0][0].statusline = STATUSLINE
	end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
	group = group,
	desc = "Redraw statusline when diagnostics change",
	callback = function(_)
		vim.cmd.redrawstatus({
			bang = true,
		})
	end,
})

vim.o.statusline = STATUSLINE
