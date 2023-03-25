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

__enhancd::helper::is_default_flag()
{
  local opt="${1}"
  case ${SHELL} in
    *bash)
      case "${opt}" in
        "-P" | "-L" | "-e" | "-@")
          return 0
          ;;
      esac
      ;;
    *zsh)
      case "${opt}" in
        "-q" | "-s" | "-L" | "-P")
          return 0
          ;;
      esac
      ;;
  esac
  return 1
}
