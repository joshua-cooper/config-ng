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

-- TODO: refactor this
vim.api.nvim_create_autocmd("LspProgress", {
	group = group,
	desc = "Update busy status on LSP progress",
	callback = function(args)
		local kind = args.data.params.value.kind
		local client =
			assert(vim.lsp.get_client_by_id(args.data.client_id))
		-- TODO: this is deprecated
		local buffers = vim.lsp.get_buffers_by_client_id(client.id)

		for _, bufnr in ipairs(buffers) do
			if kind == "begin" then
				vim.bo[bufnr].busy = vim.bo[bufnr].busy + 1
			elseif kind == "end" then
				vim.bo[bufnr].busy =
					math.max(0, vim.bo[bufnr].busy - 1)
			end
		end
	end,
})
