#!/bin/bash

export ENHANCD_ROOT
export ENHANCD_COMMAND
export ENHANCD_FILTER
export ENHANCD_DIR="${ENHANCD_DIR:-$HOME/.enhancd}"
export ENHANCD_DISABLE_DOT="${ENHANCD_DISABLE_DOT:-0}"
export ENHANCD_DISABLE_HYPHEN="${ENHANCD_DISABLE_HYPHEN:-0}"
export ENHANCD_DISABLE_HOME="${ENHANCD_DISABLE_HOME:-0}"
export ENHANCD_DOT_ARG="${ENHANCD_DOT_ARG:-..}"
export ENHANCD_HYPHEN_ARG="${ENHANCD_HYPHEN_ARG:--}"
export ENHANCD_DOT_SHOW_FULLPATH="${ENHANCD_DOT_SHOW_FULLPATH:-0}"

_ENHANCD_VERSION="2.2.1"
_ENHANCD_SUCCESS=0
_ENHANCD_FAILURE=60

if [[ -n $BASH_VERSION ]]; then
    # BASH
    ENHANCD_ROOT="$(builtin cd "$(dirname "$BASH_SOURCE")" && pwd)"
elif [[ -n $ZSH_VERSION ]]; then
    # ZSH
    ENHANCD_ROOT="${${(%):-%x}:A:h}"
else
    return 1
fi

{
    for src in "$ENHANCD_ROOT/src"/*.sh
    do
        source "$src"
    done
    unset src
} &>/dev/null
