---@param command lsp.Command
local function handle_run_single(command)
	-- TODO
	vim.print(command)
end

---@param command lsp.Command
local function handle_debug_single(command)
	-- TODO
	vim.print(command)
end

---@param params lsp.InitializeParams
---@param config vim.lsp.ClientConfig
local function before_init(params, config)
	if config.settings and config.settings["rust-analyzer"] then
		params.initializationOptions = config.settings["rust-analyzer"]
	end
end

---@param buf integer
---@param on_dir fun(root_dir?: string)
local function root_dir(buf, on_dir)
	local crate_dir = vim.fs.root(buf, "Cargo.toml")

	if crate_dir == nil then
		local rust_project_dir = vim.fs.root(buf, "rust-project.json")

		if rust_project_dir then
			on_dir(rust_project_dir)
		end

		return
	end

	local command = {
		"cargo",
		"metadata",
		"--no-deps",
		"--format-version",
		"1",
	}

	if vim.fn.executable(command[1]) == 0 then
		on_dir(crate_dir)
		return
	end

	local opts = {
		text = true,
		cwd = crate_dir,
	}

	vim.system(command, opts, function(result)
		if result.code ~= 0 then
			vim.schedule(function()
				local message_format = "Got an error from `cargo metadata`:\n\n%s"
				local message = message_format:format(result.stderr)
				vim.notify_once(message, vim.log.levels.ERROR)
			end)

			on_dir(crate_dir)
			return
		end

		---@type unknown
		local output = vim.json.decode(result.stdout)
		local workspace_root = output.workspace_root

		if type(workspace_root) ~= "string" then
			vim.schedule(function()
				vim.notify_once(
					"No workspace_root returned from `cargo metadata`",
					vim.log.levels.WARN
				)
			end)

			on_dir(crate_dir)
			return
		end

		on_dir(vim.fs.normalize(workspace_root))
	end)
end

---@param client vim.lsp.Client
---@param config vim.lsp.ClientConfig
---@return boolean
local function reuse_client(client, config)
	if client.name ~= config.name then
		return false
	end

	if client.root_dir == config.root_dir then
		return true
	end

	-- TODO: if the file is in an external crate, reuse the client

	return false
end

-- TODO: custom commands for stuff like expand macro, reload workspace, etc.

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
					"rust-analyzer.debugSingle",
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
		["rust-analyzer.runSingle"] = handle_run_single,
		["rust-analyzer.debugSingle"] = handle_debug_single,
	},
	before_init = before_init,
	root_dir = root_dir,
	reuse_client = reuse_client,
}
