# _enhancd_filter_reverse reverses a stdin contents
function _enhancd_filter_reverse
    if test -n "$argv[1]"; and test -f "$argv[1]"
        command cat "$argv[1]"
    else
        command cat <&0
    end \
        | _enhancd_command_awk -f "$ENHANCD_ROOT/lib/reverse.awk" \
        2>/dev/null
end
