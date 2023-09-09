function _enhancd_filter_interactive
    set -l filter "$ENHANCD_CURRENT_FILTER"
    set -l before_cmd
    set -l after_cmd

    if test "$ENHANCD_USE_ABBREV" = true
        # Escape '/' for sed processing
        set -l home_escaped (string replace -a '/' '\/' "$HOME")
        set before_cmd sed 's/^'$home_escaped'/~/g'
        set after_cmd sed 's/^~/'$home_escaped'/g'
    else
        set before_cmd cat
        set after_cmd cat
    end

    read --line line_1 line_2
    if test -z "$line_1" -a -z "$line_2"
        echo "no entry" >&2
        return 1
    else if test -n "$line_1" -a -z "$line_2"
        echo "$line_1"
    else
        # Prepend the first two lines we read to stdin
        begin
            printf "$line_1\n$line_2\n"
            cat
        end | $before_cmd | $filter | $after_cmd
        or return 1
    end
end
