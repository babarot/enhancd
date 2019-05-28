__enhancd::filter::exists()
{
    local line

    while read line
    do
        if [[ -d $line ]]; then
            echo "$line"
        fi
    done
}

__enhancd::filter::join()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
    else
        cat <&0
    fi | $ENHANCD_AWK 'a[$0]++' 2>/dev/null
}

# __enhancd::filter::unique uniques a stdin contents
__enhancd::filter::unique()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
    else
        cat <&0
    fi | $ENHANCD_AWK '!a[$0]++' 2>/dev/null
}

# __enhancd::filter::reverse reverses a stdin contents
__enhancd::filter::reverse()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
    else
        cat <&0
    fi \
        | $ENHANCD_AWK -f "$ENHANCD_ROOT/src/share/reverse.awk" \
        2>/dev/null
}

__enhancd::filter::fuzzy()
{
    if [[ -z $1 ]]; then
        cat <&0
    else
        if [[ $ENHANCD_USE_FUZZY_MATCH == 1 ]]; then
            $ENHANCD_AWK \
                -f "$ENHANCD_ROOT/src/share/fuzzy.awk" \
                -v search_string="$1"
        else
            # Case-insensitive (don't use fuzzy searhing)
            $ENHANCD_AWK '$0 ~ /\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null
        fi
    fi
}

__enhancd::filter::interactive()
{
    # Narrows the ENHANCD_FILTER environment variables down to one
    # and sets it to the variables filter
    local list="$1" filter

    # If no argument is given to __enhancd::interface
    if [[ -z $list ]] || [[ -p /dev/stdin ]]; then
        list="$(cat <&0)"
    fi

    filter="$(__enhancd::core::get_filter_command "$ENHANCD_FILTER")"

    # Count lines in the list
    local wc
    wc="$(echo "$list" | __enhancd::utils::grep -c "")"

    case "$wc" in
        1 )
            if [[ -n $list ]]; then
                echo "$list"
            else
                return $_ENHANCD_FAILURE
            fi
            ;;
        * )
            local t
            t="$(echo "$list" | eval $filter)"
            if [[ -z $t ]]; then
                # No selection
                return 0
            fi
            echo "$t"
            ;;
    esac
}
