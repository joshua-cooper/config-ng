local M = {}

local CARGO_METADATA_COMMAND = {
	"cargo",
	"metadata",
	"--no-deps",
	"--format-version",
	"1",
}

---@param err lsp.ResponseError
local function notify_server_error(err)
	vim.notify(
		string.format(
			"[rust-analyzer] error %d: %s",
			err.code,
			err.message
		),
		vim.log.levels.ERROR
	)
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

---@return vim.lsp.Client?
local function get_client()
	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "zen/rust-analyzer",
	})

	return clients[#clients]
end

---@param method string
---@param text string
local function show_in_float(method, text)
	local lines = vim.split(text, "\n", {
		plain = true,
		trimempty = true,
	})

	vim.lsp.util.open_floating_preview(lines, "rust", {
		focus_id = method,
		wrap = vim.o.wrap,
	})
end

---@param method string
---@param empty_message string
---@param get_text fun(result: any): string
local function request_float_preview(method, empty_message, get_text)
	local client = get_client()

	if not client then
		return
	end

	local encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, encoding)

	---@diagnostic disable-next-line param-type-mismatch
	client:request(method, params, function(err, result, context, _)
		if vim.api.nvim_get_current_buf() ~= context.bufnr then
			return
		end

		if err then
			notify_server_error(err)
			return
		end

		if not result or result == empty_message then
			vim.notify(empty_message)
			return
		end

		show_in_float(method, get_text(result))
	end)
end

---@param method string
---@param success_message string
local function broadcast_request(method, success_message)
	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "zen/rust-analyzer",
	})

	for _, client in ipairs(clients) do
		---@diagnostic disable-next-line param-type-mismatch
		client:request(method, nil, function(err, _, _, _)
			if err then
				notify_server_error(err)
				return
			end

			vim.notify(success_message)
		end)
	end
end

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

---@param command lsp.Command
function M.run_single(command)
	local args = vim.tbl_get(command, "arguments", 1, "args")
	assert(type(args) == "table")
	assert(type(args.workspaceRoot) == "string")

	local command_name = "cargo"

	---@type string[]
	local cargo_args = { command_name }

	for _, arg in ipairs(args.cargoArgs or {}) do
		cargo_args[#cargo_args + 1] = arg
	end

	for _, arg in ipairs(args.cargoExtraArgs or {}) do
		cargo_args[#cargo_args + 1] = arg
	end

	cargo_args[#cargo_args + 1] = "--"

	for _, arg in ipairs(args.executableArgs or {}) do
		cargo_args[#cargo_args + 1] = arg
	end

	if vim.fn.executable(command_name) == 0 then
		vim.notify(
			string.format("%s is not executable", command_name),
			vim.log.levels.ERROR
		)
		return
	end

	local bufnr = vim.api.nvim_create_buf(true, false)
	local winnr = vim.api.nvim_open_win(bufnr, true, {
		win = -1,
		split = "below",
	})

	vim.fn.jobstart(cargo_args, {
		cwd = args.workspaceRoot,
		term = true,
	})

	vim.api.nvim_win_set_cursor(winnr, {
		vim.api.nvim_buf_line_count(bufnr),
		0,
	})
end

function M.expand_macro()
	request_float_preview(
		"rust-analyzer/expandMacro",
		"No macro under the cursor",
		function(result)
			assert(type(result) == "table")
			assert(type(result.expansion) == "string")
			return result.expansion
		end
	)
end

function M.view_mir()
	request_float_preview(
		"rust-analyzer/viewMir",
		"Not inside a function body",
		function(result)
			assert(type(result) == "string")
			return result
		end
	)
end

function M.view_hir()
	request_float_preview(
		"rust-analyzer/viewHir",
		"Not inside a lowerable item",
		function(result)
			assert(type(result) == "string")
			return result
		end
	)
end

function M.reload_workspace()
	broadcast_request("rust-analyzer/reloadWorkspace", "Reloaded workspace")
end

function M.rebuild_proc_macros()
	broadcast_request(
		"rust-analyzer/rebuildProcMacros",
		"Rebuilt proc macros"
	)
end

function M.open_cargo_toml()
	local client = get_client()

	if not client then
		return
	end

	local method = "experimental/openCargoToml"
	local params = {
		textDocument = vim.lsp.util.make_text_document_params(0),
	}

	---@diagnostic disable-next-line param-type-mismatch
	client:request(method, params, function(err, result, _, _)
		if err then
			notify_server_error(err)
			return
		end

		if not result then
			vim.notify("No Cargo.toml found")
			return
		end

		vim.lsp.util.show_document(
			result,
			client.offset_encoding or "utf-8"
		)
	end)
end

function M.parent_module()
	local client = get_client()

	if not client then
		return
	end

	local encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, encoding)
	local method = "experimental/parentModule"

	---@diagnostic disable-next-line param-type-mismatch
	client:request(method, params, function(err, result, _, _)
		if err then
			notify_server_error(err)
			return
		end

		if not result then
			vim.notify("No parent module found")
			return
		end

		assert(vim.islist(result))
		local location = assert(result[1])
		assert(location.uri or location.targetUri)

		vim.lsp.util.show_document(
			location,
			client.offset_encoding or "utf-8"
		)
	end)
end

function M.external_docs()
	local client = get_client()

	if not client then
		return
	end

	local encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, encoding)
	local method = "experimental/externalDocs"

	---@diagnostic disable-next-line param-type-mismatch
	client:request(method, params, function(err, result, _, _)
		if err then
			notify_server_error(err)
			return
		end

		if not result then
			vim.notify("No external item under the cursor")
			return
		end

		assert(type(result) == "string")

		vim.ui.open(result)
	end)
end

---@param params lsp.InitializeParams
---@param config vim.lsp.ClientConfig
function M.before_init(params, config)
	if config.settings and config.settings["rust-analyzer"] then
		params.initializationOptions = config.settings["rust-analyzer"]
	end
end

---@param bufnr integer
---@param on_dir fun(root_dir?: string)
function M.root_dir(bufnr, on_dir)
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
function M.reuse_client(client, config)
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
function M.on_attach(client, bufnr)
	local USER_COMMANDS = {
		LspRustAnalyzerExpandMacro = M.expand_macro,
		LspRustAnalyzerViewMir = M.view_mir,
		LspRustAnalyzerViewHir = M.view_hir,
		LspRustAnalyzerReloadWorkspace = M.reload_workspace,
		LspRustAnalyzerRebuildProcMacros = M.rebuild_proc_macros,
		LspRustAnalyzerOpenCargoToml = M.open_cargo_toml,
		LspRustAnalyzerParentModule = M.parent_module,
		LspRustAnalyzerExternalDocs = M.external_docs,
	}

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

return M
