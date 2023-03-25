__enhancd::filepath::split()
{
    __enhancd::command::awk \
        -f "$ENHANCD_ROOT/functions/enhancd/lib/split.awk" \
        -v arg="${1:-$PWD}"
}

__enhancd::filepath::list_step()
{
    __enhancd::command::awk \
        -f "$ENHANCD_ROOT/functions/enhancd/lib/step_by_step.awk" \
        -v dir="${1:-$PWD}"
}

__enhancd::filepath::walk()
{
    command find "${1:-$PWD}" -maxdepth 1 -type d -name '\.*' -prune -o -type d -print
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
