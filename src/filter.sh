__enhancd::filter::exists()
{
  local line
  while read line
  do
    if [[ -d ${line} ]]; then
      echo "${line}"
    fi
  done
}

__enhancd::filter::unique()
{
  {
    if [[ -n ${1} ]] && [[ -f ${1} ]]; then
      command cat "${1}"
    else
      command cat <&0
    fi
  } | __enhancd::command::awk '!a[$0]++' 2>/dev/null
}

__enhancd::filter::reverse()
{
  {
    if [[ -n ${1} ]] && [[ -f ${1} ]]; then
      command cat "${1}"
    else
      command cat <&0
    fi
  } | __enhancd::command::awk -f "${ENHANCD_ROOT}/functions/enhancd/lib/reverse.awk" 2>/dev/null
}

__enhancd::filter::fuzzy()
{
  if [[ -z ${1} ]]; then
    cat <&0
  else
    __enhancd::command::awk -f "${ENHANCD_ROOT}/functions/enhancd/lib/fuzzy.awk" -v search_string="${1}"
  fi
}

__enhancd::filter::interactive()
{
  local stdin="${1}"

  if [[ -z ${stdin} ]] || [[ -p /dev/stdin ]]; then
    stdin="$(command cat <&0)"
  fi

  if [[ -z ${stdin} ]]; then
    echo "no entry" >&2
    return 1
  fi

  local filter
  filter="$(__enhancd::helper::parse_filter_string "${ENHANCD_FILTER}")"

  if ${ENHANCD_USE_ABBREV}; then
    filter="__enhancd::filter::replace ${HOME} \~ | ${filter} | __enhancd::filter::replace \~ ${HOME}"
  fi

  local -i count
  count="$(echo "${stdin}" | __enhancd::command::grep -c "")"

  case "${count}" in
    1)
      if [[ -n ${stdin} ]]; then
        echo "${stdin}"
      else
        return 1
      fi
      ;;
    *)
      local selected
      selected="$(echo "${stdin}" | eval "${filter}")"
      if [[ -z ${selected} ]]; then
        return 0
      fi
      echo "${selected}"
      ;;
  esac
}

__enhancd::filter::exclude()
{
  __enhancd::command::grep -v -x -F "${1}" || true
}

__enhancd::filter::replace()
{
  local old new
  old="${1:?too few argument}"
  new="${2:-""}"
  __enhancd::command::awk -v old="${old}" -v new="${new}" 'sub(old, new, $0) {print $0}'
}

__enhancd::filter::limit()
{
  command head -n "${1:-10}"
}
