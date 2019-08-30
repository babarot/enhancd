function _enhancd_source_default
    if [ "$ENHANCD_DISABLE_HOME" = 1 ]
        echo "$HOME"
        return 0
    end
    _enhancd_history_list | _enhancd_filter_interactive "$list"

end
