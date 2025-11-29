local M = {}

---@param client_id integer
---@param bufnr integer
---@return string
local function client_group_name(client_id, bufnr)
	return string.format("zen.lsp.client:%s_%s", client_id, bufnr)
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
	local group_name = client_group_name(client.id, bufnr)
	local group = vim.api.nvim_create_augroup(group_name, {})

	---@param method vim.lsp.protocol.Method.ClientToServer
	---@return boolean
	local function supports_method(method)
		return client:supports_method(method, bufnr)
	end

	if supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			buffer = bufnr,
			desc = "Format the buffer on save",
			callback = function(_)
				vim.lsp.buf.format({
					id = client.id,
					bufnr = bufnr,
				})
			end,
		})
	end

	if supports_method("textDocument/completion") then
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
		})
	end
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_detach(client, bufnr)
	local group_name = client_group_name(client.id, bufnr)

	---@param method vim.lsp.protocol.Method.ClientToServer
	---@return boolean
	local function supports_method(method)
		return client:supports_method(method, bufnr)
	end

	vim.api.nvim_del_augroup_by_name(group_name)

	if supports_method("textDocument/completion") then
		vim.lsp.completion.enable(false, client.id, bufnr)
	end
end

return M
