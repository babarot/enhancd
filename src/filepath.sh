# Currently this is not used
__enhancd::filepath::split()
{
  __enhancd::command::awk -f "${ENHANCD_ROOT}/functions/enhancd/lib/split.awk" -v arg="${1:-$PWD}"
}

__enhancd::filepath::get_parent_dirs()
{
  __enhancd::command::awk -f "${ENHANCD_ROOT}/functions/enhancd/lib/step_by_step.awk" -v dir="${1:-$PWD}"
}

__enhancd::filepath::walk()
{
  local -a dirs

  # __enhancd::filepath::get_parent_dirs does not return $PWD itself,
  # so add it to the array explicitly
  dirs=( "${PWD}" $(__enhancd::filepath::get_parent_dirs "${1:-${PWD}}") )

  for dir in "${dirs[@]}"
  do
    command find "${dir}" -maxdepth 1 -type d -name '\.*' -prune -o -type d -print
  done
}

__enhancd::filepath::current_dir()
{
  echo "${PWD:-$(command pwd)}"
}

# Currently this is not used
__enhancd::filepath::abs()
{
  local cwd dir
  cwd="${PWD%/*}"
  dir="${1}"

  if [[ -p /dev/stdin ]]; then
    dir="$(command cat <&0)"
  fi

  if [[ -z ${dir} ]]; then
    return 1
  fi

  __enhancd::command::awk \
    -f "${ENHANCD_ROOT}/functions/enhancd/lib/to_abspath.awk" \
    -v cwd="${cwd}" \
    -v dir="${dir}"
}

__enhancd::filepath::get_dirs_in_cwd()
{
  # https://github.com/sharkdp/fd
  if type fd &>/dev/null; then
    # using fd command gives better results than find command
    command fd --type d --hidden -E .git
    return ${?}
  fi

  # https://unix.stackexchange.com/questions/611685/finding-all-directories-except-hidden-ones
  # cut is needed fot triming "./" from the output
  LC_ALL=C command find . ! -name . \( -name '.*' -prune -o -type d -print \) | cut -c3-
}
