#!/bin/bash

__enhancd::custom::options::help()
{
    local config="$ENHANCD_ROOT/src/custom/config.ltsv"

cat <<HELP
usage: cd [OPTIONS] [dir]

OPTIONS:
HELP

if [[ -f $config ]]; then
    cat "$config" \
        | __enhancd::utils::grep -v '^(//|#)' \
        |
    while IFS=$'\t' read short long desc action
    do
        if [[ -z ${short#*:} ]]; then
            command printf "  %s  %-15s %s\n" "  "          "${long#*:}" "${desc#*:}"
        elif [[ -z ${long#*:} ]]; then
            command printf "  %s  %-15s %s\n" "${short#*:}" ""           "${desc#*:}"
        else
            command printf "  %s, %-15s %s\n" "${short#*:}" "${long#*:}" "${desc#*:}"
        fi
    done
else
    printf "  nothing yet"
fi

cat <<HELP

Author:  b4b4r07
Version: $_ENHANCD_VERSION
LICENSE: MIT
HELP
}
