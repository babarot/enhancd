__enhancd::history::list()
{
    local is_home=false

    # Return false if the logfile dosen't exist
    if [[ ! -f $ENHANCD_DIR/enhancd.log ]]; then
        return 1
    fi

    # Shift arguments in advance if given
    # because it's on subshell beyond a pipe
    if [[ $1 == '--home' ]]; then
        is_home=true
        shift
    fi

    {
        cat "$ENHANCD_DIR/enhancd.log"
        $is_home && echo "$HOME"
    } \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::exists \
        | __enhancd::history::fuzzy "$@" \
        | __enhancd::utils::grep -vx "$PWD"
}

__enhancd::history::fuzzy()
{
    if [[ -z $1 ]]; then
        cat <&0
    else
        if [[ $ENHANCD_USE_FUZZY_MATCH == 1 ]]; then
            awk \
                -f "$ENHANCD_ROOT/src/share/fuzzy.awk" \
                -v search_string="$1"
        else
            # Case-insensitive (don't use fuzzy searhing)
            awk '$0 ~ /\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null
        fi
    fi
}

__enhancd::history::interactive()
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
            t="$(echo "$list" | $filter)"
            if [[ -z $t ]]; then
                # No selection
                return 0
            fi
            echo "$t"
            ;;
    esac
}

__enhancd::history::update()
{
    {
        # Returns a list that was decomposed with a slash
        # to the directory path that visited just before
        # e.g., /home/lisa/src/github.com
        # -> /home
        # -> /home/lisa
        # -> /home/lisa/src
        # -> /home/lisa/src/github.com
        __enhancd::path::step_by_step "$PWD" \
            | __enhancd::filter::reverse
        find "$PWD" -maxdepth 1 -type d | __enhancd::utils::grep -v "\/\."
        if [[ -f $ENHANCD_DIR/enhancd.log ]]; then
            cat "$ENHANCD_DIR/enhancd.log"
        fi
        echo "$PWD"
    } \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::reverse
    echo "$PWD"
}
