#!/bin/bash

__enhancd::custom::current()
{
    __enhancd::list --narrow ${1:+"$@"} \
        | grep "$PWD/" \
        | sed 's#'"$PWD"'#.#' \
        | __enhancd::filter \
        | read dir

    if [[ -d $dir ]]; then
        __enhancd::cd "$PWD/$dir"
        return $?
    fi
}
