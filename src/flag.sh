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
    local config="$(__enhancd::ltsv::open)"

cat <<HELP
usage: cd [OPTIONS] [dir]

OPTIONS:
HELP

if [[ -n ${config} ]]; then
    echo "${config}" \
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
