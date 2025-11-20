local M = {}

---@class KnownPaths
---@field cwd string
---@field cargo_home string

local NIX_STORE_PATTERN = {
	"^/nix/store/[0-9a-z]+%-([^/]+)/",
	"[nix:%1] ",
}

---@param registry string
---@param crate string
---@return string
local function format_cargo_registry(registry, crate)
	if registry == "index.crates.io" then
		registry = "crates.io"
	end

	return string.format("[%s:%s] ", registry, crate)
end

---@param cargo_home string
---@return [string, function]
local function cargo_registry_pattern(cargo_home)
	return {
		string.format(
			"^%s/registry/src/([^/]+)-[0-9a-f]+/([^/]+)/",
			cargo_home
		),
		format_cargo_registry,
	}
end

---@param cargo_home string
---@return [string, string]
local function cargo_git_pattern(cargo_home)
	return {
		string.format(
			"^%s/git/checkouts/([^/]+)-[0-9a-f]+/[0-9a-f]+/",
			cargo_home
		),
		"[cargo-git:%1] ",
	}
end

---@param cwd string
---@return [string, string]
local function cwd_pattern(cwd)
	return {
		(cwd == "" or cwd == "/") and "^$"
			or string.format("^%s/", vim.pesc(cwd)),
		"",
	}
end

---@param winnr integer
---@return KnownPaths
function M.known_paths(winnr)
	return {
		cwd = vim.fn.getcwd(winnr),
		cargo_home = vim.env.CARGO_HOME or vim.fs.joinpath(
			assert(vim.uv.os_homedir()),
			".cargo"
		),
	}
end

---@param path string
---@param known_paths KnownPaths
---@return string
function M.format(path, known_paths)
	if path == "" then
		return path
	end

	local patterns = { ---@as [string, string|function][]
		NIX_STORE_PATTERN,
		cargo_registry_pattern(known_paths.cargo_home),
		cargo_git_pattern(known_paths.cargo_home),
		cwd_pattern(known_paths.cwd),
	}

	for _, pattern in ipairs(patterns) do
		local s, n = path:gsub(pattern[1], pattern[2], 1)

		if n > 0 then
			return s
		end
	end

	return path
end

return M
