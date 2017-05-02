#!/bin/bash

__enhancd::utils::available()
{
    __enhancd::utils::filter "$ENHANCD_FILTER" &>/dev/null &&
        [[ -s $ENHANCD_DIR/enhancd.log ]]
}

# __enhancd::utils::die puts a string to stderr
__enhancd::utils::die()
{
    printf -- "$@" >&2
}

# __enhancd::utils::grep prints in regular expression
__enhancd::utils::grep()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        cat "$1"
        shift
    else
        cat <&0
    fi \
        | command grep -E "$@" 2>/dev/null
}

# __enhancd::utils::sed replaces 1st arg with 2nd arg
# Use blank char instead if no argument is given
__enhancd::utils::sed()
{
    local g='' sep='!'

    while (( $# > 0 ))
    do
        case "$1" in
            -g)
                g='g'
                shift
                ;;
            -d)
                sep="${2:?}"
                shift
                shift
                ;;
            -* | --*)
                shift
                ;;
            *)
                break
                ;;
        esac
    done

    cat <&0 \
        | command sed -E "s$sep$1$sep$2$sep$g" 2>/dev/null
}

# __enhancd::utils::filter fuzzys list down to one
__enhancd::utils::filter()
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

        # check if x is __enhancd::utils::filter
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
__enhancd::utils::has()
{
    if [[ -z $1 ]]; then
        return 1
    fi

    type "$1" >/dev/null 2>&1
    return $?
}

# __enhancd::utils::nl reads lines from the named file or the standard input
# if the file argument is ommitted, applies a configurable line numbering filter operation
# and writes the result to the standard output
__enhancd::utils::nl()
{
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
