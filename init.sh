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
export ENHANCD_USE_FUZZY_MATCH="${ENHANCD_USE_FUZZY_MATCH:-1}"

_ENHANCD_VERSION="2.2.2"
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
    # core files
    for src in "$ENHANCD_ROOT/src"/*.sh
    do
        source "$src"
    done

    # custom files
    for src in "$ENHANCD_ROOT/src/custom/"{sources,options}/*.sh
    do
        source "$src"
    done

    unset src

    # make a log file and a root directory
    mkdir -p "$ENHANCD_DIR"
    touch "$ENHANCD_DIR/enhancd.log"

    # alias to cd
    eval "alias ${ENHANCD_COMMAND:=cd}=__enhancd::cd"
    if [[ $ENHANCD_COMMAND != cd ]]; then
        unalias cd
    fi

    # Set the filter if empty
    if [[ -z $ENHANCD_FILTER ]]; then
        ENHANCD_FILTER="fyz:fzf-tmux:fzf:peco:percol:gof:pick:icepick:sentaku:selecta"
    fi

    # In zsh it will cause field splitting to be performed
    # on unquoted parameter expansions.
    if __enhancd::utils::has "setopt" && [[ -n $ZSH_VERSION ]]; then
        # Note in particular the fact that words of unquoted parameters are not
        # automatically split on whitespace unless the option SH_WORD_SPLIT is set;
        # see references to this option below for more details.
        # This is an important difference from other shells.
        # (Zsh Manual 14.3 Parameter Expansion)
        setopt localoptions SH_WORD_SPLIT
    fi
} &>/dev/null
