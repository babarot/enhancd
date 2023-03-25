function _enhancd_filter_fuzzy
    if test -z "$argv[1]"
        command cat <&0
    else
        _enhancd_command_awk \
            -f "$ENHANCD_ROOT/lib/fuzzy.awk" \
            -v search_string="$argv[1]"
    end
end
