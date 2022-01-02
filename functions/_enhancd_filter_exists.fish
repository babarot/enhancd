function _enhancd_filter_exists
    read --list --local lines
    set -l items
    for line in $lines
        if test -d "$line"
            set -a items "$line"
        end
    end
    echo $items
end
