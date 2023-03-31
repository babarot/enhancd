function _enhancd_source_mru
    test $ENHANCD_ENABLE_HYPHEN = false && echo "$OLDPWD" && return

    _enhancd_history_list "$argv[1]" \
        | _enhancd_filter_exclude "$HOME" \
        | _enhancd_filter_limit "$ENHANCD_HYPHEN_NUM"
end
