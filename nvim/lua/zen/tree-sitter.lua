local M = {}

function M.on_update()
    require("nvim-treesitter").update():wait()
end

return M
