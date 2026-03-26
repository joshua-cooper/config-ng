set -g fish_greeting
set -g fish_key_bindings fish_vi_key_bindings

if command -q direnv
    direnv hook fish | source
end

alias bell "printf \a"
