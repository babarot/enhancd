__enhancd::cd()
{
    local    arg
    local -i ret=0
    local -a opts args

    if ! __enhancd::core::is_available; then
        __enhancd::cd::builtin "${@:-$HOME}"
        return $?
    fi

    # Read from standard input
    if [[ -p /dev/stdin ]]; then
        args+=( "$(cat <&0)" )
    fi

    while (( $# > 0 ))
    do
        case $SHELL in
            *bash*)
                case "$1" in
                    "-P" | "-L" | "-e" | "-@")
                        opts+=( "$1" )
                        shift
                        continue
                        ;;
                esac
                ;;
            *zsh*)
                case "$1" in
                    "-q" | "-s" | "-L" | "-P")
                        opts+=( "$1" )
                        shift
                        continue
                        ;;
                esac
                ;;
        esac

        case "$1" in
            "$ENHANCD_HYPHEN_ARG")
                # If a hyphen is passed as the argument,
                # searchs from the last 10 directory items in the log
                args+=( "$(__enhancd::arguments::hyphen "$2")" )
                ret=$?
                ;;
            "$ENHANCD_DOT_ARG")
                # If a double-dot is passed as the argument,
                # it behaves like a zsh-bd plugin
                # In short, you can jump back to a specific directory,
                # without doing `cd ../../..`
                args+=( "$(__enhancd::arguments::dot "$2")" )
                ret=$?
                ;;
            "-")
                # When $ENHANCD_HYPHEN_ARG is configured,
                # this behaves like `cd -`
                args+=( "$OLDPWD" )
                ;;
            "..")
                # When $ENHANCD_DOT_ARG is configured,
                # ".." is passed to builtin cd
                args+=( ".." )
                ;;
            -* | --*)
                __enhancd::arguments::option "$@"
                return $?
                ;;
            "$ENHANCD_HOME_ARG")
                args+=( "$(__enhancd::arguments::none "$@")" )
                ret=$?
                ;;
            *)
                args+=( "$(__enhancd::arguments::given "$@")" )
                ret=$?
                ;;
        esac
        shift
    done

    if (( ${#args[@]} == 0 )); then
        args+=( "$(__enhancd::arguments::none "$@")" )
        ret=$?
    fi

    case $ret in
        $_ENHANCD_SUCCESS)
            __enhancd::cd::builtin ${opts[@]} ${args[@]}
            ret=$?
            ;;
        $_ENHANCD_FAILURE)
            echo "no such file or directory" >&2
            ;;
        *)
            ;;
    esac

    return $ret
}

__enhancd::cd::builtin()
{
    local -i ret=0

    # Case of pressing Ctrl-C in selecting
    if [[ -z $1 ]]; then
        return 0
    fi

    __enhancd::cd::before
    builtin cd "$@"
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
