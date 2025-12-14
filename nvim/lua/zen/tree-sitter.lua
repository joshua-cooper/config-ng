local M = {}

function M.on_install()
	vim.notify("Installing tree-sitter parsers", vim.log.levels.INFO)

	-- TODO
end

function M.on_update()
	vim.notify("Updating tree-sitter parsers", vim.log.levels.INFO)

	local opts = {
		summary = true,
	}

	require("nvim-treesitter").update(nil, opts):wait(60000)
end

return M
