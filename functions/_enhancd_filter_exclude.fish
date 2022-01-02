function _enhancd_filter_exclude
    # _enhancd_command_grep -v -x "$argv[1]"
    # echo "$input" | _enhancd_command_grep -v -x "$argv[1]"; or true
    read --list --local input
    set -l items (string match -v "$argv[1]" $input)
    echo $items
end
