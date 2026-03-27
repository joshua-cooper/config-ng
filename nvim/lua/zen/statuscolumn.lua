local M = {}

---@return integer?
local function statusline_winid()
    local winnr = vim.g.statusline_winid

    if winnr == nil then
        return nil
    end

    assert(
        type(winnr) == "number" and math.floor(winnr) == winnr,
        "vim.g.statusline_winid should be an integer"
    )

    ---@cast winnr integer

    return winnr
end

---@return string
function M.statuscolumn()
    local winnr = statusline_winid() or vim.api.nvim_get_current_win()
    local has_foldcolumn = vim.wo[winnr].foldcolumn ~= "0"
    local has_number = vim.wo[winnr].number or vim.wo[winnr].relativenumber

    ---@type string[]
    local parts = {}

    if has_foldcolumn then
        parts[#parts + 1] = "%C "
    end

    if has_number then
        parts[#parts + 1] = "%l "
    end

    return table.concat(parts)
end

return M
