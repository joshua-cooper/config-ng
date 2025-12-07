local M = {}

---@return integer?
local function statusline_winid()
	local winnr = vim.g.statusline_winid

	if winnr == nil then
		return nil
	end

	assert(
		type(winnr) == "number" and math.floor(winnr) == winnr,
		"vim.g.statusline_winid should be an integer"
	)

	return winnr ---@as integer
end

---@return string
function M.statuscolumn()
	local s = ""

	local winnr = statusline_winid() or vim.api.nvim_get_current_win()
	local has_foldcolumn = vim.wo[winnr].foldcolumn ~= "0"
	local has_number = vim.wo[winnr].number or vim.wo[winnr].relativenumber

	if has_foldcolumn then
		s = s .. "%C "
	end

	if has_number then
		s = s .. "%l "
	end

	return s
end

return M
