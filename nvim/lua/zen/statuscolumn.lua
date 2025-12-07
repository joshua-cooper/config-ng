local M = {}

---@return string
function M.statuscolumn()
	local s = ""

	if vim.wo.foldcolumn ~= "0" then
		s = s .. "%C "
	end

	if vim.wo.number or vim.wo.relativenumber then
		s = s .. "%l "
	end

	return s
end

return M
