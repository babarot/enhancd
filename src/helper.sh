__enhancd::helper::parse_filter_string()
{
  local item str

  if [[ -z ${1} ]]; then
    return 1
  fi

  # str should be list like "a:b:c" concatenated by a colon
  str="${1}:"

  while [[ -n ${str} ]]
  do
    # the first remaining entry
    item=${str%%:*}
    # reset str
    str=${str#*:}

    if __enhancd::command::which "${item%% *}"; then
      echo "${item}"
      return 0
    else
      continue
    fi
  done

  return 1
}
