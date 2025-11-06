local AUTO_FORMAT = "lsp_auto_format"

---@param client_id integer
---@param bufnr integer
---@return string
local function client_group_name(client_id, bufnr)
	return string.format("zen.lsp.client:%d_%d", client_id, bufnr)
end

---@param bufnr integer
---@return boolean
local function is_auto_format_enabled(bufnr)
	if type(vim.b[bufnr][AUTO_FORMAT]) == "boolean" then
		return vim.b[bufnr][AUTO_FORMAT]
	end

	if type(vim.g[AUTO_FORMAT]) == "boolean" then
		return vim.g[AUTO_FORMAT]
	end

	return true
end

local function toggle_auto_format()
	if type(vim.g[AUTO_FORMAT]) == "boolean" then
		vim.g[AUTO_FORMAT] = not vim.g[AUTO_FORMAT]
	else
		vim.g[AUTO_FORMAT] = false
	end
end

local function toggle_inlay_hints()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

---@param bufnr integer
---@param client vim.lsp.Client
local function handle_attach(bufnr, client)
	local group_name = client_group_name(client.id, bufnr)

	local group = vim.api.nvim_create_augroup(group_name, {
		clear = true,
	})

	if client:supports_method("textDocument/completion", bufnr) then
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = false,
		})
	end

	if
		not client:supports_method("textDocument/willSaveWaitUntil", bufnr)
		and client:supports_method("textDocument/formatting", bufnr)
	then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			buffer = bufnr,
			desc = "Format the buffer on save",
			callback = function(_)
				if is_auto_format_enabled(bufnr) then
					vim.lsp.buf.format({
						id = client.id,
						bufnr = bufnr,
					})
				end
			end,
		})
	end

	if client:supports_method("textDocument/codeLens", bufnr) then
		local events = {
			"LspProgress",
			"BufEnter",
			"TextChanged",
			"InsertLeave",
		}

		vim.api.nvim_create_autocmd(events, {
			group = group,
			buffer = bufnr,
			desc = "Refresh codelens",
			callback = function(args)
				local should_refresh = true

				if args.event == "LspProgress" then
					should_refresh = args.file == "end"
				end

				if should_refresh then
					vim.lsp.codelens.refresh({
						bufnr = bufnr,
					})
				end
			end,
		})
	end
end

---@param bufnr integer
---@param client vim.lsp.Client
local function handle_detach(bufnr, client)
	local group_name = client_group_name(client.id, bufnr)

	if client:supports_method("textDocument/completion", bufnr) then
		vim.lsp.completion.enable(false, client.id, bufnr)
	end

	vim.api.nvim_del_augroup_by_name(group_name)
end

local group = vim.api.nvim_create_augroup("zen.lsp", {
	clear = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = group,
	desc = "Set up LSP clients",
	callback = function(args)
		handle_attach(args.buf, assert(vim.lsp.get_client_by_id(args.data.client_id)))
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = group,
	desc = "Clean up LSP clients",
	callback = function(args)
		handle_detach(args.buf, assert(vim.lsp.get_client_by_id(args.data.client_id)))
	end,
})

vim.keymap.set("n", "grf", toggle_auto_format, {
	desc = "Toggle auto format",
})

vim.keymap.set("n", "grh", toggle_inlay_hints, {
	desc = "Toggle inlay hints",
})

for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
	vim.lsp.enable(vim.fn.fnamemodify(path, ":t:r"))
end
