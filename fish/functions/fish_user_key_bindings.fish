function fish_user_key_bindings
    set modifiers super ctrl alt shift
    set n (count $modifiers)

    for mask in (seq (math "pow(2, $n) - 1"))
        set combo

        for i in (seq $n)
            if test (math "bitand($mask, pow(2, $i - 1))") -ne 0
                set combo $combo $modifiers[$i]
            end
        end

        set combo $combo escape
        set key (string join - $combo)

        bind --mode insert --sets-mode default $key repaint-mode
    end
end
