#!/bin/bash
# Version:    v3.0.0a
# Repository: https://github.com/b4b4r07/enhancd
# Author:     b4b4r07 (BABAROT)
# License:    MIT
# Note:
#   this enhancd.sh supports bash and zsh only
#

if [[ -n $BASH_VERSION ]]; then
    ENHANCD_ROOT="$(builtin cd "$(dirname "$BASH_SOURCE")" && pwd)"
elif [[ -n $ZSH_VERSION ]]; then
    ENHANCD_ROOT="${${(%):-%x}:A:h}"
else
    return 1
fi

export ENHANCD_ROOT
export ENHANCD_DIR=${ENHANCD_DIR:-~/.enhancd}
export ENHANCD_LOG=${ENHANCD_LOG:-"$ENHANCD_DIR"/enhancd.log}
export ENHANCD_DISABLE_DOT=${ENHANCD_DISABLE_DOT:-0}
export ENHANCD_DISABLE_HYPHEN=${ENHANCD_DISABLE_HYPHEN:-0}
enhancd_dirs=()

source "$ENHANCD_ROOT/src/utils.sh"
source "$ENHANCD_ROOT/src/enhancd.sh"

eval "alias ${ENHANCD_COMMAND:="cd"}=__enhancd::cd"
export ENHANCD_COMMAND
if [ "$ENHANCD_COMMAND" != "cd" ]; then
    unalias cd 2>/dev/null
fi

# Sets default values to ENHANCD_FILTER if it is empty
if [[ -z $ENHANCD_FILTER ]]; then
    ENHANCD_FILTER="fzy:fzf:peco:percol:gof:pick:icepick:sentaku:selecta"
    export ENHANCD_FILTER
fi

__enhancd::load
