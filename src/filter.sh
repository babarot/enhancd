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

__enhancd::filter::join()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        command cat "$1"
    else
        command cat <&0
    fi | __enhancd::command::awk 'a[$0]++' 2>/dev/null
}

# __enhancd::filter::unique uniques a stdin contents
__enhancd::filter::unique()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        command cat "$1"
    else
        command cat <&0
    fi | __enhancd::command::awk '!a[$0]++' 2>/dev/null
}

# __enhancd::filter::reverse reverses a stdin contents
__enhancd::filter::reverse()
{
    if [[ -n $1 ]] && [[ -f $1 ]]; then
        command cat "$1"
    else
        command cat <&0
    fi \
        | __enhancd::command::awk -f "$ENHANCD_ROOT/functions/enhancd/lib/reverse.awk" \
        2>/dev/null
}

__enhancd::filter::fuzzy()
{
    if [[ -z $1 ]]; then
        cat <&0
    else
        if [[ $ENHANCD_USE_FUZZY_MATCH == 1 ]]; then
            __enhancd::command::awk \
                -f "$ENHANCD_ROOT/functions/enhancd/lib/fuzzy.awk" \
                -v search_string="$1"
        else
            # Case-insensitive (don't use fuzzy searhing)
            __enhancd::command::awk '$0 ~ /\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null
        fi
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
        return $_ENHANCD_FAILURE
    fi

    local filter
    filter="$(__enhancd::filepath::split_list "$ENHANCD_FILTER")"

    local -i count
    count="$(echo "${stdin}" | __enhancd::command::grep -c "")"

    case "${count}" in
        1)
            if [[ -n ${stdin} ]]; then
                echo "${stdin}"
            else
                return $_ENHANCD_FAILURE
            fi
            ;;
        *)
            local selected
            selected="$(echo "${stdin}" | eval ${filter})"
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

__enhancd::filter::exclude_commented()
{
    __enhancd::command::grep -v -E '^(//|#)' || true
}

__enhancd::filter::replace()
{
    local old new
    old="${1:?too few argument}"
    new="${2:-""}"
    __enhancd::command::awk \
        -v old="${old}" \
        -v new="${new}" \
        'sub(old, new, $0) {print $0}'
}

__enhancd::filter::trim()
{
    local str
    str="${1:?too few argument}"
    __enhancd::filter::replace "${str}"
}

__enhancd::filter::limit()
{
    command head -n "${1:-10}"
}

__enhancd::filter::exclude_gitignore()
{
    local -a ignores=()
    if [[ -f $PWD/.gitignore ]]; then
        ignores+=(".git")
    else
        # just do read the input and do output
        # if no gitignore file
        command cat <&0
        return 0
    fi

    local ignore
    while read ignore
    do
        if [[ -d ${ignore} ]]; then
            ignores+=( "$(command basename ${ignore})" )
        fi
    done <${PWD}/.gitignore

    contains() {
        local input ignore
        input=${1:?need one argument}
        for ignore in "${ignores[@]}"
        do
            # https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Shell-Parameter-Expansion
            if [[ ${input} =~ ${ignore//\./\\.} ]]; then
                return 0
            fi
        done
        return 1
    }

    local line
    while read line
    do
        if contains ${line}; then
            continue
        fi
        echo "${line}"
    done
}
