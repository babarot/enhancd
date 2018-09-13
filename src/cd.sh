__enhancd::cd()
{
    # t is an argument of the list for __enhancd::interface
    local    t arg="$1"
    local -i ret=0

    if ! __enhancd::utils::available; then
        __enhancd::cd::builtin "${@:-$HOME}"
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
        "$ENHANCD_HOME_ARG")
            t="$(__enhancd::arguments::none "$@")"
            ret=$?
            ;;
        "")
            t="$(__enhancd::arguments::empty)"
            ret=$?
            ;;
        *)
            t="$(__enhancd::arguments::given "$@")"
            ret=$?
            ;;
    esac

    case $ret in
        $_ENHANCD_SUCCESS)
            __enhancd::cd::builtin "$t"
            ret=$?
            ;;
        $_ENHANCD_FAILURE)
            __enhancd::path::not_found "${t:-${2:-$1}}" &&
                {
                    __enhancd::cd::builtin "${t:-${2:-$1}}"
                }
            ret=$?
            ;;
        *)
            ;;
    esac

    return $ret
}

__enhancd::cd::builtin()
{
    local -i ret=0
    local    dir="$1"

    # Case of pressing Ctrl-C in selecting
    if [[ -z $dir ]]; then
        return 0
    fi

    if [[ ! -d $dir ]]; then
        __enhancd::path::not_found "$dir"
        return $?
    fi

    __enhancd::cd::before
    builtin cd "$dir"
    ret=$?
    __enhancd::cd::after

    return $ret
}

__enhancd::cd::before()
{
    :
}

__enhancd::cd::after()
{
    local list
    list="$(__enhancd::history::update)"

    if [[ -n $list ]]; then
        echo "$list" >| "$ENHANCD_DIR/enhancd.log"
    fi

    if [[ -n $ENHANCD_HOOK_AFTER_CD ]]; then
        eval "$ENHANCD_HOOK_AFTER_CD"
    fi
}
