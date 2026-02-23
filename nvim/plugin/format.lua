local group = vim.api.nvim_create_augroup("zen.format", {})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	desc = "Format the buffer on write",
	callback = function(args)
		require("zen.format").on_write(args.buf)
	end,
})

require("conform").setup({
	notify_no_formatters = false,
	formatters_by_ft = {
		fish = { "fish_indent" },
		lua = { "stylua" },
		nix = { "nixfmt" },
		rust = { "rustfmt" },
	},
})
