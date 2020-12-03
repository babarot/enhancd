__enhancd::flag::parse()
{
    local opt="$1" arg="$2" func

    func="$(__enhancd::ltsv::get "${opt}" "func")"
    cond="$(__enhancd::ltsv::get "${opt}" "condition")"

    if ! __enhancd::command::run "${cond}"; then
        echo "${opt}: defined but require '${cond}'" >&2
        return 1
    fi

    if [[ -z ${func} ]]; then
        echo "${opt}: no such option" >&2
        return 1
    fi

    if __enhancd::command::which ${func}; then
        ${func} "${arg}"
    else
        echo "${func}: no such function defined" >&2
        return 1
    fi
}

__enhancd::flag::is_default()
{
    local opt=$1
    case $SHELL in
        *bash)
            case "$opt" in
                "-P" | "-L" | "-e" | "-@")
                    return 0
                    ;;
            esac
            ;;
        *zsh)
            case "$opt" in
                "-q" | "-s" | "-L" | "-P")
                    return 0
                    ;;
            esac
            ;;
    esac
    return 1
}

__enhancd::flag::print_help()
{
    __enhancd::ltsv::open \
        | __enhancd::command::awk -f "$ENHANCD_ROOT/functions/enhancd/lib/help.awk"
    return $?
}
