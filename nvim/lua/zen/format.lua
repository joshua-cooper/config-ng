local M = {}

---@return 0|1
function M.formatexpr()
	return require("conform").formatexpr()
end

---@param bufnr integer
function M.on_write(bufnr)
	local is_enabled = vim.F.if_nil(
		vim.b[bufnr].format_on_save,
		vim.g.format_on_save,
		true
	)

	if is_enabled then
		require("conform").format({
			buf = bufnr,
			timeout_ms = 1000,
		})
	end
end

return M
