local namespace = vim.api.nvim_create_namespace("zen.fold")

vim.api.nvim_set_decoration_provider(namespace, {
    on_win = function(_, winnr, _, _, _)
        return require("zen.fold").should_show_decoration(winnr)
    end,
    on_range = function(_, winnr, bufnr, begin_row, _, _, _)
        require("zen.fold").set_fold_decoration(
            namespace,
            winnr,
            bufnr,
            begin_row
        )
    end,
})
