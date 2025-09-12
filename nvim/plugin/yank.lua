vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("zen.yank", {
		clear = true,
	}),
	desc = "Highlight text that was yanked",
	callback = function(_)
		vim.hl.on_yank({
			higroup = "Visual",
			timeout = 200,
			on_visual = false,
		})
	end,
})
