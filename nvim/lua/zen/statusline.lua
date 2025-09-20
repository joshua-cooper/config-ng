local M = {}

---@param arr string[]
---@param s string
local function push_non_empty_string(arr, s)
	if s ~= "" then
		arr[#arr + 1] = s
	end
end

---@param win integer
---@param buf integer
---@return string
local function buffer_name(win, buf)
	local name = vim.api.nvim_buf_get_name(buf)

	if vim.bo[buf].buftype == "help" then
		return ("[help] %s"):format(vim.fn.fnamemodify(name, ":t"))
	end

	if vim.bo[buf].buftype == "quickfix" then
		local win_type = vim.fn.win_gettype(win)

		---@type unknown
		local title = vim.w[win].quickfix_title

		if title == "" then
			return ("[%s]"):format(win_type)
		else
			return ("[%s] %s"):format(win_type, title)
		end
	end

	if vim.bo[buf].buftype == "terminal" then
		return ("[term] %s"):format((name:gsub("^term://.-//[0-9]+:", "")))
	end

	local protocol, content = name:match("^([%w%-]+)://(.+)$")

	if protocol then
		return ("[%s] %s"):format(protocol, content)
	end

	if vim.bo[buf].buftype ~= "" then
		return name
	end

	if name == "" then
		return "[No Name]"
	end

	return require("zen.display").path(name, {
		cwd = vim.fn.getcwd(),
	})
end

---@param buf integer
---@return string
local function buffer_flags(buf)
	local flags = {}
	local fileencoding = vim.bo[buf].fileencoding
	local fileformat = vim.bo[buf].fileformat

	if fileencoding ~= "" and fileencoding ~= "utf-8" then
		flags[#flags + 1] = ("[%s]"):format(fileencoding)
	end

	if fileformat ~= "unix" then
		flags[#flags + 1] = ("[%s]"):format(fileformat)
	end

	if #vim.diagnostic.get(buf) > 0 then
		flags[#flags + 1] = "[×]"
	end

	if vim.bo[buf].modified then
		flags[#flags + 1] = "[+]"
	end

	return table.concat(flags)
end

---@return string
function M.statusline()
	local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	local start_parts = {}
	local end_parts = {}

	push_non_empty_string(start_parts, buffer_name(win, buf))
	push_non_empty_string(start_parts, buffer_flags(buf))

	return ("%s%%=%s"):format(
		table.concat(start_parts, " "),
		table.concat(end_parts, " ")
	)
end

return M
