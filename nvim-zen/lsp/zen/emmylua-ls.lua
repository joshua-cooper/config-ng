local ROOT_MARKERS = {
	".emmyrc.json",
	".luarc.json",
}

local GLOBAL_EMMYLUA_SETTINGS = {
	codeLens = {
		enable = false,
	},
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
}

---@return string[]
local function list_runtime_paths()
	return vim.tbl_map(
		vim.uv.fs_realpath,
		vim.api.nvim_list_runtime_paths()
	)
end

---@param path string
---@return string?
local function runtime_path_dir(path)
	for _, rtp in ipairs(list_runtime_paths()) do
		if vim.fs.relpath(rtp, path) then
			return rtp
		end
	end
end

---@param path string
---@return boolean
local function is_in_runtime_path(path)
	return runtime_path_dir(path) ~= nil
end

---@param bufnr integer
---@param on_dir fun(root_dir: string?)
local function root_dir(bufnr, on_dir)
	on_dir(
		runtime_path_dir(vim.api.nvim_buf_get_name(bufnr))
			or vim.fs.root(bufnr, ROOT_MARKERS)
	)
end

---@param client vim.lsp.Client
---@param config vim.lsp.ClientConfig
---@return boolean
local function reuse_client(client, config)
	if client.name ~= config.name then
		return false
	end

	if not client.root_dir or not config.root_dir then
		return false
	end

	local is_nvim_client = is_in_runtime_path(client.root_dir)
	local is_nvim_config = is_in_runtime_path(config.root_dir)

	if is_nvim_client ~= is_nvim_config then
		return false
	end

	return (is_nvim_client and is_nvim_config)
		or (client.root_dir == config.root_dir)
end

---@param _params lsp.InitializeParams
---@param config vim.lsp.ClientConfig
local function before_init(_params, config)
	if not config.root_dir then
		return
	end

	if not is_in_runtime_path(config.root_dir) then
		return
	end

	local nvim_emmylua_settings = {
		runtime = {
			version = "LuaJIT",
		},
		workspace = {
			library = list_runtime_paths(),
		},
		strict = {
			requirePath = false,
			typeCall = true,
			arrayIndex = true,
			metaOverrideFileDefine = true,
		},
	}

	config.settings = config.settings or {}
	config.settings.emmylua = vim.tbl_deep_extend(
		"force",
		config.settings.emmylua or {},
		nvim_emmylua_settings
	)
end

---@type vim.lsp.Config
return {
	cmd = {
		"emmylua_ls",
	},
	filetypes = {
		"lua",
	},
	settings = {
		emmylua = GLOBAL_EMMYLUA_SETTINGS,
	},
	workspace_required = false,
	root_dir = root_dir,
	reuse_client = reuse_client,
	before_init = before_init,
}
