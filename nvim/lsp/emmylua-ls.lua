-- TODO:
-- - handle .nvim.lua files as part of the vim scoped client (need to figure out what root_dir to use)
-- - verify if symlinks to MYVIMRC work well from both src and target
-- - should we actually just be using runtimepath instead of VIMRUNTIME and other stuff?

local ROOT_MARKERS = {
	".emmyrc.json",
	".luarc.json",
}

---@param path string?
---@return string?
local function normalize(path)
	if type(path) ~= "string" or path == "" then
		return nil
	end

	return vim.fs.normalize(path)
end

local RUNTIME_ROOT = normalize(vim.env.VIMRUNTIME)

---@return string?
local function resolve_myvimrc_root()
	local myvimrc = normalize(vim.env.MYVIMRC)

	if myvimrc then
		return vim.fs.dirname(myvimrc)
	end

	return normalize(vim.fn.stdpath("config"))
end

local MYVIMRC_ROOT = resolve_myvimrc_root()

---@param path string?
---@param root string?
---@return boolean
local function is_descendant(path, root)
	if not path or not root then
		return false
	end

	if path == root then
		return true
	end

	local prefix = root

	if prefix:sub(-1) ~= "/" then
		prefix = prefix .. "/"
	end

	return path:sub(1, #prefix) == prefix
end

---@param path string?
---@return boolean
local function is_vim_root(path)
	return path == RUNTIME_ROOT or path == MYVIMRC_ROOT
end

---@param bufnr integer
---@param on_dir fun(root_dir?: string)
local function root_dir(bufnr, on_dir)
	local buf_name = vim.api.nvim_buf_get_name(bufnr)

	if buf_name ~= "" then
		local normalized = vim.fs.normalize(buf_name)

		if is_descendant(normalized, RUNTIME_ROOT) then
			on_dir(RUNTIME_ROOT)
			return
		end

		if is_descendant(normalized, MYVIMRC_ROOT) then
			on_dir(MYVIMRC_ROOT)
			return
		end
	end

	on_dir(vim.fs.root(bufnr, ROOT_MARKERS))
end

---@param _ lsp.InitializeParams
---@param config vim.lsp.ClientConfig
local function before_init(_, config)
	local root = normalize(config.root_dir)

	if not is_vim_root(root) then
		return
	end

	config.settings = config.settings or {}
	config.settings.emmylua = config.settings.emmylua or {}
	config.settings.emmylua.workspace = config.settings.emmylua.workspace or {}
	config.settings.emmylua.runtime = config.settings.emmylua.runtime or {}

	config.settings.emmylua.runtime.version = "LuaJIT"

	local workspace = config.settings.emmylua.workspace
	local library = workspace.library and vim.deepcopy(workspace.library) or {}

	local function add_library(path)
		if not path then
			return
		end

		for _, existing in ipairs(library) do
			if existing == path then
				return
			end
		end

		table.insert(library, path)
	end

	add_library(RUNTIME_ROOT)
	add_library(MYVIMRC_ROOT)

	workspace.library = library
end

---@param client vim.lsp.Client
---@param config vim.lsp.ClientConfig
---@return boolean
local function reuse_client(client, config)
	if client.name ~= config.name then
		return false
	end

	local client_root = normalize(client.root_dir)
	local config_root = normalize(config.root_dir)

	if is_vim_root(client_root) and is_vim_root(config_root) then
		return true
	end

	return client_root ~= nil and client_root == config_root
end

---@type vim.lsp.Config
return {
	cmd = {
		"emmylua_ls",
	},
	filetypes = {
		"lua",
	},
	root_markers = ROOT_MARKERS,
	settings = {
		emmylua = {
			format = {
				externalTool = {
					program = "stylua",
					args = {
						"--stdin-filepath=${file}",
						"--indent-width=${indent_size}",
						"--indent-type=${use_tabs?Tabs:Spaces}",
						"-",
					},
				},
				externalToolRangeFormat = {
					program = "stylua",
					args = {
						"--stdin-filepath=${file}",
						"--indent-width=${indent_size}",
						"--indent-type=${use_tabs?Tabs:Spaces}",
						"--range-start=${start_offset}",
						"--range-end=${end_offset}",
						"-",
					},
				},
			},
		},
	},
	root_dir = root_dir,
	reuse_client = reuse_client,
	before_init = before_init,
}
