__enhancd::ltsv::open()
{
    local -a configs
    configs=(
    "$ENHANCD_ROOT/config.ltsv"
    "$ENHANCD_DIR/config.ltsv"
    )

    local config
    for config in "${configs[@]}"
    do
        if [[ -f ${config} ]]; then
            command cat "${config}"
        fi
    done
}

__enhancd::ltsv::parse()
{
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
            -f)
                args+=("-f" "$ENHANCD_ROOT/functions/enhancd/lib/ltsv.awk")
                args+=("-f" "$2")
                query=""
                shift
                ;;
        esac
        shift
    done

    local default_query='{print $0}'
    local ltsv_script="$(command cat "$ENHANCD_ROOT/functions/enhancd/lib/ltsv.awk")"
    local awk_scripts="${ltsv_script} ${query:-$default_query}"

    __enhancd::command::awk ${args[@]} "${awk_scripts}"
}

__enhancd::ltsv::get()
{
    local opt="${1:?value of key short or long required}" key="${2}"
    __enhancd::ltsv::open \
        | __enhancd::filter::exclude_commented \
        | __enhancd::ltsv::parse \
        -v opt="${opt}" \
        -v key="${key}" \
        -q 'ltsv("short") == opt || ltsv("long") == opt { if (key=="") { print $0 } else { print ltsv(key) } }'
}
