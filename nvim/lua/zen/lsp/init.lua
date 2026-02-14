local M = {}

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
	---@param method vim.lsp.protocol.Method.ClientToServer
	---@return boolean
	local function supports_method(method)
		return client:supports_method(method, bufnr)
	end

	if supports_method("textDocument/completion") then
		vim.lsp.completion.enable(true, client.id, bufnr, {
			autotrigger = true,
		})
	end

	if supports_method("textDocument/foldingRange") then
		vim.cmd.normal({
			"zx",
			bang = true,
		})
	end
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_detach(client, bufnr)
	---@param method vim.lsp.protocol.Method.ClientToServer
	---@return boolean
	local function supports_method(method)
		return client:supports_method(method, bufnr)
	end

	if supports_method("textDocument/completion") then
		vim.lsp.completion.enable(false, client.id, bufnr)
	end

	if supports_method("textDocument/foldingRange") then
		vim.cmd.normal({
			"zx",
			bang = true,
		})
	end
end

---@param client vim.lsp.Client
---@param kind string
function M.on_progress(client, kind)
	for bufnr, _ in pairs(client.attached_buffers) do
		local n = vim.bo[bufnr].busy

		if kind == "begin" then
			vim.bo[bufnr].busy = n + 1
		elseif kind == "end" then
			vim.bo[bufnr].busy = math.max(0, n - 1)
		end
	end
end

return M
