function history_list
    history_open \
        | filter_reverse \
        | filter_unique \
        | filter_exists \
        | filter_fuzzy "$argv" \
        | filter_exclude "$PWD"
end
