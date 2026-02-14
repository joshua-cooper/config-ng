## TODO

### ghostty

- [ ] Custom Light + dark theme

### fish

- [x] custom prompt
- [ ] theme using terminal colors
- [ ] Decide on fish formatting (use spaces for indent?)

### tmux

- [x] custom theme
- [x] bind y to copy without exiting copy mode
- [x] bind v to start selection
- [x] main-pane-{height,width}
- [x] window-status-*
- [x] update-environment

#### Later

- [x] set `cursor-colour` (doesn't support variables atm)
- [x] fix theme reloading bug for window{-active}-style and copy mode
      selection/popup and popup-style and menu style
- [x] add a `prompt-command-cursor-style` option
- [ ] fix bug when status is disabled and tab completing with the menu popup
      (the status pushes down the window content as if the status were enabled)

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
- [ ] rust-analyzer debuggables
- [ ] rust-analyzer user commands
- [ ] Highlight indentation using the wrong whitespace (e.g. tabs when
      `expandtab = true`)
- [ ] Variable to prevent lsp auto start
- [ ] Variable to prevent lsp auto format
- [ ] Make vim global LSP work in .nvim.lua files
- [ ] `set formatoptions` (add `n` and `/`)
- [ ] Use LSP omnifunc and foldexpr in lua files when lsp is active (all files?
      need to check how default ftplugins interact here)
- [ ] Termux path display (this might apply to non nixos distros too, like
      arch/debian)

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
