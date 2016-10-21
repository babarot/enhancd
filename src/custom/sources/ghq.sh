#!/bin/bash

__enhancd::custom::sources::ghq()
{
    # Shift first arguments (-g/--ghq)
    shift

    if ! __enhancd::utils::has "ghq"; then
        __enhancd::utils::die "ghq: not found\n"
        return 1
    fi

    local dir ghq_root
    ghq_root="$(ghq root 2>/dev/null)"

    {
        cat "$ENHANCD_DIR/enhancd.log" \
            | __enhancd::utils::grep "^$ghq_root" \
            | __enhancd::filter::reverse
        ghq list
    } 2>/dev/null \
        | __enhancd::utils::grep -vx "$ghq_root" \
        | __enhancd::utils::grep -vx "$PWD" \
        | __enhancd::utils::sed "$ghq_root/" \
        | __enhancd::filter::unique \
        | __enhancd::history::fuzzy "$@" \
        | __enhancd::history::interactive \
        | read dir

    if [[ -z $dir ]]; then
        # Press Ctrl-C
        return 0
    fi

    if [[ ! -d $ghq_root/$dir ]]; then
        __enhancd::utils::die "$dir: no such directory\n"
        return 1
    fi

    __enhancd::cd "$ghq_root/$dir"
}
