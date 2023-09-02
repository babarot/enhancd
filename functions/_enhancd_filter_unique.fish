# _enhancd_filter_unique uniques a stdin contents
function _enhancd_filter_unique
    set -l items
    read --list --local items
    echo (string join \n -- $items | _enhancd_command_awk '!a[$0]++' 2>/dev/null)
end
