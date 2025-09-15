---@class QuickfixTextFuncInfo
---@field quickfix 1|0
---@field winid integer
---@field id integer
---@field start_idx integer
---@field end_idx integer

---@class QuickfixItem
---@field bufnr integer
---@field col integer
---@field lnum integer
---@field end_col integer
---@field end_lnum integer
---@field module string
---@field pattern string
---@field text string
---@field type string
---@field nr integer
---@field valid 0|1
---@field vcol 0|1

local M = {}

---@param info QuickfixTextFuncInfo
---@return QuickfixItem[]
local function get_items(info)
	local opts = {
		id = info.id,
		items = 0,
	}

	if info.quickfix == 1 then
		return vim.fn.getqflist(opts).items
	else
		return vim.fn.getloclist(info.winid, opts).items
	end
end

---@param item QuickfixItem
---@param known_paths KnownPaths
---@return string
local function format_label(item, known_paths)
	if item.module ~= "" then
		return item.module
	end

	local label = ""

	if item.bufnr > 0 then
		label = vim.api.nvim_buf_get_name(item.bufnr)
	end

	return require("zen.display").path(label, known_paths)
end

---@param item QuickfixItem
---@return string
local function format_metadata(item)
	---@type string[]
	local parts = {}

	if item.lnum > 0 then
		local col = math.max(item.col, 1)
		parts[#parts + 1] = ("%d:%d"):format(item.lnum, col)
	elseif item.pattern ~= "" then
		parts[#parts + 1] = item.pattern
	end

	if item.type ~= "" then
		local type = item.type

		if type == "E" then
			type = "error"
		elseif type == "W" then
			type = "warning"
		elseif type == "I" then
			type = "info"
		elseif type == "N" then
			type = "note"
		end

		parts[#parts + 1] = type
	end

	if item.nr > 0 then
		if item.type == "" then
			parts[#parts + 1] = "error"
		end

		parts[#parts + 1] = tostring(item.nr)
	end

	return table.concat(parts, " ")
end

---@param message string
---@return string
local function format_message(message)
	return (message:gsub("[%c]+", " "):gsub("^%s+", ""):gsub("%s+$", ""))
end

---@param info QuickfixTextFuncInfo
---@return string[]
function M.quickfixtextfunc(info)
	local items = get_items(info)

	---@type string[]
	local formatted_items = {}

	---@type KnownPaths
	local known_paths = {
		cwd = vim.fn.getcwd(),
	}

	for i = info.start_idx, info.end_idx do
		---@type string[]
		local parts = {}

		local item = items[i]
		local label = format_label(item, known_paths)
		local metadata = format_metadata(item)
		local message = format_message(item.text)

		if label ~= "" then
			parts[#parts + 1] = label
		end

		parts[#parts + 1] = ("|%s|"):format(metadata)

		if message ~= "" then
			parts[#parts + 1] = message
		end

		formatted_items[#formatted_items + 1] = table.concat(parts, " ")
	end

	return formatted_items
end

return M
