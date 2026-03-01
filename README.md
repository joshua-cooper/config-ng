## TODO

### ghostty

- [ ] Custom Light + dark theme

### fish

- [x] custom prompt
- [x] Decide on fish formatting (use spaces for indent?)
- [x] wt function (git worktree cd)
- [ ] theme using terminal colors

### tmux

- [x] custom theme
- [x] bind y to copy without exiting copy mode
- [x] bind v to start selection
- [x] main-pane-{height,width}
- [x] window-status-*
- [x] update-environment
- [x] "setup" mode
- [x] rename session bind that pre-fills current dir

#### Later

- [x] set `cursor-colour` (doesn't support variables atm)
- [x] fix theme reloading bug for window{-active}-style and copy mode
      selection/popup and popup-style and menu style
- [x] add a `prompt-command-cursor-style` option
- [ ] fix bug when status is disabled and tab completing with the menu popup
      (the status pushes down the window content as if the status were enabled)
- [ ] Fix menu-border none (it currently pads things)
- [ ] Borders around stuff in choose tree needs bg set. (if terminal has its own
      bg, you can see it through borders)
- [ ] Can we customize format of term dimensions indicator on prefix + q (e.g.
      add padding)

### nvim

- [x] Theme
- [x] Remove the lazy lua magic
- [x] Audit missing options
- [x] Keymaps
- [x] LSP busy integration
- [x] Directory browser setup (netrw/oil?)
- [x] Fix status/tabline for command line windows (ctrl-f)
- [x] Refactor colorscheme
- [x] Set up tree-sitter parsers
- [x] Check if we can use `vim.tbl_get` anywhere
- [x] Check if @as type defs are correct or not
- [x] Fix rust analyzer util type warnings for emmylua + lua-ls
- [x] Remove bad diagnostic disables
- [ ] Theme

#### Later

- [x] Surround plugin
- [x] Directory based git difftool (new in 0.12)
- [x] `statuscolumn` (default is good if number + foldcolumn is enabled, but if
       only foldcolumn, it's too cramped. We want the same as default, but with
       a space between the buffer content and foldcolumn if only it is enabled)
- [x] Double click statuscolumn handler
- [x] Recalculate folds on LSP attach (`:help zx`)
- [x] Jumping to rust std item complains about std being nightly
- [x] LSP codelens
- [x] Custom codelens virtual text
- [x] rust-analyzer user commands
- [x] Check `function` vs `fun` type annotations
- [x] Variable to prevent auto format
- [x] Variable to prevent lsp auto start
- [x] Structure plugin setup (remove from init.lua?)
- [x] rename folding to fold
- [x] conform based formatexpr
- [ ] Make vim global LSP work in .nvim.lua files
- [ ] Highlight indentation using the wrong whitespace (e.g. tabs when
      `expandtab = true`)
- [ ] Use LSP omnifunc and foldexpr in lua files when lsp is active (all files?
      need to check how default ftplugins interact here)
- [ ] rust-analyzer debuggables

#### Blocked

- [x] Refresh codelens scoped per client (not currently supported in
      `vim.lsp.codelens.refresh`)
- [x] Fix c-n, c-p with 1 (or any?) match when using `fuzzy` completeopt.
      Currently the first is skipped.

#### Upstream types

- [x] `vim.diagnostic.count(bufnr)` to be `table<integer, integer>`
- [x] `LspClient:supports_method` to return `boolean`
- [ ] remove `---@diagnostic disable-next-line: *`. This is caused by lsp method
      type declarations being too strict, not allowing custom methods.

#### Bugs

- [ ] Diagnostics don't seem to update properly. e.g. add/remove unused
      variables in rust file and they become out of date
- [ ] Expand macro doesn't work on stuff like `Debug`
- [ ] OpenCargoToml/ParentModule don't work in 3rd party code
