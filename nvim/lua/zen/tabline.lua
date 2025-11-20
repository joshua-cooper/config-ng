local M = {}

---@return string
function M.tabline()
	local tabs = vim.api.nvim_list_tabpages()
	local current_tab = vim.api.nvim_get_current_tabpage()

	---@type string[]
	local parts = {}

	for i, tab in ipairs(tabs) do
		local hl_group = tab == current_tab and "#TabLineSel#"
			or "#TabLine#"
		parts[#parts + 1] = ("%%%s%%%dT %d %%T"):format(hl_group, i, i)
	end

	parts[#parts + 1] = "%#TabLineFill#"

	return table.concat(parts)
end

return M
