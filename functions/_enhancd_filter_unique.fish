# _enhancd_filter_unique uniques a stdin contents
function _enhancd_filter_unique
    if test -n "$argv[1]"; and test -f "$argv[1]"
        command cat "$argv[1]"
    else
        command cat <&0
    end | "$ENHANCD_AWK_CMD" '!a[$0]++' 2>/dev/null
end
