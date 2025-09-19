---@param client_id integer
---@param buf integer
---@return string
local function client_group_name(client_id, buf)
	return ("zen.lsp.client:%d_%d"):format(client_id, buf)
end

local function toggle_inlay_hints()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("zen.lsp.attach", {
		clear = true,
	}),
	desc = "Set up LSP client",
	callback = function(lsp_attach_args)
		local buf = lsp_attach_args.buf
		local client = assert(vim.lsp.get_client_by_id(lsp_attach_args.data.client_id))
		local group_name = client_group_name(client.id, buf)
		local group = vim.api.nvim_create_augroup(group_name, {
			clear = true,
		})

		if client:supports_method("textDocument/completion", buf) then
			vim.lsp.completion.enable(true, client.id, buf, {
				autotrigger = false,
			})
		end

		if not client:supports_method("textDocument/willSaveWaitUntil", buf)
		    and client:supports_method("textDocument/formatting", buf) then
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = group,
				buffer = buf,
				desc = "Format the buffer on save",
				callback = function(_)
					---@type unknown
					local should_format = vim.b[buf].lsp_autoformat

					if should_format == nil then
						---@type unknown
						should_format = vim.g.lsp_autoformat
					end

					if should_format == nil then
						should_format = true
					end

					if should_format then
						vim.lsp.buf.format({
							id = client.id,
							bufnr = buf,
						})
					end
				end,
			})
		end

		if client:supports_method("textDocument/codeLens", buf) then
			local events = {
				"LspProgress",
				"BufEnter",
				"TextChanged",
				"InsertLeave",
			}

			vim.api.nvim_create_autocmd(events, {
				group = group,
				buffer = buf,
				desc = "Refresh codelens",
				callback = function(args)
					if args.event ~= "LspProgress" or args.file == "end" then
						-- TODO: Once `refresh` can be scoped per client, add the client ID here.
						vim.lsp.codelens.refresh({
							bufnr = buf,
						})
					end
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = vim.api.nvim_create_augroup("zen.lsp.detach", {
		clear = true,
	}),
	desc = "Clean up LSP client",
	callback = function(lsp_detach_args)
		local buf = lsp_detach_args.buf
		local client = assert(vim.lsp.get_client_by_id(lsp_detach_args.data.client_id))
		local group_name = client_group_name(client.id, buf)

		if client:supports_method("textDocument/completion", buf) then
			-- TODO: Uncomment this once nvim properly handles it.
			-- vim.lsp.completion.enable(false, client.id, buf)
		end

		vim.api.nvim_del_augroup_by_name(group_name)
	end,
})

vim.keymap.set("n", "grh", toggle_inlay_hints, {
	desc = "Toggle inlay hints",
})

if vim.g.lsp_autostart ~= false then
	for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
		vim.lsp.enable(vim.fn.fnamemodify(path, ":t:r"))
	end
end
