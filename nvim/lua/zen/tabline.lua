local M = {}

---@param is_current_tab boolean
---@return string
local function tab_highlight_group(is_current_tab)
	if is_current_tab then
		return "#TabLineSel#"
	else
		return "#TabLine#"
	end
end

---@param tabnr integer
---@return string
local function tab_label(tabnr)
	local custom_name = vim.t[tabnr].tab_name

	if type(custom_name) == "string" then
		return custom_name
	end

	local winnr = vim.api.nvim_tabpage_get_win(tabnr)
	local bufnr = vim.api.nvim_win_get_buf(winnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	local wintype = vim.fn.win_gettype(winnr)
	local buftype = vim.bo[bufnr].buftype
	local filetype = vim.bo[bufnr].filetype

	if filetype == "oil" then
		name = name:gsub("^oil://", ""):gsub("/$", "")
	end

	if wintype == "command" then
		return "[command]"
	end

	if wintype == "quickfix" or wintype == "loclist" then
		return string.format("[%s]", wintype)
	end

	if buftype == "help" then
		return "[help]"
	end

	if buftype == "terminal" then
		return "[terminal]"
	end

	local scheme = name:match("^([%w%-]+)://.*$")

	if scheme then
		return string.format("[%s]", scheme)
	end

	if name == "" then
		return "[scratch]"
	end

	return vim.fs.basename(name)
end

---@return string
function M.tabline()
	local tabs = vim.api.nvim_list_tabpages()
	local current_tab = vim.api.nvim_get_current_tabpage()

	local parts = {} ---@as string[]

	for i, tab in ipairs(tabs) do
		parts[#parts + 1] = string.format(
			"%%%s%%%dT %d:%s %%T",
			tab_highlight_group(tab == current_tab),
			i,
			i,
			tab_label(tab)
		)
	end

	parts[#parts + 1] = "%#TabLineFill#"

	return table.concat(parts)
end

return M
