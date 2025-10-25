---@type vim.diagnostic.SeverityInt[]
local SEVERITY_PRIORITY = {
	vim.diagnostic.severity.ERROR,
	vim.diagnostic.severity.WARN,
	vim.diagnostic.severity.INFO,
	vim.diagnostic.severity.HINT,
}

---@param bufnr? integer
---@return vim.diagnostic.SeverityInt?
local function priority_severity(bufnr)
	local counts = vim.diagnostic.count(bufnr)

	for _, s in ipairs(SEVERITY_PRIORITY) do
		if counts[s] and counts[s] > 0 then
			return s
		end
	end
end

local function jump_next()
	vim.diagnostic.jump({
		count = vim.v.count1,
		severity = priority_severity(0),
	})
end

local function jump_previous()
	vim.diagnostic.jump({
		count = -vim.v.count1,
		severity = priority_severity(0),
	})
end

local function jump_first()
	vim.diagnostic.jump({
		count = -math.ceil(math.huge),
		severity = priority_severity(0),
		wrap = false,
	})
end

local function jump_last()
	vim.diagnostic.jump({
		count = math.ceil(math.huge),
		severity = priority_severity(0),
		wrap = false,
	})
end

local function setqflist()
	vim.diagnostic.setqflist({
		severity = priority_severity(),
	})
end

local function setloclist()
	vim.diagnostic.setloclist({
		severity = priority_severity(0),
	})
end

vim.diagnostic.config({
	float = {
		header = "",
	},
	jump = {
		float = true,
		wrap = true,
	},
	severity_sort = true,
	signs = false,
	underline = false,
	update_in_insert = false,
	virtual_lines = false,
	virtual_text = false,
})

vim.keymap.set("n", "]d", jump_next, {
	desc = "Jump to the next priority diagnostic in the current buffer",
})

vim.keymap.set("n", "[d", jump_previous, {
	desc = "Jump to the previous priority diagnostic in the current buffer",
})

vim.keymap.set("n", "[D", jump_first, {
	desc = "Jump to the first priority diagnostic in the current buffer",
})

vim.keymap.set("n", "]D", jump_last, {
	desc = "Jump to the last priority diagnostic in the current buffer",
})

vim.keymap.set("n", "<leader>d", setqflist, {
	desc = "Add all priority diagnostics to the quickfix list",
})

vim.keymap.set("n", "<localleader>d", setloclist, {
	desc = "Add buffer priority diagnostics to the location list",
})
