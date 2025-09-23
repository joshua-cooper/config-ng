local M = {}

---@param lnum integer
---@return string
function M.foldexpr(lnum)
	local buf = vim.api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({
		bufnr = buf,
		method = "textDocument/foldingRange",
	})

	if #clients > 0 then
		return vim.lsp.foldexpr(lnum)
	end

	return "0"
end

return M
