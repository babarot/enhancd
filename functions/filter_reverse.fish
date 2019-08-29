# filter_reverse reverses a stdin contents
function filter_reverse
    if [ -n "$argv[1]" ] && [ -f "$argv[1]" ]
        cat "$argv[1]"
    else
        cat <&0
    end \
        | command_awk -f "$ENHANCD_ROOT/lib/reverse.awk" \
        2>/dev/null
end
