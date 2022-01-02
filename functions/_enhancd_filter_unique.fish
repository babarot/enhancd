# _enhancd_filter_unique uniques a stdin contents
function _enhancd_filter_unique
    set -l items
    if test -n "$argv[1]"; and test -f "$argv[1]"
        set -a items "$argv[1]"
    else
        read --list items
    end
    set items (echo -e (string join '\n' $items) | _enhancd_command_awk '!a[$0]++' 2>/dev/null)
    echo $items
end
