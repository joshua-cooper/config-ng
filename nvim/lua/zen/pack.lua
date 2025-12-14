local M = {}

---@param kind "install" | "update" | "delete"
---@param spec vim.pack.Spec
function M.on_changed(kind, spec)
	local data = spec.data or {}
	local callback_key = string.format("on_%s", kind)
	local callback = data[callback_key]

	if type(callback) ~= "function" then
		return
	end

	callback()
end

return M
