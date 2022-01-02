function _enhancd_filter_limit
    read --local --list items
    set -l limit 10
    if set -q argv[1]
        set limit $argv[1]
    end
    echo $items[1..$limit]
end
