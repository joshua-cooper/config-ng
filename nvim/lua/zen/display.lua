---@class KnownPaths
---@field cwd string

local M = {}

---@param path string
---@param known_paths KnownPaths
---@return string
function M.path(path, known_paths)
	if path == "" then
		return path
	end

	---@type [string, (string|function)][]
	local patterns = {
		{
			"^/nix/store/[0-9a-z]+%-([^/]+)/",
			"[nix:%1] ",
		},
	}

	if known_paths.cwd ~= "" and known_paths.cwd ~= "/" then
		patterns[#patterns + 1] = {
			("^%s/"):format(vim.pesc(known_paths.cwd)),
			"",
		}
	end

	for _, pattern in ipairs(patterns) do
		local custom_path, n = path:gsub(pattern[1], pattern[2], 1)

		if n > 0 then
			return custom_path
		end
	end

	return path
end

return M
