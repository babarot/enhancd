#!/bin/bash

__enhancd::custom::ghq()
{
    local root dir

    if ! __enhancd::utils::has "ghq"; then
        __enhancd::utils::die \
            "ghq: not found\n"
        return 1
    fi

    ghq root \
        | read root
    ghq list \
        | __enhancd::narrow "$@" \
        | __enhancd::filter \
        | read dir

    if [[ -n $dir ]]; then
        __enhancd::cd "$root/$dir"
        return $?
    fi
}
