function ltsv_get
    set -l opt
    set -l key

    if ! set -q argv[1]
        return 1
    else
        set opt $argv[1]
    end

    set key "$argv[2]"

    ltsv_open \
        | filter_exclude_commented \
        | ltsv_parse \
        -v opt="$opt" \
        -v key="$key" \
        -q 'ltsv("short") == opt || ltsv("long") == opt { if (key=="") { print $0 } else { print ltsv(key) } }'
end