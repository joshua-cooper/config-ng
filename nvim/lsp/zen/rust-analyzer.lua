---@type vim.lsp.Config
return {
	cmd = {
		"rust-analyzer",
	},
	filetypes = {
		"rust",
	},
	capabilities = {
		experimental = {
			serverStatusNotification = true,
			commands = {
				commands = {
					"rust-analyzer.runSingle",
				},
			},
		},
	},
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
			lru = {
				capacity = 65535,
			},
		},
	},
	commands = {
		["rust-analyzer.runSingle"] = function(command)
			require("zen.lsp.rust-analyzer").run_single(command)
		end,
	},
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		return require("zen.lsp.rust-analyzer").root_dir(bufnr, on_dir)
	end,
	reuse_client = function(client, config)
		return require("zen.lsp.rust-analyzer").reuse_client(
			client,
			config
		)
	end,
	before_init = function(params, config)
		return require("zen.lsp.rust-analyzer").before_init(
			params,
			config
		)
	end,
	on_attach = function(client, bufnr)
		return require("zen.lsp.rust-analyzer").on_attach(client, bufnr)
	end,
}
