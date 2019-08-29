function source_mru
    if [ $ENHANCD_DISABLE_HYPHEN = 1 ]
        echo "$OLDPWD"
        return 0
    end

        history_list "$argv[1]" \
        | filter_exclude "$HOME" \
        | filter_limit "$ENHANCD_HYPHEN_NUM" \
        | filter_interactive "$list"
end
