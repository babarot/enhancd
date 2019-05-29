#!/bin/bash

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
            __enhancd::history::show
        } \
            | __enhancd::filter::join
    } \
        | __enhancd::filter::exclude_by "$PWD" \
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

    echo "$dir"
}
