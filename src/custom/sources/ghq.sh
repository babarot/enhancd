#!/bin/bash

__enhancd::custom::sources::ghq()
{
    # Shift first arguments (-g/--ghq)
    shift

    if ! __enhancd::command::which "ghq"; then
        echo "ghq: not found" >&2
        return 1
    fi

    local dir ghq_root
    ghq_root="$(ghq root 2>/dev/null)"

    {
        cat "$ENHANCD_DIR/enhancd.log" \
            | __enhancd::command::grep "^$ghq_root" \
            | __enhancd::filter::reverse
        ghq list
    } 2>/dev/null \
        | __enhancd::command::grep -vx "$ghq_root" \
        | __enhancd::command::grep -vx "$PWD" \
        | __enhancd::utils::sed "$ghq_root/" \
        | __enhancd::filter::unique \
        | __enhancd::filter::fuzzy "$@" \
        | __enhancd::filter::interactive \
        | read dir

    if [[ -z $dir ]]; then
        # Press Ctrl-C
        return 0
    fi

    if [[ ! -d $ghq_root/$dir ]]; then
        echo "$dir: no such directory" >&2
        return 1
    fi

    __enhancd::cd "$ghq_root/$dir"
}

__enhancd::custom::sources::ghq_smart()
{
    shift
    local dir ret

    if ! __enhancd::command::which "ghq"; then
        echo "ghq: not found" >&2
        return 1
    fi

    dir="$(
    {
        ghq list --full-path
        {
            ghq list --full-path
            __enhancd::history::origin
        } \
            | __enhancd::filter::join
    } \
        | __enhancd::command::grep -vx "$PWD" \
        | __enhancd::filter::reverse \
        | __enhancd::filter::unique \
        | __enhancd::filter::fuzzy "$@" \
        | __enhancd::filter::interactive
    )"

    ret=$?
    if [[ -z $dir ]]; then
        if [[ $ret == $_ENHANCD_FAILURE ]]; then
            echo "$@: no such file or directory" >&2
            return 1
        else
            # Press Ctrl-C
            return 0
        fi
    fi

    __enhancd::cd "$dir"
}
