function _enhancd_filter_exclude_gitignore
    set -la ignores
    if test -f $PWD/.gitignore
        set -a ignores ".git"
    else
        # just do read the input and do output
        # if no gitignore file
        command cat <&0
        return 0
    end

    set -l ignore

    while read ignore
        if test -d $ignore
            set -a ignores (command basename "$ignore")
        end
    end <"$PWD"/.gitignore

    function contains
        if not set argv[1]
            return 1
        else
            set -l input $argv[1]
        end

        set -l ignore
        for ignore in "$ignores[@]"
            if string match --regex (string replace --all '.' '\\.' $ignore) $input
                return 0
            end
        end
        return 1
    end

    set -l line
    while read line
        if contains $line
            continue
        end
        echo "$line"
    end
end
