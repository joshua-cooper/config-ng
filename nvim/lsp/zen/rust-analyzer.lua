---@param method string
---@return fun()
local function lazy(method)
	return function()
		local message = string.format(
			"zen.lsp.rust-analyzer method '%s' should exist",
			method
		)

		local f = assert(
			require("zen.lsp.rust-analyzer")[method],
			message
		)

		f()
	end
end

local USER_COMMANDS = {
	LspRustAnalyzerExpandMacro = lazy("expand_macro"),
	LspRustAnalyzerViewMir = lazy("view_mir"),
	LspRustAnalyzerViewHir = lazy("view_hir"),
	LspRustAnalyzerReloadWorkspace = lazy("reload_workspace"),
	LspRustAnalyzerRebuildProcMacros = lazy("rebuild_proc_macros"),
	LspRustAnalyzerOpenCargoToml = lazy("open_cargo_toml"),
	LspRustAnalyzerParentModule = lazy("parent_module"),
	LspRustAnalyzerExternalDocs = lazy("external_docs"),
}

local CARGO_METADATA_COMMAND = {
	"cargo",
	"metadata",
	"--no-deps",
	"--format-version",
	"1",
}

---@param path string
---@return boolean
local function is_external_crate(path)
	local join = vim.fs.joinpath

	local user_home = assert(vim.uv.os_homedir())
	local cargo_home = vim.env.CARGO_HOME or join(user_home, ".cargo")
	local rustup_home = vim.env.RUSTUP_HOME or join(user_home, ".rustup")

	local cargo_registry = join(cargo_home, "registry", "src")
	local git_registry = join(cargo_home, "git", "checkouts")
	local toolchains = join(rustup_home, "toolchains")
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

---@param stderr string
local function notify_cargo_metadata_error(stderr)
	vim.schedule(function()
		vim.notify_once(
			string.format(
				"Got an error from `cargo metadata`:\n\n%s",
				stderr
			),
			vim.log.levels.ERROR
		)
	end)
end

local function notify_no_workspace_root_from_cargo_metadata()
	vim.schedule(function()
		vim.notify_once(
			"No workspace_root returned from `cargo metadata`",
			vim.log.levels.WARN
		)
	end)
end

---@param params lsp.InitializeParams
---@param config vim.lsp.ClientConfig
local function before_init(params, config)
	if config.settings and config.settings["rust-analyzer"] then
		params.initializationOptions = config.settings["rust-analyzer"]
	end
end

---@param bufnr integer
---@param on_dir fun(root_dir?: string)
local function root_dir(bufnr, on_dir)
	local crate_dir = vim.fs.root(bufnr, "Cargo.toml")

	if not crate_dir then
		local rust_project_dir = vim.fs.root(bufnr, "rust-project.json")

		if rust_project_dir then
			on_dir(rust_project_dir)
		end

		return
	end

	if vim.fn.executable(CARGO_METADATA_COMMAND[1]) == 0 then
		on_dir(crate_dir)
		return
	end

	local opts = {
		text = true,
		cwd = crate_dir,
		env = {
			-- Allow cargo to parse manifests with unstable
			-- features.
			RUSTC_BOOTSTRAP = "1",
		},
	}

	vim.system(CARGO_METADATA_COMMAND, opts, function(result)
		if result.code ~= 0 then
			notify_cargo_metadata_error(assert(result.stderr))
			on_dir(crate_dir)
			return
		end

		local output = vim.json.decode(assert(result.stdout))
		local workspace_root = output.workspace_root

		if type(workspace_root) ~= "string" then
			notify_no_workspace_root_from_cargo_metadata()
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

	local should_add_to_workspace = not has_workspace_folder(
		client.workspace_folders,
		config.root_dir
	)

	if should_add_to_workspace then
		local folder = {
			uri = vim.uri_from_fname(config.root_dir),
			name = config.root_dir,
		}

		client:notify("workspace/didChangeWorkspaceFolders", {
			event = {
				added = {
					folder,
				},
				removed = {},
			},
		})

		client.workspace_folders[#client.workspace_folders + 1] = folder
	end

	return true
end

---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
	for name, command in pairs(USER_COMMANDS) do
		vim.api.nvim_buf_create_user_command(bufnr, name, command, {})
	end

	local group = vim.api.nvim_create_augroup(
		string.format("zen.lsp.%s:%d", client.name, bufnr),
		{}
	)

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		buffer = bufnr,
		desc = string.format("Clean up %s LSP clients", client.name),
		callback = function(args)
			if args.data.client_id ~= client.id then
				return
			end

			for name, _ in pairs(USER_COMMANDS) do
				pcall(
					vim.api.nvim_buf_del_user_command,
					bufnr,
					name
				)
			end

			return true
		end,
	})
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
	root_dir = root_dir,
	reuse_client = reuse_client,
	before_init = before_init,
	on_attach = on_attach,
}
