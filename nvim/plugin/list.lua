local group = vim.api.nvim_create_augroup("zen.list", {
	clear = true,
})

vim.api.nvim_create_autocmd("InsertEnter", {
	group = group,
	desc = "Disables list mode while in insert mode",
	callback = function(_)
		vim.api.nvim_set_option_value("list", false, {
			scope = "local",
		})
	end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
	group = group,
	desc = "Enables list mode while out of insert mode",
	callback = function(_)
		local value = vim.w.list_override

		if value == nil or value == true then
			vim.api.nvim_set_option_value("list", true, {
				scope = "local",
			})
		end
	end,
})

vim.api.nvim_create_autocmd("OptionSet", {
	group = group,
	pattern = "list",
	desc = "Records manual list mode overrides",
	callback = function(_)
		vim.w.list_override = vim.v.option_new
	end,
})

vim.o.list = true
vim.o.listchars = "tab:  ,trail:·,nbsp:⍽"
