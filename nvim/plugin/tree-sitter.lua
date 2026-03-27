require("nvim-treesitter.configs").setup({
    modules = {},
    auto_install = false,
    sync_install = true,
    ignore_install = {},
    ensure_installed = {
        "css",
        "fish",
        "html",
        "javascript",
        "json",
        "nix",
        "rust",
        "toml",
        "yaml",
    },
})
