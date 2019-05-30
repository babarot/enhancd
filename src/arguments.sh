__enhancd::arguments::hyphen()
{
    if [[ $ENHANCD_DISABLE_HYPHEN == 1 ]]; then
        echo "$OLDPWD"
        return 0
    fi

    __enhancd::history::list "$1" \
        | __enhancd::filter::exclude_by "$HOME" \
        | head -n "$ENHANCD_HYPHEN_NUM" \
        | __enhancd::filter::interactive
}

__enhancd::arguments::dot()
{
    if [[ $ENHANCD_DISABLE_DOT == 1 ]]; then
        echo ".."
        return 0
    fi

    __enhancd::filepath::list_step "${PWD}" \
        | __enhancd::command::grep "$1" \
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

__enhancd::arguments::none()
{
    if [[ $ENHANCD_DISABLE_HOME == 1 ]]; then
        echo "$HOME"
        return 0
    fi

    __enhancd::history::list | __enhancd::filter::interactive
}

__enhancd::arguments::given()
{
    local dir="${1}"

    if [[ -d ${dir} ]]; then
        echo "${dir}"
        return 0
    fi

    __enhancd::history::list "${dir}" | __enhancd::filter::interactive
}
