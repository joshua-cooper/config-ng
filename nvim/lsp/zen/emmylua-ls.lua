---@type vim.lsp.Config
return {
	cmd = {
		"emmylua_ls",
	},
	filetypes = {
		"lua",
	},
	settings = {
		emmylua = {},
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
	before_init = function(params, config)
		return require("zen.lsp.emmylua-ls").before_init(params, config)
	end,
}
