-- TODO:
--   - show file encoding and line endings if they aren't typical (utf-8, unix)
--   - redraw on diagnostic updates

local M = {}

---@param buf integer
---@return string
local function buffer_name(buf)
	local name = vim.api.nvim_buf_get_name(buf)

	if name == "" then
		return "[No Name]"
	end

	if vim.bo[buf].buftype == "help" then
		return ("[help] %s"):format(vim.fn.fnamemodify(name, ":t"))
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

	return require("zen.display").path(name, {
		cwd = vim.fn.getcwd(),
	})
end

---@param buf integer
---@return string
local function buffer_flags(buf)
	local flags = {}

	if #vim.diagnostic.get(buf) > 0 then
		flags[#flags + 1] = "[×]"
	end

	if vim.bo[buf].modified then
		flags[#flags + 1] = "[+]"
	end

	if #flags == 0 then
		return ""
	else
		return table.concat(flags)
	end
end

---@return string
function M.statusline()
	local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)

	return table.concat({
		buffer_name(buf),
		" ",
		buffer_flags(buf),
		"%=",
		"● ◉ ⊘ 🔒",
	})
end

return M
