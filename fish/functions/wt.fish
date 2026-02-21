function __wt_list
    set -l highlight (set_color yellow)
    set -l reset (set_color normal)

    git worktree list --porcelain | while read line
        switch $line
            case "worktree *"
                set -f dir (string replace "worktree " "" -- $line)
            case "branch *"
                set -l branch (string replace "branch refs/heads/" "" -- $line)
                echo "$highlight$branch$reset $dir"
            case detached
                echo "$highlight(detached)$reset $dir"
            case bare
                echo "$highlight(bare)$reset $dir"
        end
    end
end

function wt --description "cd to a git worktree"
    for dep in git fzf
        if not command -q $dep
            echo "wt: $dep not found" >&2
            return 1
        end
    end

    if not git rev-parse &>/dev/null
        echo "wt: not a git repository" >&2
        return 1
    end

    set -l fzf_args \
        --height=10 \
        --reverse \
        --ansi
    set -l selection (__wt_list | fzf $fzf_args); or return $status

    cd (string replace -r "^\S+ " "" -- $selection)
end
