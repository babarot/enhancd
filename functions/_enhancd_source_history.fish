function _enhancd_source_history
    set -l dir "$argv[1]"

    if test -d "$dir"
        echo "$dir"
        return 0
    end

    _enhancd_history_list "$dir"
end
