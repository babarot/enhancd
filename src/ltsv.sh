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
            cat "${config}"
        fi
    done
}

__enhancd::ltsv::parse()
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

__enhancd::ltsv::get()
{
    local opt="${1}" key="${2}"
    __enhancd::ltsv::open \
        | __enhancd::filter::exclude_commented \
        | __enhancd::ltsv::parse -v opt="${opt}" -v key="${key}" -q 'ltsv("short")==opt||ltsv("long")==opt{print ltsv(key)}'
}
