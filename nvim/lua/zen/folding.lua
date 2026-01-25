local M = {}

---@param line integer
---@return integer
local function line_end_col(line)
	local c = vim.fn.virtcol({
		line,
		"$",
	})

	assert(type(c) == "number")

	return c - 2
end

---@param line integer
---@return string
function M.foldexpr(line)
	local buf = vim.api.nvim_get_current_buf()

	local clients = vim.lsp.get_clients({
		bufnr = buf,
		method = "textDocument/foldingRange",
	})

	local has_folding_client = vim.iter(clients):any(function(c)
		return not c:is_stopped()
	end)

	if has_folding_client then
		return vim.lsp.foldexpr(line)
	end

	return vim.treesitter.foldexpr(line)
end

---@param winnr integer
---@return boolean
function M.should_show_decoration(winnr)
	return (vim.wo[winnr].foldtext == "")
		and (vim.wo[winnr].fillchars:find("fold: ", 1, true) ~= nil)
end

---@param namespace integer
---@param winnr integer
---@param bufnr integer
---@param row integer
function M.set_fold_decoration(namespace, winnr, bufnr, row)
	---@type integer?
	local win_col = vim.api.nvim_win_call(winnr, function()
		local line = row + 1

		if vim.fn.foldclosed(line) ~= line then
			return
		end

		local scroll_offset = vim.fn.winsaveview().leftcol
		local text_end_win_col = line_end_col(line) - scroll_offset
		local indicator_win_col = text_end_win_col + 2
		local last_win_col = vim.api.nvim_win_get_width(winnr) - 1

		if text_end_win_col < 0 then
			return
		end

		if indicator_win_col > last_win_col then
			return
		end

		return indicator_win_col
	end)

	if not win_col then
		return
	end

	vim.api.nvim_buf_set_extmark(bufnr, namespace, row, 0, {
		virt_text = {
			{
				"⋯",
				"NonText",
			},
		},
		virt_text_win_col = win_col,
		hl_mode = "combine",
		priority = 200,
		ephemeral = true,
		strict = true,
	})
end

return M
