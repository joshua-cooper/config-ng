local M = {}

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

---@param command lsp.Command
function M.run_single(command)
	---@diagnostic disable-next-line: param-type-mismatch
	local arguments = assert(command.arguments)
	---@diagnostic disable-next-line: param-type-mismatch
	local first = assert(arguments[1])
	---@diagnostic disable-next-line: unnecessary-assert
	local args = assert(first.args)
	assert(type(args.workspaceRoot) == "string")

	local cargo_args = { "cargo" }

	for _, arg in ipairs(args.cargoArgs or {}) do
		table.insert(cargo_args, arg)
	end

	for _, arg in ipairs(args.cargoExtraArgs or {}) do
		table.insert(cargo_args, arg)
	end

	table.insert(cargo_args, "--")

	for _, arg in ipairs(args.executableArgs or {}) do
		table.insert(cargo_args, arg)
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
	local client = get_client()

	if not client then
		return
	end

	local encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, encoding)
	local method = "rust-analyzer/expandMacro"

	client:request(method, params, function(err, result, context, _)
		if vim.api.nvim_get_current_buf() ~= context.bufnr then
			return
		end

		if err then
			notify_server_error(err)
			return
		end

		if not result then
			vim.notify("No macro under the cursor")
			return
		end

		assert(type(result) == "table")
		assert(type(result.expansion) == "string")

		show_in_float(method, result.expansion)
	end)
end

function M.view_mir()
	local client = get_client()

	if not client then
		return
	end

	local encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, encoding)
	local method = "rust-analyzer/viewMir"

	client:request(method, params, function(err, result, context, _)
		if vim.api.nvim_get_current_buf() ~= context.bufnr then
			return
		end

		if err then
			notify_server_error(err)
			return
		end

		if not result then
			vim.notify("Not inside a function body")
			return
		end

		assert(type(result) == "string")

		show_in_float(method, result)
	end)
end

function M.view_hir()
	local client = get_client()

	if not client then
		return
	end

	local encoding = client.offset_encoding or "utf-8"
	local params = vim.lsp.util.make_position_params(0, encoding)
	local method = "rust-analyzer/viewHir"

	client:request(method, params, function(err, result, context, _)
		if vim.api.nvim_get_current_buf() ~= context.bufnr then
			return
		end

		if err then
			notify_server_error(err)
			return
		end

		if not result then
			vim.notify("Not inside a lowerable item")
			return
		end

		assert(type(result) == "string")

		show_in_float(method, result)
	end)
end

function M.reload_workspace()
	local method = "rust-analyzer/reloadWorkspace"
	local clients = vim.lsp.get_clients({
		bufnr = 0,
		name = "zen/rust-analyzer",
	})

	for _, client in ipairs(clients) do
		client:request(method, nil, function(err, _, _, _)
			if err then
				notify_server_error(err)
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
		name = "zen/rust-analyzer",
	})

	for _, client in ipairs(clients) do
		client:request(method, nil, function(err, _, _, _)
			if err then
				notify_server_error(err)
				return
			end

			vim.notify("Rebuilt proc macros")
		end)
	end
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

	client:request(method, params, function(err, result, context, _)
		if err then
			notify_server_error(err)
			return
		end

		local client_id = context.client_id
		local client = assert(vim.lsp.get_client_by_id(client_id))

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

	client:request(method, params, function(err, result, context, _)
		if err then
			notify_server_error(err)
			return
		end

		assert(vim.islist(result))
		local location = assert(result[1])
		assert(type(location.uri) == "string")
		local client_id = context.client_id
		local client = assert(vim.lsp.get_client_by_id(client_id))

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

	client:request(method, params, function(err, result, _, _)
		if err then
			notify_server_error(err)
			return
		end

		assert(type(result) == "string")

		vim.ui.open(result)
	end)
end

return M
