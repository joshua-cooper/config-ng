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

---@param command lsp.Command
function M.run_single(command)
	local args = vim.tbl_get(command, "arguments", 1, "args")
	assert(type(args) == "table")
	assert(type(args.workspaceRoot) == "string")

	---@type string[]
	local cargo_args = { "cargo" }

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
	broadcast_request("rust-analyzer/reloadWorkspace", "Workspace reloaded")
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

return M
