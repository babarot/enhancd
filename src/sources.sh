# Returns true if enhancd is ready to be available
__enhancd::sources::is_available()
{
    __enhancd::filepath::split_list "${ENHANCD_FILTER}" \
        &>/dev/null && [[ -s ${ENHANCD_DIR}/enhancd.log ]]
    return ${?}
}

__enhancd::sources::go_up()
{
    if [[ $ENHANCD_DISABLE_DOT == 1 ]]; then
        echo ".."
        return 0
    fi

    __enhancd::filepath::list_step "${PWD}" \
        | __enhancd::command::grep -E "${1}" \
        | __enhancd::filter::interactive \
        | __enhancd::filepath::abs

    # Returns false if __enhancd::filepath::abs fails
    # __enhancd::filepath::abs returns false
    # if __enhancd::filter::interactive doesn't output anything
    if [[ $? -eq 1 ]]; then
        if [[ -n $1 ]]; then
            # Returns false if an argument is given
            return $_ENHANCD_FAILURE
        else
            # Returns true when detecting to press Ctrl-C in selection
            return $_ENHANCD_SUCCESS
        fi
    fi
}

__enhancd::sources::mru()
{
    if [[ $ENHANCD_DISABLE_HYPHEN == 1 ]]; then
        echo "$OLDPWD"
        return 0
    fi

    __enhancd::history::list "$1" \
        | __enhancd::filter::exclude "$HOME" \
        | __enhancd::filter::limit "$ENHANCD_HYPHEN_NUM" \
        | __enhancd::filter::interactive
}

__enhancd::sources::default()
{
    if [[ $ENHANCD_DISABLE_HOME == 1 ]]; then
        echo "$HOME"
        return 0
    fi

    {
        __enhancd::entry::git::root
        __enhancd::history::list
    } | __enhancd::filter::interactive
}

__enhancd::sources::argument()
{
    local dir="${1}"

    if [[ -d ${dir} ]]; then
        echo "${dir}"
        return 0
    fi

    __enhancd::history::list "${dir}" | __enhancd::filter::interactive
}
