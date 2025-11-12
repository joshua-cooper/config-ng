local group = vim.api.nvim_create_augroup("zen.sensitive", {
	clear = true,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = group,
	pattern = {
		"/dev/shm/pass.*",
		"/dev/shm/passage.*",
		"/dev/shm/gopass-*",
	},
	desc = "Prevent leaking sensitive buffer contents",
	callback = function(args)
		vim.bo[args.buf].swapfile = false
		vim.bo[args.buf].undofile = false
		vim.o.shada = ""
		vim.o.backup = false
		vim.o.writebackup = false
	end,
})
