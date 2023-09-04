function _enhancd_filter_limit
    set -l limit
    if not set -q $argv[1]
        set limit 10
    else
        set limit $argv[1]
    end
    command head -n "$limit"
end
