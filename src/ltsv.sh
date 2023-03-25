__enhancd::ltsv::open()
{
  command cat "${ENHANCD_ROOT}/config.ltsv" 2>/dev/null
  command cat "${ENHANCD_DIR}/config.ltsv" 2>/dev/null
  command cat "${HOME}/.config/enhancd/config.ltsv" 2>/dev/null
}

__enhancd::ltsv::parse()
{
  local -a args
  local query
  while (( ${#} > 0 ))
  do
    case "${1}" in
      -q)
        query="${2}"
        shift
        ;;
      -v)
        args+=("-v" "${2}")
        shift
        ;;
      -f)
        args+=("-f" "${ENHANCD_ROOT}/functions/enhancd/lib/ltsv.awk")
        args+=("-f" "${2}")
        query=""
        shift
        ;;
    esac
    shift
  done

  local default_query='{print $0}'
  local ltsv_script="$(command cat "${ENHANCD_ROOT}/functions/enhancd/lib/ltsv.awk")"
  local awk_scripts="${ltsv_script} ${query:-${default_query}}"

  __enhancd::command::awk ${args[@]} "${awk_scripts}"
}

__enhancd::ltsv::get()
{
  local opt="${1:?value of key short or long required}" key="${2}"
  __enhancd::ltsv::open \
    | __enhancd::command::grep -v -E '^(//|#)' \
    | __enhancd::ltsv::parse \
    -v opt="${opt}" \
    -v key="${key}" \
    -q 'ltsv("short") == opt || ltsv("long") == opt { if (key=="") { print $0 } else { print ltsv(key) } }'
}
