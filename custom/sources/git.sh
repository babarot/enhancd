#!/bin/bash

__enhancd::custom::git()
{
    local root dir

    root="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -z $root ]]; then
        __enhancd::utils::die \
            "$PWD: Is not a git repo\n"
        return 1
    fi

    {
        cat "$ENHANCD_DIR/enhancd.log" \
            | __enhancd::utils::reverse \
            | __enhancd::utils::unique \
            | grep "$root"
        find "$root" -type d \
            | grep -v "/.git"
    } \
        | grep -v "^$PWD$" \
        | sed 's#'"$root"'##' \
        | sed 's#^$#/#' \
        | sed 's#^#[git] #' \
        | __enhancd::utils::unique \
        | __enhancd::narrow "$@" \
        | __enhancd::filter \
        | sed 's#^\[git\] ##' \
        | read dir

    if [[ -n $dir ]]; then
        __enhancd::cd "$root/$dir"
        return $?
    fi
}
