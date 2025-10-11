---@class KnownPaths
---@field cwd string
---@field cargo_home string

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
		{
			("^%s/registry/src/([^/]+)-[0-9a-f]+/([^/]+)/"):format(known_paths.cargo_home),
			function(registry, crate)
				if registry == "index.crates.io" then
					registry = "crates.io"
				end

				return ("[%s:%s] "):format(registry, crate)
			end,
		},
		{
			("^%s/git/checkouts/([^/]+)-[0-9a-f]+/[0-9a-f]+/"):format(known_paths.cargo_home),
			"[cargo-git:%1] ",

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
