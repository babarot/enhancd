#!/bin/bash

__enhancd::utils::available()
{
    __enhancd::core::get_filter_command "$ENHANCD_FILTER" &>/dev/null &&
        [[ -s $ENHANCD_DIR/enhancd.log ]]
}

# __enhancd::utils::nl reads lines from the named file or the standard input
# if the file argument is ommitted, applies a configurable line numbering filter operation
# and writes the result to the standard output
__enhancd::utils::nl()
{
    # d in awk's argument is a delimiter
    __enhancd::command::awk -v d="${1:-": "}" '
    BEGIN {
        i = 1
    }
    {
        print i d $0
        i++
    }' 2>/dev/null
}
