__enhancd::cd()
{
    local    arg
    local -i code=0
    local -a args opts

    if ! __enhancd::cd::available; then
        __enhancd::cd::builtin "${@:-$HOME}"
        return $?
    fi

    # Read from standard input
    if [[ -p /dev/stdin ]]; then
        args+=( "$(cat <&0)" )
    fi

    while (( $# > 0 ))
    do
        case "$1" in
            --help)
                __enhancd::flag::help
                return $?
                ;;
            "$ENHANCD_HYPHEN_ARG")
                # If a hyphen is passed as the argument,
                # searchs from the last 10 directory items in the log
                args+=( "$(__enhancd::arguments::hyphen "$2")" )
                code=$?
                ;;
            "-")
                # When $ENHANCD_HYPHEN_ARG is configured,
                # this behaves like `cd -`
                args+=( "$OLDPWD" )
                ;;
            "$ENHANCD_DOT_ARG")
                # If a double-dot is passed as the argument,
                # it behaves like a zsh-bd plugin
                # In short, you can jump back to a specific directory,
                # without doing `cd ../../..`
                args+=( "$(__enhancd::arguments::dot "$2")" )
                code=$?
                ;;
            "..")
                # When $ENHANCD_DOT_ARG is configured,
                # ".." is passed to builtin cd
                args+=( ".." )
                ;;
            "$ENHANCD_HOME_ARG")
                args+=( "$(__enhancd::arguments::none)" )
                code=$?
                ;;
            -* | --*)
                if __enhancd::flag::is_default "${1}"; then
                    opts+=( "${1}" )
                else
                    args+=( "$(__enhancd::arguments::option "${1}")" )
                    code=$?
                fi
                ;;
            *)
                args+=( "$(__enhancd::arguments::given "$1")" )
                code=$?
                ;;
        esac
        shift
    done

    case ${#args[@]} in
        0)
            args+=( "$(__enhancd::arguments::none)" )
            code=$?
            ;;
    esac

    case "${code}" in
        0)
            __enhancd::cd::builtin "${opts[@]}" "${args[@]}"
            return $?
            ;;
        *)
            return 1
            ;;
    esac
}

# Returns true if enhancd is ready to be available
__enhancd::cd::available()
{
    __enhancd::filepath::split_list "${ENHANCD_FILTER}" \
        &>/dev/null && [[ -s ${ENHANCD_DIR}/enhancd.log ]]
    return ${?}
}

__enhancd::cd::builtin()
{
    local -i code=0

    __enhancd::cd::before
    builtin cd "$@"
    code=$?
    __enhancd::cd::after

    return $code
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
