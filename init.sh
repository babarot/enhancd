#!/bin/bash
# vim: ft=zsh

export ENHANCD_ROOT
export ENHANCD_COMMAND
export ENHANCD_FILTER
export ENHANCD_DIR="${ENHANCD_DIR:-$HOME/.enhancd}"
export ENHANCD_ENABLE_DOUBLE_DOT="${ENHANCD_ENABLE_DOUBLE_DOT:-true}"
export ENHANCD_ENABLE_SINGLE_DOT=${ENHANCD_ENABLE_SINGLE_DOT:-true}
export ENHANCD_ENABLE_HYPHEN="${ENHANCD_ENABLE_HYPHEN:-true}"
export ENHANCD_ENABLE_HOME="${ENHANCD_ENABLE_HOME:-true}"
export ENHANCD_ARG_DOUBLE_DOT="${ENHANCD_ARG_DOUBLE_DOT:-..}"
export ENHANCD_ARG_SINGLE_DOT="${ENHANCD_ARG_SINGLE_DOT:-.}"
export ENHANCD_ARG_HYPHEN="${ENHANCD_ARG_HYPHEN:--}"
export ENHANCD_ARG_HOME="${ENHANCD_ARG_HOME:-}"
export ENHANCD_HYPHEN_NUM="${ENHANCD_HYPHEN_NUM:-10}"
export ENHANCD_COMPLETION_DEFAULT
export ENHANCD_COMPLETION_KEYBIND="${ENHANCD_COMPLETION_KEYBIND:-^I}"
export ENHANCD_COMPLETION_BEHAVIOR="${ENHANCD_COMPLETION_BEHAVIOR:-default}"
export ENHANCD_USE_ABBREV="${ENHANCD_USE_ABBREV:-false}"

if [[ -n ${BASH_VERSION} ]]; then
  # BASH
  ENHANCD_ROOT="$(builtin cd "$(command dirname "${BASH_SOURCE}")" && pwd)"
elif [[ -n ${ZSH_VERSION} ]]; then
  # ZSH
  ENHANCD_ROOT="${${(%):-%x}:A:h}"
  compdef _cd __enhancd::cd
fi

export _ENHANCD_VERSION="$(command cat "${ENHANCD_ROOT}/VERSION" 2>/dev/null)"

# core files
for src in ${ENHANCD_ROOT}/src/*.sh
do
  source "${src}"
done

# custom sources
if [[ -d ${ENHANCD_DIR}/sources ]]; then
  for src in $(command find "${ENHANCD_DIR}/sources" -name "*\.sh")
  do
    source "${src}"
  done
fi

# make a log file and a root directory
if [[ ! -d ${ENHANCD_DIR} ]]; then
  mkdir -p "${ENHANCD_DIR}"
fi
if [[ ! -f ${ENHANCD_DIR}/enhancd.log ]]; then
  touch "${ENHANCD_DIR}/enhancd.log"
fi

# alias to cd
eval "alias ${ENHANCD_COMMAND:=cd}=__enhancd::cd"

# Set the filter if empty
if [[ -z ${ENHANCD_FILTER} ]]; then
  ENHANCD_FILTER="fzy:fzf:peco:sk:zf"
fi
