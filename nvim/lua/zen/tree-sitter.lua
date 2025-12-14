local M = {}

function M.on_update()
	vim.notify("Updating tree-sitter parsers", vim.log.levels.INFO)

	vim.cmd.TSUpdateSync()
end

return M
