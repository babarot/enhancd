function _enhancd_source_home
    if test "$ENHANCD_ENABLE_HOME" = false
        echo "$HOME"
        return 0
    end

    begin
        echo "$HOME"
        _enhancd_history_list
    end | _enhancd_filter_unique
end
