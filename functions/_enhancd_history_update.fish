function _enhancd_history_update
    function sub
        _enhancd_filepath_list_step | _enhancd_filter_reverse
        _enhancd_filepath_walk
        _enhancd_history_open
        echo "$HOME"
    end
    sub \
        | _enhancd_filter_reverse \
        | _enhancd_filter_unique \
        | _enhancd_filter_reverse
    _enhancd_filepath_current_dir
end