function _enhancd_ltsv_get
    set -l opt
    set -l key

    if not set -q argv[1]
        return 1
    else
        set opt $argv[1]
    end

    set key "$argv[2]"

    _enhancd_ltsv_open \
        | _enhancd_filter_exclude_commented \
        | _enhancd_ltsv_parse \
        -v opt="$opt" \
        -v key="$key" \
        -q 'ltsv("short") == opt || ltsv("long") == opt { if (key=="") { print $0 } else { print ltsv(key) } }'
end
