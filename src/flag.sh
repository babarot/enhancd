__enhancd::flag::ltsv_parse()
{
    if [[ ! -p /dev/stdin ]]; then
        return 1
    fi

    local -a args
    local query
    while (( $# > 0 ))
    do
        case "$1" in
            -q)
                query="$2"
                shift
                ;;
            -v)
                args+=("-v" "$2")
                shift
                ;;
        esac
        shift
    done

    local default_query='{print $0}'
    local ltsv_script="$(cat "$ENHANCD_ROOT/src/share/ltsv.awk")"
    local awk_scripts="${ltsv_script} ${query:-$default_query}"

    __enhancd::command::awk ${args[@]} "${awk_scripts}"
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

__enhancd::flag::help()
{
    local config="$ENHANCD_ROOT/src/custom/config.ltsv"

cat <<HELP
usage: cd [OPTIONS] [dir]

OPTIONS:
HELP

if [[ -f $config ]]; then
    cat "$config" \
        | __enhancd::filter::exclude_commented \
        |
    while IFS=$'\t' read short long desc action
    do
        if [[ -z ${short#*:} ]]; then
            command printf "  %s  %-15s %s\n" "  "          "${long#*:}" "${desc#*:}"
        elif [[ -z ${long#*:} ]]; then
            command printf "  %s  %-15s %s\n" "${short#*:}" ""           "${desc#*:}"
        else
            command printf "  %s, %-15s %s\n" "${short#*:}" "${long#*:}" "${desc#*:}"
        fi
    done
else
    printf "  nothing yet\n"
fi

cat <<HELP

Version: $_ENHANCD_VERSION
HELP
}
