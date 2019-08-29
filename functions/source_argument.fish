function source_argument
    set -l dir "$argv[1]"

    if [ -d "$dir" ]
        echo "$dir"
        return 0
    end
    
    history_list "$dir" | filter_interactive
end