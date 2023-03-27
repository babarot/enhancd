#!/bin/bash
# vim: ft=zsh

export ENHANCD_ROOT
export ENHANCD_COMMAND
export ENHANCD_FILTER
export ENHANCD_FILTER_ABBREV="${ENHANCD_FILTER_ABBREV:-0}"
export ENHANCD_DIR="${ENHANCD_DIR:-$HOME/.enhancd}"
export ENHANCD_DISABLE_DOT="${ENHANCD_DISABLE_DOT:-0}"
export ENHANCD_DISABLE_HYPHEN="${ENHANCD_DISABLE_HYPHEN:-0}"
export ENHANCD_DISABLE_HOME="${ENHANCD_DISABLE_HOME:-0}"
export ENHANCD_DOT_ARG="${ENHANCD_DOT_ARG:-..}"
export ENHANCD_HYPHEN_ARG="${ENHANCD_HYPHEN_ARG:--}"
export ENHANCD_HYPHEN_NUM="${ENHANCD_HYPHEN_NUM:-10}"
export ENHANCD_HOME_ARG="${ENHANCD_HOME_ARG:-}"
export ENHANCD_COMPLETION_DEFAULT
export ENHANCD_COMPLETION_KEYBIND="${ENHANCD_COMPLETION_KEYBIND:-^I}"
export ENHANCD_COMPLETION_BEHAVIOR="${ENHANCD_COMPLETION_BEHAVIOR:-default}"

export _ENHANCD_VERSION="2.3.1"

if [[ -n ${BASH_VERSION} ]]; then
  # BASH
  ENHANCD_ROOT="$(builtin cd "$(command dirname "${BASH_SOURCE}")" && pwd)"
elif [[ -n ${ZSH_VERSION} ]]; then
  # ZSH
  ENHANCD_ROOT="${${(%):-%x}:A:h}"
  compdef _cd __enhancd::cd
fi

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

if [[ ${SHELL} == *zsh* ]]; then
  for src in ${ENHANCD_ROOT}/src/*.zsh
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
  ENHANCD_FILTER="fzy:fzf:peco:percol:sk:zf:gof:selecta"
fi
