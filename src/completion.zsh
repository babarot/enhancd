#!/bin/zsh

__enhancd::completion::list() {
  # This code are copied from https://github.com/changyuheng/zsh-interactive-cd
  # https://github.com/changyuheng/zsh-interactive-cd/blob/master/LICENSE
  local dir length seg starts_with_dir
  if [[ "$1" == */ ]]; then
    dir="$1"
    if [[ "$dir" != / ]]; then
      dir="${dir: : -1}"
    fi
    length=$(echo -n "$dir" | wc -c)
    if [ "$dir" = "/" ]; then
      length=0
    fi
    command find -L "$dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
        | cut -b $(( ${length} + 2 ))- | \sed '/^$/d' | while read -r line; do
      if [[ "${line[1]}" == "." ]]; then
        continue
      fi
      echo "$line"
    done
  else
    dir=$(command dirname -- "$1")
    length=$(echo -n "$dir" | wc -c)
    if [ "$dir" = "/" ]; then
      length=0
    fi
    seg=$(command basename -- "$1")
    starts_with_dir=$( \
      command find -L "$dir" -mindepth 1 -maxdepth 1 -type d \
          2>/dev/null | cut -b $(( ${length} + 2 ))- | \sed '/^$/d' \
          | while read -r line; do
        if [[ "${seg[1]}" != "." && "${line[1]}" == "." ]]; then
          continue
        fi
        if [[ "$line" == "$seg"* ]]; then
          echo "$line"
        fi
      done
    )
    if [ -n "$starts_with_dir" ]; then
      echo "$starts_with_dir"
    else
      command find -L "$dir" -mindepth 1 -maxdepth 1 -type d \
          2>/dev/null | cut -b $(( ${length} + 2 ))- | \sed '/^$/d' \
          | while read -r line; do
        if [[ "${seg[1]}" != "." && "${line[1]}" == "." ]]; then
          continue
        fi
        if [[ "$line" == *"$seg"* ]]; then
          echo "$line"
        fi
      done
    fi
  fi
}

__enhancd::completion::completer() {
  case $ENHANCD_COMPLETION_BEHAVIOR in
    ("list" | "dir" | "dirlist")
        __enhancd::completion::list "${(Q)@[-1]}" | sort
        ;;
    ("history")
        __enhancd::history::list "${(Q)@[-1]}"
        ;;
    ("default" | "*")
        :
        ;;
  esac
}

__enhancd::completion::complete() {
  setopt localoptions nonomatch
  local l matches filter tokens base

  l=$(__enhancd::completion::completer $@)

  if [ -z "$l" ]; then
    zle ${ENHANCD_COMPLETION_DEFAULT:-expand-or-complete}
    return
  fi

  filter=$(__enhancd::filepath::split_list "$ENHANCD_FILTER")

  if [ $(echo $l | wc -l) -eq 1 ]; then
    matches=${(q)l}
  else
    matches=$(echo $l \
        | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} \
          --reverse $FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS \
          --bind 'shift-tab:up,tab:down'" ${=filter} \
        | while read -r item; do
      echo -n "${(q)item} "
    done)
  fi

  matches=${matches% }
  if [ -n "$matches" ]; then
    tokens=(${(z)LBUFFER})
    base="${(Q)@[-1]}"
    if [[ "$base" != */ ]]; then
      if [[ "$base" == */* ]]; then
        base="$(command dirname -- "$base")"
        if [[ ${base[-1]} != / ]]; then
          base="$base/"
        fi
      else
        base=""
      fi
    fi
    LBUFFER="${tokens[1]} "
    if [ -n "$base" ]; then
      base="${(q)base}"
      if [ "${tokens[2][1]}" = "~" ]; then
        base="${base/#$HOME/~}"
      fi
      LBUFFER="${LBUFFER}${base}"
    fi
    LBUFFER="${LBUFFER}${matches}/"
  fi
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
}

__enhancd::completion::run() {
  setopt localoptions noshwordsplit noksh_arrays noposixbuiltins
  local tokens cmd

  tokens=(${(z)LBUFFER})
  cmd=${tokens[1]}

  if [[ "${LBUFFER}" =~ "^\ *${ENHANCD_COMMAND}$" ]]; then
    zle ${ENHANCD_COMPLETION_DEFAULT:-expand-or-complete}
  elif [[ "${cmd}" = ${ENHANCD_COMMAND} ]]; then
    __enhancd::completion::complete ${tokens[2,${#tokens}]/#\~/$HOME}
  else
    zle ${ENHANCD_COMPLETION_DEFAULT:-expand-or-complete}
  fi
}

if [[ -z "$ENHANCD_COMPLETION_DEFAULT" ]]; then
  binding=$(bindkey '^I')
  # $binding[(s: :w)2]
  # The command substitution and following word splitting to determine the
  # default zle widget for ^I formerly only works if the IFS parameter contains
  # a space via $binding[(w)2]. Now it specifically splits at spaces, regardless
  # of IFS.
  [[ $binding =~ 'undefined-key' ]] || ENHANCD_COMPLETION_DEFAULT=$binding[(s: :w)2]
  unset binding
fi

if [[ -n $ENHANCD_COMPLETION_KEYBIND ]]; then
  zle -N __enhancd::completion::run
  bindkey "${ENHANCD_COMPLETION_KEYBIND}" __enhancd::completion::run
fi
