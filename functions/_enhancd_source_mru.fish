function _enhancd_source_mru
    if test $ENHANCD_DISABLE_HYPHEN = 1
        echo "$OLDPWD"
        return 0
    end

    _enhancd_history_list "$argv[1]" \
        | _enhancd_filter_exclude "$HOME" \
        | _enhancd_filter_limit "$ENHANCD_HYPHEN_NUM" \
        | _enhancd_filter_interactive "$list"
end
