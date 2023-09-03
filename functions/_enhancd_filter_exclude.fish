function _enhancd_filter_exclude
    read --list --local input
    echo (string match -v "$argv[1]" -- $input)
    or true
end
