-- TODO: custom commands for stuff like expand macro, reload workspace, etc.

local M = {}

---@param command lsp.Command
local function run_cargo_command(command)
	local args = command.arguments[1].args
	local cargo_command = { "cargo" }

	for _, arg in ipairs(args.cargoArgs or {}) do
		table.insert(cargo_command, arg)
	end

	for _, arg in ipairs(args.cargoExtraArgs or {}) do
		table.insert(cargo_command, arg)
	end

	table.insert(cargo_command, "--")

	for _, arg in ipairs(args.executableArgs or {}) do
		table.insert(cargo_command, arg)
	end

	vim.print(cargo_command)

	-- TODO: run `cargo_command` with terminal in `args.workspaceRoot`
end

---@param command lsp.Command
function M.run_single(command)
	run_cargo_command(command)
end

---@param command lsp.Command
function M.debug_single(command)
	run_cargo_command(command)
end

function M.expand_macro()
end

function M.reload_workspace()
end

return M
