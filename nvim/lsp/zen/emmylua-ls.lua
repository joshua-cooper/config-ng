---@type vim.lsp.Config
return {
	cmd = {
		"emmylua_ls",
	},
	filetypes = {
		"lua",
	},
	workspace_required = false,
	root_dir = function(bufnr, on_dir)
		return require("zen.lsp.emmylua-ls").root_dir(bufnr, on_dir)
	end,
	reuse_client = function(client, config)
		return require("zen.lsp.emmylua-ls").reuse_client(
			client,
			config
		)
	end,
	on_init = function(client, init_result)
		return require("zen.lsp.emmylua-ls").on_init(
			client,
			init_result
		)
	end,
}
