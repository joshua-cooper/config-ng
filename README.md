## TODO

### nvim

- [ ] Rust support
	- [x] Figure out how rustaceanvim has 3 r-a processes for 2 projects when we have 4
	- [x] Expand macro
	- [x] Reload workspace
	- [x] Rebuild proc macros
	- [x] Open Cargo.toml
	- [x] Parent module
	- [ ] Runnables
	- [ ] Debuggables
	- [ ] Verify the cargo/git registry patterns against edge case crate names
- [x] `busy` in statusline
- [ ] completeopts
- [ ] Refine options
- [ ] Keymaps
- [ ] Highlight indentation using the wrong whitespace (e.g. tabs when `expandtab = true`)
- [ ] Treesitter
  - [ ] Set up parsers
  - [x] Add treesitter support to foldexpr
- [ ] Theme
- [ ] oil?
- [ ] Disable backups when editing sensitive files
- [ ] nvim directory based git difftool
- [ ] `set splitkeep`
- [ ] `set diffopt+=inline:char`
- [ ] Check `vim.wo.{opt}` vs `vim.wo[winnr][bufnr].{opt}`

#### Later

- [ ] `foldopen` and `foldclose` `fillchars`
- [ ] `statuscolumn`
- [ ] surround plugin
- [ ] Custom codelens virtual text
- [ ] Fallback for HOME instead of asserting it
- [ ] Recalculate folds on LSP attach (`:help zx`)
- [ ] Consistent `vim.notify` usage
- [ ] Termux handling
	- [ ] path display
	- [ ] jumping to rust std item complains about std being nightly

#### Maybe

- [ ] Special case fugitive buffer names in statusline

#### Blocked

- [ ] Refresh codelens scoped per client (not currently supported in `vim.lsp.codelens.refresh`)
- [ ] Specify return type of `vim.diagnostic.count(bufnr)` to be `table<integer, integer>`
- [ ] BiDi support <https://github.com/neovim/neovim/issues/553>
	- [ ] Isolate statusline components (filename, each flag, etc.)
	- [ ] Independent statusline alignment for vertical splits
