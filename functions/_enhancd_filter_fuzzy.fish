function _enhancd_filter_fuzzy
    if test -z "$argv[1]"
        command cat <&0
    else
        "$ENHANCD_AWK_CMD" \
            -f "$ENHANCD_ROOT/lib/fuzzy.awk" \
            -v search_string="$argv[1]"
    end
end
