# __enhancd::core::get_filter_command fuzzys list down to one
__enhancd::core::get_filter_command()
{
    local x candidates

    if [[ -z $1 ]]; then
        return 1
    fi

    # candidates should be list like "a:b:c" concatenated by a colon
    candidates="$1:"

    while [[ -n $candidates ]]; do
        # the first remaining entry
        x=${candidates%%:*}
        # reset candidates
        candidates=${candidates#*:}

        # check if x is __enhancd::core::get_filter_command
        if __enhancd::utils::has "${x%% *}"; then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}
