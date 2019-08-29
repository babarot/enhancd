function history_update
    function sub
        filepath_list_step | filter_reverse
        filepath_walk
        history_open
        echo "$HOME"
    end
    sub \
        | filter_reverse \
        | filter_unique \
        | filter_reverse
    filepath_current_dir
end