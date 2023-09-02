function _enhancd_source_home
    if test "$ENHANCD_ENABLE_HOME" = false
        echo "$HOME"
        return 0
    end

    begin
        set -l list (_enhancd_history_list)
        set -a list "$HOME"
        echo $list
    end | _enhancd_filter_unique
end
