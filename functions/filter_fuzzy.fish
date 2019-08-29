function filter_fuzzy
    if [ -z "$argv[1]" ]
        cat <&0
    else
        if [ "$ENHANCD_USE_FUZZY_MATCH" = 1 ]
            command_awk \
                -f "$ENHANCD_ROOT/lib/fuzzy.awk" \
                -v search_string="$argv[1]"
        else
            # Case-insensitive (don't use fuzzy searhing)
            command_awk '$0 ~ /\/.?'"$1"'[^\/]*$/{print $0}' 2>/dev/null
        end
    end
end
