local group = vim.api.nvim_create_augroup("zen.lsp", {})

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	desc = "Set up LSP clients",
	callback = function(args)
		require("zen.lsp").on_attach(
			assert(vim.lsp.get_client_by_id(args.data.client_id)),
			args.buf
		)
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = group,
	desc = "Clean up LSP clients",
	callback = function(args)
		require("zen.lsp").on_detach(
			assert(vim.lsp.get_client_by_id(args.data.client_id)),
			args.buf
		)
	end,
})

vim.api.nvim_create_autocmd("LspProgress", {
	group = group,
	desc = "Update busy status on LSP progress",
	callback = function(args)
		require("zen.lsp").on_progress(
			assert(vim.lsp.get_client_by_id(args.data.client_id)),
			args.data.params.value.kind
		)
	end,
})
