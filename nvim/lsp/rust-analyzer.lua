---@param path string
---@return boolean
local function is_external_crate(path)
	local joinpath = vim.fs.joinpath

	local user_home = assert(vim.uv.os_homedir())
	local cargo_home = vim.env.CARGO_HOME or joinpath(user_home, ".cargo")
	local rustup_home = vim.env.RUSTUP_HOME or joinpath(user_home, ".rustup")

	local cargo_registry = joinpath(cargo_home, "registry", "src")
	local git_registry = joinpath(cargo_home, "git", "checkouts")
	local toolchains = joinpath(rustup_home, "toolchains")
	local nix_store = "/nix/store"

	local dirs = {
		cargo_registry,
		git_registry,
		toolchains,
		nix_store,
	}

	for _, dir in ipairs(dirs) do
		if vim.fs.relpath(dir, path) then
			return true
		end
	end

	return false
end

---@param folders lsp.WorkspaceFolder[]
---@param path string
---@return boolean
local function has_workspace_folder(folders, path)
	for _, folder in ipairs(folders) do
		if folder.name == path then
			return true
		end
	end

	return false
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

	if not crate_dir then
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

	if not config.root_dir then
		return false
	end

	if is_external_crate(config.root_dir) then
		return true
	end

	client.workspace_folders = client.workspace_folders or {}

	if not has_workspace_folder(client.workspace_folders, config.root_dir) then
		local workspace_folder = {
			uri = vim.uri_from_fname(config.root_dir),
			name = config.root_dir,
		}

		client:notify("workspace/didChangeWorkspaceFolders", {
			event = {
				added = {
					workspace_folder,
				},
				removed = {},
			},
		})

		table.insert(client.workspace_folders, workspace_folder)
	end

	return true
end

---@param buf integer
local function on_attach(buf)
	vim.keymap.set(
		"n",
		"gre",
		function()
			require("zen.lsp.rust-analyzer").expand_macro()
		end,
		{
			desc = "Expand the macro under the cursor",
			buffer = buf,
		}
	)
end

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
		["rust-analyzer.runSingle"] = function(command)
			require("zen.lsp.rust-analyzer").run_single(command)
		end,
		["rust-analyzer.debugSingle"] = function(command)
			require("zen.lsp.rust-analyzer").debug_single(command)
		end,
	},
	before_init = before_init,
	root_dir = root_dir,
	reuse_client = reuse_client,
	on_attach = function(_, buf)
		on_attach(buf)
	end,
}
