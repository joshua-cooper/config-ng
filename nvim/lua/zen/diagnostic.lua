local M = {}

---@type vim.diagnostic.Severity[]
local SEVERITY_PRIORITY = {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
}

---@param bufnr? integer
---@return vim.diagnostic.Severity?
local function priority_severity(bufnr)
    local counts = vim.diagnostic.count(bufnr)

    for _, s in ipairs(SEVERITY_PRIORITY) do
        if counts[s] and counts[s] > 0 then
            return s
        end
    end
end

function M.jump_next()
    vim.diagnostic.jump({
        count = vim.v.count1,
        severity = priority_severity(0),
    })
end

function M.jump_previous()
    vim.diagnostic.jump({
        count = -vim.v.count1,
        severity = priority_severity(0),
    })
end

function M.jump_first()
    vim.diagnostic.jump({
        count = -math.ceil(math.huge),
        severity = priority_severity(0),
        wrap = false,
    })
end

function M.jump_last()
    vim.diagnostic.jump({
        count = math.ceil(math.huge),
        severity = priority_severity(0),
        wrap = false,
    })
end

function M.setqflist()
    vim.diagnostic.setqflist({
        severity = priority_severity(),
    })
end

function M.setloclist()
    vim.diagnostic.setloclist({
        severity = priority_severity(0),
    })
end

function M.open_float()
    vim.diagnostic.open_float({
        severity = priority_severity(0),
    })
end

return M
