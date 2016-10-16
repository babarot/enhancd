#!/bin/bash

# __enhancd::utils::die puts a string to stderr
__enhancd::utils::die() {
    printf -- "$@" >&2
}

# __enhancd::utils::unique uniques a stdin contents
__enhancd::utils::unique() {
    if [[ -z $1 ]]; then
        cat <&0
    else
        cat "$1"
    fi | awk '!a[$0]++' 2>/dev/null
}

# __enhancd::utils::reverse reverses a stdin contents
__enhancd::utils::reverse() {
    if [[ -z $1 ]]; then
        cat <&0
    else
        cat "$1"
    fi \
        | awk -f "$ENHANCD_ROOT/src/share/reverse.awk" \
        2>/dev/null
}

# __enhancd::utils::available fuzzys list down to one
__enhancd::utils::available() {
    local x candidates

    if [[ -z $1 ]]; then
        return 1
    fi

    # candidates should be list like "a:b:c" concatenated by a colon
    candidates="$1:"

    while [ -n "$candidates" ]; do
        # the first remaining entry
        x=${candidates%%:*}
        # reset candidates
        candidates=${candidates#*:}

        # check if x is __enhancd::utils::available
        if __enhancd::utils::has "${x%% *}"; then
            echo "$x"
            return 0
        else
            continue
        fi
    done

    return 1
}

# __enhancd::utils::has returns true if $1 exists in the PATH environment variable
__enhancd::utils::has() {
    if [[ -z $1 ]]; then
        return 1
    fi

    type "$1" >/dev/null 2>&1
    return $?
}

# __enhancd::utils::nl reads lines from the named file or the standard input if the file argument is ommitted,
# applies a configurable line numbering filter operation and writes the result to the standard output
__enhancd::utils::nl() {
    # d in awk's argument is a delimiter
    awk -v d="${1:-": "}" '
    BEGIN {
        i = 1
    }
    {
        print i d $0
        i++
    }' 2>/dev/null
}
