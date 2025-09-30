local ns = vim.api.nvim_create_namespace("zen.folding.extmarks")

vim.api.nvim_set_decoration_provider(ns, {
	on_win = function(_, win, _, _, _)
		if vim.wo[win].foldtext ~= "" then
			return false
		end

		if not vim.wo[win].fillchars:find("fold: ", 1, true) then
			return false
		end
	end,
	on_line = function(_, win, buf, row)
		---@type integer?
		local win_column = vim.api.nvim_win_call(win, function()
			local line = row + 1

			if vim.fn.foldclosed(line) ~= line then
				return nil
			end

			---@type integer
			local line_end_column = vim.fn.virtcol({ line, "$" }) - 1
			local scroll_offset = vim.fn.winsaveview().leftcol
			local text_end_win_column = line_end_column - scroll_offset - 1
			local indicator_win_column = text_end_win_column + 2

			if text_end_win_column < 0 then
				return nil
			end

			if indicator_win_column > vim.api.nvim_win_get_width(win) - 1 then
				return nil
			end

			return indicator_win_column
		end)

		if not win_column then
			return nil
		end

		vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
			virt_text = { { "⋯", "NonText" } },
			virt_text_win_col = win_column,
			hl_mode = "combine",
			priority = 200,
			ephemeral = true,
			strict = true,
		})
	end,
})

vim.o.foldexpr = "v:lua.require'zen.folding'.foldexpr()"
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
