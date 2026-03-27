local group = vim.api.nvim_create_augroup("zen.format", {})

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    desc = "Format the buffer on write",
    callback = function(args)
        require("zen.format").on_write(args.buf)
    end,
})

require("conform").setup({
    notify_no_formatters = false,
    notify_on_error = false,
    formatters_by_ft = {
        fish = { "fish_indent" },
        lua = { "stylua" },
        nix = { "treefmt", "nixfmt", stop_after_first = true },
        rust = { "rustfmt" },
        toml = { "taplo" },
    },
})
