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

---@param button string
function M.on_fold_click(_, _, button, _)
	if button == "l" then
		vim.cmd("silent! normal! za")
	end
end

---@return string
function M.statuscolumn()
	local winnr = statusline_winid() or vim.api.nvim_get_current_win()
	local has_foldcolumn = vim.wo[winnr].foldcolumn ~= "0"
	local has_number = vim.wo[winnr].number or vim.wo[winnr].relativenumber

	local parts = {} ---@as string[]

	if has_foldcolumn then
		local on_click = "v:lua.require'zen.statuscolumn'.on_fold_click"
		parts[#parts + 1] = string.format("%%@%s@%%C%%X ", on_click)
	end

	if has_number then
		parts[#parts + 1] = "%l "
	end

	return table.concat(parts)
end

return M
