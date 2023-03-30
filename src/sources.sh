__enhancd::sources::parent_dirs()
{
  if ! ${ENHANCD_ENABLE_DOUBLE_DOT}; then
    echo ".."
    return 0
  fi

  __enhancd::filepath::get_parent_dirs "${PWD}"
}

__enhancd::sources::current_dirs()
{
  if ! ${ENHANCD_ENABLE_SINGLE_DOT}; then
    echo "."
    return 0
  fi

  __enhancd::filepath::get_dirs_in_cwd
}

__enhancd::sources::mru()
{
  if ! ${ENHANCD_ENABLE_HYPHEN}; then
    echo "${OLDPWD}"
    return 0
  fi

  __enhancd::history::list "${1}" \
    | __enhancd::filter::exclude "${HOME}" \
    | __enhancd::filter::limit "${ENHANCD_HYPHEN_NUM}"
}

__enhancd::sources::home()
{
  if ! ${ENHANCD_ENABLE_HOME}; then
    echo "${HOME}"
    return 0
  fi

  {
    echo "${HOME}"
    __enhancd::history::list
  } | __enhancd::filter::unique
}

__enhancd::sources::history()
{
  local dir="${1}"
  if [[ -d ${dir} ]]; then
    echo "${dir}"
    return 0
  fi

  __enhancd::history::list "${dir}"
}
