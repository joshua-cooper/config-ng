-- TODO:
--   - show file encoding and line endings if they aren't typical (utf-8, unix)
--   - show buffer flags (e.g. dirty)

local M = {}

---@param buf integer
---@return string
local function buffer_name(buf)
	local name = vim.api.nvim_buf_get_name(buf)

	if name == "" then
		return "[No Name]"
	end

	if vim.bo[buf].buftype == "help" then
		return vim.fn.fnamemodify(name, ":t")
	end

	if vim.bo[buf].buftype == "terminal" then
		return (name:gsub("^term://.-//[0-9]+:", "term://"))
	end

	if vim.bo[buf].buftype ~= "" then
		return name
	end

	local cwd_prefix = ("%s/"):format(vim.fn.getcwd())

	if vim.startswith(name, cwd_prefix) then
		return name:sub(#cwd_prefix + 1)
	end

	return name
end

function M.statusline()
	local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)

	return table.concat({
		buffer_name(buf),
		"%=",
		"WIP",
	})
end

return M
