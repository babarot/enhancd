function _enhancd_history_exists
    if not set -q argv[1]
        return 1
    else
        set dir $argv[1]
    end

    _enhancd_history_open | string match -r -q "$dir" ^/dev/null >/dev/null
end
