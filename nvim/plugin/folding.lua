local ns = vim.api.nvim_create_namespace("zen.folding.extmarks")

vim.api.nvim_set_decoration_provider(ns, {
	on_win = function(_, win, _, _, _)
		if vim.wo[win].foldtext ~= "" then
			return false
		end
	end,
	on_line = function(_, win, buf, row)
		---@type integer?
		local win_col = vim.api.nvim_win_call(win, function()
			local line = row + 1
			local fold_start = vim.fn.foldclosed(line)

			if fold_start ~= line then
				return nil
			end

			local virt  = vim.fn.virtcol({ line, "$" }) or 1
			local view  = vim.fn.winsaveview() or {}
			local left  = view.leftcol or 0 -- scrolled-off cols
			local width = vim.api.nvim_win_get_width(win)

			-- 0-based col of the *last real character* in the window
			local last  = (virt - 2) - left

			-- Hide as soon as the actual text is off the left edge
			if last < 0 then
				return nil
			end

			-- Keep a 1-cell gap between text and dot
			local GAP = 1
			local col = last + 1 + GAP

			-- If there's no room to render the gap+dot on the right, hide
			if col > (width - 1) then
				return nil
			end

			return col
		end)

		if not win_col then
			return nil
		end

		vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
			virt_text = { { "⋯", "NonText" } },
			virt_text_win_col = win_col,
			hl_mode = "combine",
			priority = 200,
			ephemeral = true,
			strict = false,
		})
	end,
})

vim.o.foldexpr = "v:lua.require'zen.folding'.foldexpr()"
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldtext = ""
