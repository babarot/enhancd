__enhancd::history::open()
{
  if [[ -f ${ENHANCD_DIR}/enhancd.log ]]; then
    command cat "${ENHANCD_DIR}/enhancd.log"
    return ${?}
  fi
  return 1
}

__enhancd::history::exists()
{
  local dir="${1}"
  if [[ -z ${dir} ]]; then
    return 1
  fi

  __enhancd::history::open | __enhancd::command::grep "${dir}" &>/dev/null
}

__enhancd::history::list()
{
  __enhancd::history::open \
    | __enhancd::filter::reverse \
    | __enhancd::filter::unique \
    | __enhancd::filter::exists \
    | __enhancd::filter::fuzzy "${@}" \
    | __enhancd::filter::exclude "${PWD}"
}

__enhancd::history::update()
{
  if __enhancd::helper::check_included_in_colon_delimited_string "${PWD}" "${ENHANCD_PATHS_IGNORE_ADDING_HISTORY}"; then
    # skip update if included in the env
    return 0
  fi

  {
    __enhancd::history::exists "${PWD}" || __enhancd::filepath::walk
    __enhancd::history::open
    echo "${HOME}"
  } | __enhancd::filter::reverse  | __enhancd::filter::unique  | __enhancd::filter::reverse
  __enhancd::filepath::current_dir
}
