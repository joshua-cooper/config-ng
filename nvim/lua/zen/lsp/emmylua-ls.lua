local M = {}

local ROOT_MARKERS = {
    ".emmyrc.json",
    ".luarc.json",
}

---@return string[]
local function list_runtime_paths()
    local paths = vim.api.nvim_list_runtime_paths()
    local vimrc = vim.env.MYVIMRC

    if vimrc then
        paths[#paths + 1] = vim.fs.dirname(vim.uv.fs_realpath(vimrc))
    end

    return vim.iter(paths):map(vim.uv.fs_realpath):totable()
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

---@param path string
---@return boolean
local function is_exrc(path)
    return vim.fs.basename(path) == ".nvim.lua"
end

---@param client vim.lsp.Client
local function apply_nvim_runtime_settings(client)
    client.settings = vim.tbl_deep_extend("force", client.settings, {
        emmylua = {
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
        },
    })

    client:notify("workspace/didChangeConfiguration", {
        settings = client.settings,
    })
end

---@param bufnr integer
---@param on_dir fun(root_dir: string?)
function M.root_dir(bufnr, on_dir)
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if is_exrc(bufname) then
        return
    end

    on_dir(runtime_path_dir(bufname) or vim.fs.root(bufnr, ROOT_MARKERS))
end

---@param client vim.lsp.Client
---@param config vim.lsp.ClientConfig
---@return boolean
function M.reuse_client(client, config)
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

---@param client vim.lsp.Client
---@param _init_result lsp.InitializeResult
function M.on_init(client, _init_result)
    if not client.root_dir then
        return
    end

    if not is_in_runtime_path(client.root_dir) then
        return
    end

    apply_nvim_runtime_settings(client)
end

---@param bufnr integer
---@param on_dir fun(root_dir: string?)
function M.exrc_root_dir(bufnr, on_dir)
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if not is_exrc(bufname) then
        return
    end

    on_dir(vim.fs.dirname(bufname))
end

---@param client vim.lsp.Client
---@param config vim.lsp.ClientConfig
---@return boolean
function M.exrc_reuse_client(client, config)
    return client.name == config.name and client.root_dir == config.root_dir
end

---@param client vim.lsp.Client
---@param _init_result lsp.InitializeResult
function M.exrc_on_init(client, _init_result)
    apply_nvim_runtime_settings(client)
end

return M
