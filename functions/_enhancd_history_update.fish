function _enhancd_history_update
    set -l list
    set -a list (_enhancd_history_exists; or _enhancd_filepath_walk)
    set -a list (_enhancd_history_open)
    set -a list "$HOME"
    echo $list \
        | _enhancd_filter_reverse \
        | _enhancd_filter_unique \
        | _enhancd_filter_reverse
    _enhancd_filepath_current_dir
end
