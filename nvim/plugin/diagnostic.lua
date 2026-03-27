---@param method string
---@return fun()
local function lazy(method)
    return function()
        local f = assert(
            require("zen.diagnostic")[method],
            string.format("zen.diagnostic method '%s' should exist", method)
        )

        f()
    end
end

vim.keymap.set("n", "]d", lazy("jump_next"), {
    desc = "Jump to next priority diagnostic",
})

vim.keymap.set("n", "[d", lazy("jump_previous"), {
    desc = "Jump to previous priority diagnostic",
})

vim.keymap.set("n", "[D", lazy("jump_first"), {
    desc = "Jump to first priority diagnostic",
})

vim.keymap.set("n", "]D", lazy("jump_last"), {
    desc = "Jump to last priority diagnostic",
})

vim.keymap.set("n", "<leader>d", lazy("setqflist"), {
    desc = "Add priority diagnostics to quickfix",
})

vim.keymap.set("n", "<localleader>d", lazy("setloclist"), {
    desc = "Add priority diagnostics to loclist",
})

vim.keymap.set("n", "<c-w>d", lazy("open_float"), {
    desc = "Show priority diagnostics under the cursor",
})
