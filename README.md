## TODO

### nvim

- [x] Theme
- [ ] Set up tree-sitter parsers
- [ ] Keymaps
- [ ] LSP busy integration
- [ ] Directory browser setup (netrw/oil?)
- [ ] Audit missing options
- [ ] Remove the lazy lua magic

#### Later

- [ ] `statuscolumn`
- [ ] Directory based git difftool (new in 0.12)
- [ ] Surround plugin
- [ ] Custom codelens virtual text
- [ ] Use LSP omnifunc in lua files when lsp is active (all files? need to check
      how default ftplugins interact here)
- [ ] Recalculate folds on LSP attach (`:help zx`)
- [ ] Termux handling
  - [ ] Path display (this might apply to non nixos distros too, like
        arch/debian)
  - [ ] Jumping to rust std item complains about std being nightly
- [ ] rust-analyzer debuggables
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
