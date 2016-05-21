#!/bin/bash

set -e

export ENHANCD_ROOT
export ENHANCD_COMMAND
export ENHANCD_FILTER
export ENHANCD_DIR="${ENHANCD_DIR:-$HOME/.enhancd}"
export ENHANCD_LOG="${ENHANCD_LOG:-$ENHANCD_DIR/enhancd.log}"
export ENHANCD_DISABLE_DOT="${ENHANCD_DISABLE_DOT:-0}"
export ENHANCD_DISABLE_HYPHEN="${ENHANCD_DISABLE_HYPHEN:-0}"

export _ENHANCD_VERSION="2.2.0"

__enhancd::init()
{
    # bash / zsh
    if [[ -n $BASH_VERSION ]]; then
        ENHANCD_ROOT="$(builtin cd "$(dirname "$BASH_SOURCE")" && pwd)"
    elif [[ -n $ZSH_VERSION ]]; then
        ENHANCD_ROOT="${${(%):-%x}:A:h}"
    else
        return 1
    fi

    if [[ -z $ENHANCD_ROOT ]]; then
        return 1
    fi

    enhancd_dirs=()

    # make a log file and a root directory
    {
        mkdir -p "$ENHANCD_DIR"
        touch "$ENHANCD_LOG"
    } &>/dev/null

    # source the files within src directory
    {
        source "$ENHANCD_ROOT/src/utils.sh"   || return 1
        source "$ENHANCD_ROOT/src/enhancd.sh" || return 1
    } &>/dev/null

    # alias to cd
    eval "alias ${ENHANCD_COMMAND:=cd}=__enhancd::cd"
    if [[ $ENHANCD_COMMAND != "cd" ]]; then
        unalias cd &>/dev/null
    fi

    # Set the filter if empty
    if [[ -z $ENHANCD_FILTER ]]; then
        ENHANCD_FILTER="fzf-tmux:fzf:peco:fzy:percol:gof:pick:icepick:sentaku:selecta"
    fi

    return 0
}

__enhancd::init && __enhancd::load
