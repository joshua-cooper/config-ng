local M = {}

local GROUP = "ZenTrailingWhitespace"

local function has_match()
	for _, match in ipairs(vim.fn.getmatches()) do
		if match.group == GROUP then
			return true
		end
	end

	return false
end

function M.highlight()
	if vim.bo.buftype ~= "" or has_match() then
		return
	end

	vim.fn.matchadd(GROUP, [[\s\+$]], -1)
end

function M.unhighlight()
	for _, match in ipairs(vim.fn.getmatches()) do
		if match.group == GROUP then
			vim.fn.matchdelete(match.id)
		end
	end
end

return M
