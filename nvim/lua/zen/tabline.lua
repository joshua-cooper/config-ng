local M = {}

---@return string
function M.tabline()
	local tabs = vim.api.nvim_list_tabpages()
	local current_tab = vim.api.nvim_get_current_tabpage()

	---@type string[]
	local parts = { "%#TabLine#" }

	-- TODO: mouse support
	for i, tab in ipairs(tabs) do
		if tab == current_tab then
			parts[#parts + 1] = ("%%#TabLineSel# %d %%#TabLine#"):format(i)
		else
			parts[#parts + 1] = (" %d "):format(i)
		end
	end

	parts[#parts + 1] = "%#TabLineFill#"

	return table.concat(parts)
end

return M
