function _enhancd_history_update
    begin
        _enhancd_history_exists; or _enhancd_filepath_walk
        _enhancd_history_open
        echo "$HOME"
    end | _enhancd_filter_reverse \
    | _enhancd_filter_unique \
    | _enhancd_filter_reverse
    _enhancd_filepath_current_dir
end
