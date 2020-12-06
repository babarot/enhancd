# Splits a list of commands joined by the colon, found in PATH environment variables
__enhancd::filepath::split_list()
{
    local item str

    if [[ -z ${1} ]]; then
        return 1
    fi

    # str should be list like "a:b:c" concatenated by a colon
    str="${1}:"

    while [[ -n ${str} ]]; do
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

# Splits a path with a slash
__enhancd::filepath::split()
{
    __enhancd::command::awk \
        -f "$ENHANCD_ROOT/functions/enhancd/lib/split.awk" \
        -v arg="${1:-$PWD}"
}

# Lists a path step-wisely
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
