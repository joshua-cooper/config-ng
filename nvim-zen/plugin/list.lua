local group = vim.api.nvim_create_augroup("zen.list", {})

vim.api.nvim_create_autocmd("InsertEnter", {
	group = group,
	desc = "Disable list mode while in insert mode",
	callback = function(_)
		vim.w._zen_list = vim.wo.list
		vim.wo[0][0].list = false
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = group,
	desc = "Enable list mode while out of insert mode",
	callback = function(_)
		vim.wo[0][0].list = vim.w._zen_list
	end,
})
