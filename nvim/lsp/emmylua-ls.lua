local uv = vim.uv or vim.loop

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

	local normalized = vim.fs.normalize(path)
	local realpath = uv and uv.fs_realpath(normalized) or nil

	return realpath or normalized
end

---@return string?
local function myvimrc_root()
	local myvimrc = normalize(vim.env.MYVIMRC)

	if myvimrc then
		return vim.fs.dirname(myvimrc)
	end

	return normalize(vim.fn.stdpath("config"))
end

---@return string[]
local function vim_dirs()
	local dirs = {}
	local seen = {}

	local function add(path)
		if not path or seen[path] then
			return
		end

		table.insert(dirs, path)
		seen[path] = true
	end

	local runtimepath = vim.o.runtimepath

	if type(runtimepath) == "string" and runtimepath ~= "" then
		for _, entry in
			ipairs(vim.split(runtimepath, ",", {
				trimempty = true,
			}))
		do
			add(normalize(entry))
		end
	end

	add(myvimrc_root())

	return dirs
end

local nvim_local_dirs = {}

---@param path string?
---@return boolean
local function is_nvim_local_file(path)
	if not path then
		return false
	end

	return vim.fs.basename(path) == ".nvim.lua"
end

---@param path string?
---@return boolean
local function is_nvim_local_root(path)
	if not path then
		return false
	end

	return nvim_local_dirs[path] == true
end

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
---@return string?
local function resolve_runtime_root(path)
	if not path then
		return nil
	end

	for _, dir in ipairs(vim_dirs()) do
		if is_descendant(path, dir) then
			return dir
		end
	end
end

---@param path string?
---@return boolean
local function is_runtime_root(path)
	if not path then
		return false
	end

	for _, dir in ipairs(vim_dirs()) do
		if dir == path then
			return true
		end
	end

	return false
end

---@param bufnr integer
---@param on_dir fun(root_dir?: string)
local function root_dir(bufnr, on_dir)
	local buf_name = vim.api.nvim_buf_get_name(bufnr)

	if buf_name ~= "" then
		local normalized = normalize(buf_name)

		local runtime_root = resolve_runtime_root(normalized)

		if runtime_root then
			on_dir(runtime_root)
			return
		end

		if is_nvim_local_file(normalized) then
			local parent = normalize(vim.fs.dirname(normalized))

			if parent then
				nvim_local_dirs[parent] = true
				on_dir(parent)
				return
			end
		end
	end

	on_dir(vim.fs.root(bufnr, ROOT_MARKERS))
end

---@param _ lsp.InitializeParams
---@param config vim.lsp.ClientConfig
local function before_init(_, config)
	local root = normalize(config.root_dir)

	local is_runtime = is_runtime_root(root)
	local is_local = is_nvim_local_root(root)

	if not is_runtime and not is_local then
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

	for _, dir in ipairs(vim_dirs()) do
		add_library(dir)
	end

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

	if is_runtime_root(client_root) and is_runtime_root(config_root) then
		return true
	end

	if is_nvim_local_root(client_root) and is_nvim_local_root(config_root) then
		return client_root == config_root
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
