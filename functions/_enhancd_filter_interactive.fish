function _enhancd_filter_interactive
    set -l stdin "$argv[1]"

    if test -z "$stdin"; or test -p /dev/stdin
        read -z stdin
    end

    if test -z "$stdin"
        echo "no entry" >&2
        return $_ENHANCD_FAILURE
    end

    set -l filter (_enhancd_filepath_split_list "$ENHANCD_FILTER")
    set -l count (echo "$stdin" | _enhancd_command_grep -c "")

    switch "$count"
        case '1'
            if test -n "$stdin"
                echo "$stdin"
            else
                return 1
            end

        case '*'
            set -l selected (echo "$stdin" | eval "$filter")
            if test -z "$selected"
                return 1
            end
            echo "$selected"
    end
end
