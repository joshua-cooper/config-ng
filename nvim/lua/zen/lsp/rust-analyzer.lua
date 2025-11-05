local M = {}

---@param error lsp.ResponseError
local function notify_server_error(error)
	local message = ("[rust-analyzer] error %d: %s"):format(error.code, error.message)
	vim.notify(message, vim.log.levels.ERROR)
end

---@param command lsp.Command
local function run_cargo_command(command)
	local args = command.arguments[1].args
	local cargo_command = { "cargo" }

	for _, arg in ipairs(args.cargoArgs or {}) do
		table.insert(cargo_command, arg)
	end

	for _, arg in ipairs(args.cargoExtraArgs or {}) do
		table.insert(cargo_command, arg)
	end

	table.insert(cargo_command, "--")

	for _, arg in ipairs(args.executableArgs or {}) do
		table.insert(cargo_command, arg)
	end

	vim.cmd("botright split")
	local bufnr = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_set_current_buf(bufnr)
	vim.fn.termopen(cargo_command, {
		cwd = args.workspaceRoot,
	})
end

---@param command lsp.Command
function M.run_single(command)
	run_cargo_command(command)
end

---@param command lsp.Command
function M.debug_single(command)
	run_cargo_command(command)
end

function M.expand_macro()
	local method = "rust-analyzer/expandMacro"

	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "rust-analyzer",
	})

	local client = clients[#clients]

	if not client then
		return
	end

	local offset_encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, offset_encoding)

	client:request(method, params, function(error, result, context)
		local buf = assert(context.bufnr)

		if vim.api.nvim_get_current_buf() ~= buf then
			-- Ignore result since buffer changed.
			return
		end

		if error then
			notify_server_error(error)
			return
		end

		if not result then
			vim.notify("No macro under the cursor")
			return
		end

		assert(type(result) == "table")
		assert(type(result.expansion) == "string")

		local lines = vim.split(result.expansion, "\n", {
			plain = true,
			trimempty = true,
		})

		vim.lsp.util.open_floating_preview(lines, "rust", {
			focus_id = method,
			wrap = vim.o.wrap,
		})
	end)
end

function M.reload_workspace()
	local method = "rust-analyzer/reloadWorkspace"

	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "rust-analyzer",
	})

	for _, client in ipairs(clients) do
		client:request(method, nil, function(error, _, _)
			if error ~= nil then
				notify_server_error(error)
				return
			end

			vim.notify("Workspace reloaded")
		end)
	end
end

function M.rebuild_proc_macros()
	local method = "rust-analyzer/rebuildProcMacros"

	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "rust-analyzer",
	})

	for _, client in ipairs(clients) do
		client:request(method, nil, function(error, _, _)
			if error ~= nil then
				notify_server_error(error)
				return
			end

			vim.notify("Rebuilt proc macros")
		end)
	end
end

function M.open_cargo_toml()
	local method = "experimental/openCargoToml"

	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "rust-analyzer",
	})

	local client = clients[#clients]

	if not client then
		return
	end

	local params = {
		textDocument = vim.lsp.util.make_text_document_params(0),
	}

	client:request(method, params, function(error, result, context)
		if error ~= nil then
			notify_server_error(error)
			return
		end

		local client = assert(vim.lsp.get_client_by_id(context.client_id))
		vim.lsp.util.show_document(result, client.offset_encoding or "utf-8")
	end)
end

function M.parent_module()
	local method = "experimental/parentModule"

	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "rust-analyzer",
	})

	local client = clients[#clients]

	if not client then
		return
	end

	local offset_encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, offset_encoding)

	client:request(method, params, function(error, result, context)
		if error ~= nil then
			notify_server_error(error)
			return
		end

		assert(vim.islist(result))
		local location = assert(result[1])
		local client = assert(vim.lsp.get_client_by_id(context.client_id))
		vim.lsp.util.show_document(location, client.offset_encoding or "utf-8")
	end)
end

function M.external_docs()
	local method = "experimental/externalDocs"

	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "rust-analyzer",
	})

	local client = clients[#clients]

	if not client then
		return
	end

	local offset_encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, offset_encoding)

	client:request(method, params, function(error, result, _)
		if error ~= nil then
			notify_server_error(error)
			return
		end

		if not result then
			return
		end

		assert(type(result) == "string")
		vim.ui.open(result)
	end)
end

return M
