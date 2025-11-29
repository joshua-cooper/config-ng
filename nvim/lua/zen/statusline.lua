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

---@param winnr integer
---@param bufnr integer
---@return string
local function buffer_name(winnr, bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	local buftype = vim.bo[bufnr].buftype
	local filetype = vim.bo[bufnr].filetype

	if filetype == "oil" then
		name = name:gsub("^oil://", ""):gsub("/$", "")
	end

	if buftype == "quickfix" then
		local win_type = vim.fn.win_gettype(winnr)
		local title = vim.w[winnr].quickfix_title

		if title == nil then
			return string.format("[%s]", win_type)
		else
			assert(type(title) == "string")
			return string.format("[%s] %s", win_type, title)
		end
	end

	if buftype == "help" then
		local help_page = vim.fs.basename(name)
		return string.format("[help] %s", help_page)
	end

	if buftype == "terminal" then
		local command = name:gsub("^term://.-//[0-9]+:", "")
		return string.format("[terminal] %s", command)
	end

	local scheme, resource = name:match("^([%w%-]+)://(.*)$")

	if scheme then
		assert(type(resource) == "string")

		if resource == "" then
			return string.format("[%s]", scheme)
		else
			return string.format("[%s] %s", scheme, resource)
		end
	end

	if name == "" then
		return "[scratch]"
	end

	local zen_path = require("zen.path")
	local known_paths = zen_path.known_paths(winnr)

	return zen_path.format(name, known_paths)
end

---@param bufnr integer
---@return string?
local function buffer_flags(bufnr)
	local flags = {} ---@as string[]

	local fileencoding = vim.bo[bufnr].fileencoding
	local fileformat = vim.bo[bufnr].fileformat
	local has_diagnostics = #vim.diagnostic.get(bufnr) > 0
	local is_modified = vim.bo[bufnr].modified

	if fileencoding ~= "" and fileencoding ~= "utf-8" then
		flags[#flags + 1] = string.format("[%s]", fileencoding)
	end

	if fileformat ~= "unix" then
		flags[#flags + 1] = string.format("[%s]", fileformat)
	end

	if has_diagnostics then
		flags[#flags + 1] = "[×]"
	end

	if is_modified then
		flags[#flags + 1] = "[+]"
	end

	if #flags == 0 then
		return
	end

	return table.concat(flags)
end

---@return string
function M.statusline()
	local winnr = statusline_winid() or vim.api.nvim_get_current_win()
	local bufnr = vim.api.nvim_win_get_buf(winnr)

	local start_parts = {} ---@as string[]
	local end_parts = {} ---@as string[]

	local name = buffer_name(winnr, bufnr)
	local flags = buffer_flags(bufnr)
	local is_busy = vim.fn.has("nvim-0.12") == 1 and vim.bo[bufnr].busy ~= 0

	start_parts[#start_parts + 1] = name

	if flags then
		start_parts[#start_parts + 1] = flags
	end

	if is_busy then
		end_parts[#end_parts + 1] = "◐"
	end

	return string.format(
		" %s %%= %s ",
		table.concat(start_parts, " "),
		table.concat(end_parts, " ")
	)
end

return M
