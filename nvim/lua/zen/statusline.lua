-- TODO:
--   - relative paths under cwd
--   - show file encoding and line endings if they aren't typical (utf-8, unix)
--   - show buffer flags (e.g. dirty)

local M = {}

function M.statusline(info)
	return "%f%=WIP"
end

return M
