__enhancd::cd()
{
    # t is an argument of the list for __enhancd::interface
    local    t arg="$1"
    local -i ret=0

    if ! __enhancd::utils::available "$ENHANCD_FILTER" &>/dev/null; then
        builtin cd "${arg:-$HOME}"
        return $?
    fi

    # Read from standard input
    if [[ -p /dev/stdin ]]; then
        t="$(cat <&0)"
        arg=":stdin:"
    fi

    case "$arg" in
        ":stdin:")
            ;;
        "$ENHANCD_HYPHEN_ARG")
            # If a hyphen is passed as the argument,
            # searchs from the last 10 directory items in the log
            t="$(__enhancd::arguments::hyphen "$2")"
            ret=$?
            ;;
        "$ENHANCD_DOT_ARG")
            # If a double-dot is passed as the argument,
            # it behaves like a zsh-bd plugin
            # In short, you can jump back to a specific directory,
            # without doing `cd ../../..`
            t="$(__enhancd::arguments::dot "$2")"
            ret=$?
            ;;
        "-")
            # When $ENHANCD_HYPHEN_ARG is configured,
            # this behaves like `cd -`
            t="$OLDPWD"
            ;;
        "..")
            # When $ENHANCD_DOT_ARG is configured,
            # ".." is passed to builtin cd
            t=".."
            ;;
        -* | --*)
            __enhancd::arguments::option "$@"
            return $?
            ;;
        "")
            t="$(__enhancd::arguments::none "$@")"
            ret=$?
            ;;
        *)
            t="$(__enhancd::arguments::given "$@")"
            ret=$?
            ;;
    esac

    case $ret in
        $_ENHANCD_SUCCESS)
            # Case of pressing Ctrl-C in selecting
            if [[ -z $t ]]; then
                return 0
            fi
            builtin cd "$t"
            ret=$?
            __enhancd::sync
            ;;
        $_ENHANCD_FAILURE)
            __enhancd::utils::die \
                "${t:-$2}: no such file or directory\n"
            ;;
        *)
            ;;
    esac

    return $ret
}
