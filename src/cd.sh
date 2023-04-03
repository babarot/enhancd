__enhancd::cd()
{
  local -i code=0
  local -a args opts

  if ! __enhancd::cd::ready; then
    __enhancd::cd::builtin "${@:-$HOME}"
    return ${?}
  fi

  # Read from standard input
  if [[ -p /dev/stdin ]]; then
    # only zsh
    args+=( "$(command cat <&0 | __enhancd::filter::interactive)" )
  fi

  while (( ${#} > 0 ))
  do
    case "${1}" in
      -h | --help)
        __enhancd::ltsv::open | __enhancd::command::awk -f "${ENHANCD_ROOT}/functions/enhancd/lib/help.awk"
        return ${?}
        ;;
      "${ENHANCD_ARG_HYPHEN}")
        # If a hyphen is passed as the argument,
        # searchs from the last 10 directory items in the log
        args+=( "$(__enhancd::sources::mru | __enhancd::filter::interactive)" )
        code=${?}
        break
        ;;
      "-")
        # When $ENHANCD_ARG_HYPHEN is configured,
        # this behaves like `cd -`
        args+=( "${OLDPWD}" )
        break
        ;;
      "${ENHANCD_ARG_DOUBLE_DOT}")
        # If a double-dot is passed as the argument,
        # it behaves like a zsh-bd plugin
        # In short, you can jump back to a specific directory,
        # without doing `cd ../../..`
        args+=( "$(__enhancd::sources::parent_dirs | __enhancd::filter::interactive)" )
        code=${?}
        break
        ;;
      "..")
        # When $ENHANCD_ARG_DOUBLE_DOT is configured,
        # ".." is passed to builtin cd
        args+=( ".." )
        break
        ;;
      "${ENHANCD_ARG_SINGLE_DOT}")
        args+=( "$(__enhancd::sources::current_dirs | __enhancd::filter::interactive)" )
        code=${?}
        break
        ;;
      ".")
        # When $ENHANCD_ARG_DOUBLE_DOT is configured,
        # ".." is passed to builtin cd
        args+=( "." )
        break
        ;;
      "${ENHANCD_ARG_HOME}")
        args+=( "$(__enhancd::sources::home | __enhancd::filter::interactive)" )
        code=${?}
        break
        ;;
      --)
        opts+=( "${1}" )
        shift
        args+=( "$(__enhancd::sources::history "${1}" | __enhancd::filter::interactive)" )
        code=${?}
        break
        ;;
      -* | --*)
        if __enhancd::helper::is_default_flag "${1}"; then
          opts+=( "${1}" )
        else
          local opt="${1}"
          local func cond format
          cond="$(__enhancd::ltsv::get "${opt}" "condition")"
          func="$(__enhancd::ltsv::get "${opt}" "func")"
          format="$(__enhancd::ltsv::get "${opt}" "format")"
          if ! __enhancd::command::run "${cond}" &>/dev/null; then
            echo "${opt}: does not meet '${cond}'" >&2
            return 1
          fi
          if [[ -z ${func} ]]; then
            echo "${opt}: 'func' label is required" >&2
            return 1
          fi
          if [[ -n ${format} ]] && [[ ${format//\%/} == "${format}" ]]; then
            echo "${opt}: 'format' label needs to include '%' (selected line)" >&2
            return 1
          fi
          local selected
          if [[ -z ${format} ]]; then
            selected="$(__enhancd::command::run "${func}" | __enhancd::filter::interactive)"
            code=${?}
          else
            # format is maybe including $HOME etc. need magic line of 'eval printf' to expand that.
            selected="$(__enhancd::command::run "${func}" | __enhancd::filter::interactive | xargs -I% echo $(eval printf "%s" "${format}"))"
            code=${?}
          fi
          args+=( "${selected}" )
          break
        fi
        ;;
      *)
        args+=( "$(__enhancd::sources::history "${1}" | __enhancd::filter::interactive)" )
        code=${?}
        ;;
    esac
    shift
  done

  case ${#args[@]} in
    0)
      args+=( "$(__enhancd::sources::home | __enhancd::filter::interactive)" )
      code=${?}
      ;;
  esac

  case "${code}" in
    0)
      __enhancd::cd::builtin "${opts[@]}" "${args[@]}"
      return ${?}
      ;;
    *)
      return 1
      ;;
  esac
}

__enhancd::cd::builtin()
{
  local -i code=0

  __enhancd::cd::before
  builtin cd "${@}"
  code=${?}
  __enhancd::cd::after

  return ${code}
}

__enhancd::cd::before()
{
  :
}

__enhancd::cd::after()
{
  local list
  list="$(__enhancd::history::update)"

  if [[ -n ${list} ]]; then
    echo "${list}" >| "${ENHANCD_DIR}/enhancd.log"
  fi

  if [[ -n ${ENHANCD_HOOK_AFTER_CD} ]]; then
    eval "${ENHANCD_HOOK_AFTER_CD}"
  fi
}

__enhancd::cd::ready()
{
  __enhancd::helper::parse_filter_string "${ENHANCD_FILTER}" \
  &>/dev/null && [[ -s ${ENHANCD_DIR}/enhancd.log ]]
  return ${?}
}
