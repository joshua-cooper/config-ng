## TODO

### nvim

- [ ] Rust support
	- [x] Figure out how rustaceanvim has 3 r-a processes for 2 projects when we have 4
	- [x] Expand macro
	- [x] Reload workspace
	- [x] Rebuild proc macros
	- [ ] Runnables
	- [ ] Debuggables
	- [ ] Open Cargo.toml
	- [ ] Verify the cargo/git registry patterns against edge case crate names
- [x] `busy` in statusline
- [ ] completeopts
- [ ] Refine options
- [ ] Keymaps
- [ ] Highlight indentation using the wrong whitespace (e.g. tabs when `expandtab = true`)
- [ ] Custom codelens virtual text
- [ ] Treesitter
  - [ ] Set up parsers
  - [ ] Add treesitter support to foldexpr
- [ ] Theme
- [ ] oil?
- [ ] Termux handling
	- [ ] path display
	- [ ] jumping to rust std item complains about std being nightly
- [ ] Disable backups when editing sensitive files
- [ ] nvim directory based git difftool

#### Later

- [ ] `foldopen` and `foldclose` `fillchars`
- [ ] `statuscolumn`
- [ ] surround plugin
- [ ] Fallback for HOME instead of asserting it
- [ ] Recalculate folds on LSP attach (`:help zx`)
- [ ] Clean up rust-analyzer keymaps on client exit
- [ ] Consistent `vim.notify` usage

#### Maybe

- [ ] Special case fugitive buffer names in statusline

#### Blocked

- [ ] Refresh codelens scoped per client (not currently supported in `vim.lsp.codelens.refresh`)
- [ ] BiDi support <https://github.com/neovim/neovim/issues/553>
	- [ ] Isolate statusline components (filename, each flag, etc.)
	- [ ] Independent statusline alignment for vertical splits
