#!/bin/bash

__enhancd::custom::current()
{
    __enhancd::log::list --narrow ${1:+"$@"} \
        | grep "$PWD/" \
        | sed 's#'"$PWD"'#.#' \
        | __enhancd::log::filter \
        | read dir

    if [[ -d $dir ]]; then
        __enhancd::cd "$PWD/$dir"
        return $?
    fi
}
