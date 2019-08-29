function filter_exclude_gitignore
    set -la ignores
    if [ -f $PWD/.gitignore ]
        set -a ignores ".git"
    else
        # just do read the input and do output
        # if no gitignore file
        cat <&0
        return 0
    end

    set -l ignore

    while read ignore
        if [ -d $ignore ]
            set -a ignores (basename "$ignore")
        end
    end <"$PWD"/.gitignore

    function contains
        if ! set argv[1]
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