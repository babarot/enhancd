function _enhancd_history_list
    _enhancd_history_open \
        | _enhancd_filter_reverse \
        | _enhancd_filter_unique \
        | _enhancd_filter_exists \
        | _enhancd_filter_fuzzy "$argv" \
        | _enhancd_filter_exclude "$PWD"
end
