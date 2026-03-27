local group = vim.api.nvim_create_augroup("zen.whitespace", {})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
    group = group,
    desc = "Show trailing whitespace",
    callback = function(_)
        require("zen.whitespace").highlight()
    end,
})

vim.api.nvim_create_autocmd({ "InsertEnter", "OptionSet" }, {
    group = group,
    desc = "Hide trailing whitespace in insert mode",
    callback = function(args)
        if args.event == "OptionSet" and args.match ~= "buftype" then
            return
        end

        require("zen.whitespace").unhighlight()
    end,
})
