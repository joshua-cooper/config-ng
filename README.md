## TODO

### nvim

- [ ] Rust support
	- [x] Figure out how rustaceanvim has 3 r-a processes for 2 projects when we have 4
	- [x] Expand macro
	- [x] Reload workspace
	- [x] Rebuild proc macros
	- [x] Open Cargo.toml
	- [x] Parent module
	- [x] Runnables
	- [ ] Verify the cargo/git registry patterns against edge case crate names
- [x] `busy` in statusline
- [x] completeopts
- [x] Refine options
- [ ] Keymaps
- [ ] Treesitter
  - [ ] Set up parsers
  - [x] Add treesitter support to foldexpr
- [ ] Theme
- [ ] oil?
- [ ] Disable backups when editing sensitive files
- [ ] nvim directory based git difftool
- [x] `set splitkeep`
- [x] `set diffopt+=inline:char`
- [ ] Check `vim.wo.{opt}` vs `vim.wo[winnr][bufnr].{opt}`
- [ ] variable to prevent lsp auto start
- [ ] final audit missing options

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
- [ ] rust-analyzer debuggables
- [ ] Figure out a solution for overriding options from .nvim.lua (e.g. init.lua vs plugin/X.lua source order)
- [ ] Manual truncation of statusline when too long (avoids default `>`)
- [ ] Fix c-n, c-p with 1 (or any?) match when using `fuzzy` completeopt. Currently the first is skipped.
- [ ] `set formatoptions` (add `n` and `/`)
- [ ] Highlight indentation using the wrong whitespace (e.g. tabs when `expandtab = true`)

#### Maybe

- [ ] Special case fugitive buffer names in statusline

#### Blocked

- [ ] Refresh codelens scoped per client (not currently supported in `vim.lsp.codelens.refresh`)
- [ ] Specify return type of `vim.diagnostic.count(bufnr)` to be `table<integer, integer>`
- [ ] BiDi support <https://github.com/neovim/neovim/issues/553>
	- [ ] Isolate statusline components (filename, each flag, etc.)
	- [ ] Independent statusline alignment for vertical splits
