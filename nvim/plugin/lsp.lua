for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
	vim.lsp.enable(vim.fn.fnamemodify(path, ":t:r"))
end
