__enhancd::list()
{
    local dir

    # Return false if the logfile dosen't exist
    if [[ ! -f $ENHANCD_DIR/enhancd.log ]]; then
        return 1
    fi

    {
        while read dir
        do
            echo "$dir"
        done <"$ENHANCD_DIR/enhancd.log"
        if [[ $1 == '--home' ]]; then
            echo "$HOME"
            shift
        fi
    } \
        | __enhancd::utils::reverse \
        | __enhancd::utils::unique \
        | __enhancd::fuzzy "$@" \
        | grep -vx "$PWD"
}

__enhancd::fuzzy()
{
    if [[ -z $1 ]]; then
        cat <&0
    else
        cat <&0 \
            | awk \
            -f "$ENHANCD_ROOT/src/share/fuzzy.awk" \
            -v search_string="$1"
    fi
}

__enhancd::filter()
{
    # Narrows the ENHANCD_FILTER environment variables down to one
    # and sets it to the variables filter
    local list="$1" filter

    # If no argument is given to __enhancd::interface
    if [[ -z $list ]] || [[ -p /dev/stdin ]]; then
        #__enhancd::utils::die "__enhancd::interface requires an argument at least\n"
        list="$(cat <&0)"
    fi

    filter="$(__enhancd::utils::available "$ENHANCD_FILTER")"

    # Count lines in the list
    local wc
    wc="$(echo "$list" | command grep -c "")"

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
            t="$(echo "$list" | $filter)"
            if [[ -z $t ]]; then
                # No selection
                return 0
            fi
            echo "$t"
            ;;
    esac
}
