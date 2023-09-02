function _enhancd_filter_interactive
    read --local --list stdin

    # If input separated by the null character
    # only the first line has been read in stdin
    if test (count $stdin) -eq 1
        set -l tmp $stdin
        read -z --list stdin
        set --prepend stdin $tmp
    end

    if test -z "$stdin"; or test -p /dev/stdin;
        read -z stdin
    end

    if test -z "$stdin"
        echo "no entry" >&2
        return 1
    end

    set -l count (count $stdin)

    if test "$ENHANCD_USE_ABBREV" = true
        function _enhancd_filter_interactive_abbrev
            while read -l line
                string replace --regex "^$HOME" "~" "$line"
            end
        end

        function _enhancd_filter_interactive_expand
            while read -l line
                string replace --regex "^~" "$HOME" "$line"
            end
        end

        set filter "_enhancd_filter_interactive_abbrev | $ENHANCD_CURRENT_FILTER | _enhancd_filter_interactive_expand"
    end

    switch "$count"
        case '1'
            if test -n "$stdin"
                echo "$stdin"
            else
                return 1
            end

        case '*'
            set -l selected (string join \n -- $stdin | eval "$ENHANCD_CURRENT_FILTER")
            if test -z "$selected"
                return 1
            end
            echo "$selected"
    end
end
