## TODO

### nvim

- [x] Theme
- [x] Remove the lazy lua magic
- [x] Audit missing options
- [x] Keymaps
- [x] LSP busy integration
- [x] Directory browser setup (netrw/oil?)
- [ ] Remove code TODOs

#### Later

- [x] Surround plugin
- [x] Directory based git difftool (new in 0.12)
- [ ] Set up tree-sitter parsers
- [ ] `statuscolumn` (default is good if number + foldcolumn is enabled, but if
       only foldcolumn, it's too cramped. We want the same as default, but with
       a space between the buffer content and foldcolumn if only it is enabled)
- [ ] LSP codelens
- [ ] Custom codelens virtual text
- [ ] Use LSP omnifunc and foldexpr in lua files when lsp is active (all files?
      need to check how default ftplugins interact here)
- [ ] Recalculate folds on LSP attach (`:help zx`)
- [ ] Termux handling
  - [ ] Path display (this might apply to non nixos distros too, like
        arch/debian)
  - [ ] Jumping to rust std item complains about std being nightly
- [ ] rust-analyzer debuggables
- [ ] rust-analyzer user commands
- [ ] Manual truncation of statusline when too long (avoids default `>`)
- [ ] Fix c-n, c-p with 1 (or any?) match when using `fuzzy` completeopt.
      Currently the first is skipped.
- [ ] `set formatoptions` (add `n` and `/`)
- [ ] Highlight indentation using the wrong whitespace (e.g. tabs when
      `expandtab = true`)
- [ ] Variable to prevent lsp auto start
- [ ] Variable to prevent lsp auto format
- [ ] Make vim global LSP work in .nvim.lua files

#### Blocked

- [ ] emmylua-ls doesn't pick up some stuff (e.g. `vim.lsp.buf.format`) until
      you go to definition on part of it. (should be fixed in next release)
- [ ] Refresh codelens scoped per client (not currently supported in
      `vim.lsp.codelens.refresh`)
- [ ] BiDi support <https://github.com/neovim/neovim/issues/553>
  - [ ] Isolate statusline components (filename, each flag, etc.)
  - [ ] Independent statusline alignment for vertical splits

#### Upstream types

- [ ] `vim.diagnostic.count(bufnr)` to be `table<integer, integer>`
- [ ] `LspClient:supports_method` to return `boolean`
- [ ] `vim.api.nvim_win_call` to return generic return type of callback
- [ ] remove `---@diagnostic disable-next-line: assign-type-mismatch` (emmylua
      bug)
