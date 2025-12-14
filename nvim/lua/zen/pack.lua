local M = {}

---@param kind "install" | "update" | "delete"
---@param spec vim.pack.Spec
function M.on_changed(kind, spec)
	local callback_key = string.format("on_%s", kind)
	local callback = spec.data[callback_key]

	if type(callback) ~= "function" then
		return
	end

	callback()
end

return M
