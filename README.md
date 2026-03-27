## TODO

- [ ] Revisit .editorconfig styles

### ghostty

- [ ] Custom Light + dark theme

### fish

- [ ] Theme using terminal colors

### nvim

- [x] Remove zen prefix from the lsp configs
- [x] Make vim global LSP work in .nvim.lua files
- [ ] Theme from scratch

#### Nice to have

- [ ] rust-analyzer debuggables

#### Bugs

- [ ] Expand macro doesn't work on stuff like `Debug`
- [ ] OpenCargoToml/ParentModule don't work in 3rd party code

## Blocked on upstream

### tmux

- [ ] fix bug when status is disabled and tab completing with the menu popup
      (the status pushes down the window content as if the status were enabled)
- [ ] Fix menu-border none (it currently pads things)
- [ ] Borders around stuff in choose tree needs bg set. (if terminal has its own
      bg, you can see it through borders)
- [ ] Can we customize format of term dimensions indicator on prefix + q (e.g.
      add padding)

### nvim

- [ ] remove `---@diagnostic disable-next-line: *`. This is caused by lsp method
      type declarations being too strict, not allowing custom methods.
- [ ] Use LSP omnifunc and foldexpr in lua files when lsp is active. This
      applies to other filetypes too, but lua is the most used one. Upstream
      should probably conditionally set these options
