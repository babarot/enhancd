function _enhancd_source_mru
    test $ENHANCD_DISABLE_HYPHEN = 1 && echo "$OLDPWD" && return

    _enhancd_history_list "$argv[1]" \
        | _enhancd_filter_exclude "$HOME" \
        | _enhancd_filter_limit "$ENHANCD_HYPHEN_NUM" \
        | _enhancd_filter_interactive "$list"
end
