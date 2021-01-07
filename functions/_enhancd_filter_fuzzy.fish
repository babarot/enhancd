function _enhancd_filter_fuzzy
    if test -z "$argv[1]"
        command cat <&0
    else
        if test "$ENHANCD_USE_FUZZY_MATCH" = 1
            _enhancd_command_awk \
                -f "$ENHANCD_ROOT/lib/fuzzy.awk" \
                -v search_string="$argv[1]"
        else
            # Case-insensitive (don't use fuzzy searhing)
            _enhancd_command_awk '$0 ~ /\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null
        end
    end
end
