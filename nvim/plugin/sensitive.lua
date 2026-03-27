local group = vim.api.nvim_create_augroup("zen.sensitive", {})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = group,
    pattern = {
        "*/pass.*",
        "*/passage.*",
        "*/gopass-*",
    },
    desc = "Prevent leaking sensitive buffer contents",
    callback = function(args)
        vim.bo[args.buf].swapfile = false
        vim.bo[args.buf].undofile = false
        vim.o.shada = ""
        vim.o.backup = false
        vim.o.writebackup = false
    end,
})
